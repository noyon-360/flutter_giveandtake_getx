import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../../company/data/model/seach_all_user_response_model.dart';
import '../../../job_listing/data/models/job_model.dart';
import '../../domain/repo/search_repository.dart';

/// Drives BOTH the drawer typeahead and the full SearchResultsScreen so the
/// query stays in sync (mirrors the web GlobalSearch + /all-users flow).
///
/// People: GET /fetch/all/users?q= returns the whole filtered set per query;
/// we drop admin/super-admin, sort immediately-available candidates first,
/// expose the top 8 as [suggestions] for the dropdown, and client-paginate the
/// rest for the results screen. Jobs: GET /jobs?title=&page=&limit= is
/// server-paginated (infinite scroll), loaded only while the results screen is
/// open to avoid extra calls during drawer typing.
class GlobalSearchController extends GetxController {
  final SearchRepository _repo;

  GlobalSearchController(this._repo);

  // ---- Shared query ----
  final query = ''.obs;
  Worker? _debounceWorker;

  // ---- People ----
  final RxList<SeachAllUserResponseModel> peopleAll =
      <SeachAllUserResponseModel>[].obs;
  final RxList<SeachAllUserResponseModel> suggestions =
      <SeachAllUserResponseModel>[].obs;
  final RxList<SeachAllUserResponseModel> peopleVisible =
      <SeachAllUserResponseModel>[].obs;
  final isPeopleLoading = false.obs;
  final peopleError = ''.obs;

  int _peoplePage = 1;
  static const int _peoplePageSize = 12;
  final peopleHasMore = false.obs;

  // People filters (client-side)
  final selectedRole = 'All Roles'.obs; // All Roles / candidate / recruiter / company
  final isImmediate = false.obs;

  CancelToken? _peopleCancelToken;

  // ---- Jobs ----
  final RxList<JobModel> jobs = <JobModel>[].obs;
  final isJobsLoading = false.obs;
  final isJobsMoreLoading = false.obs;
  final jobsError = ''.obs;
  final jobsTotalItems = 0.obs;
  final jobsHasMore = false.obs;
  int _jobsPage = 1;
  int _jobsTotalPages = 1;

  /// True only while the full SearchResultsScreen is mounted; gates job fetches
  /// so the drawer typeahead (people only) doesn't trigger job calls.
  bool resultsScreenActive = false;

  int get immediateCount =>
      peopleAll.where((u) => u.immediatelyAvailable == true).length;

  @override
  void onInit() {
    super.onInit();
    _debounceWorker = debounce<String>(
      query,
      (q) => _runSearch(q.trim()),
      time: const Duration(milliseconds: 300),
    );
  }

  /// Wire to the search TextField onChanged.
  void onQueryChanged(String value) => query.value = value;

  void _runSearch(String q) {
    if (q.isEmpty) {
      _peopleCancelToken?.cancel();
      peopleAll.clear();
      suggestions.clear();
      peopleVisible.clear();
      jobs.clear();
      peopleHasMore.value = false;
      jobsHasMore.value = false;
      peopleError.value = '';
      jobsError.value = '';
      return;
    }
    fetchPeople(q);
    if (resultsScreenActive) fetchJobs(isRefresh: true);
  }

  // ---- People ----
  Future<void> fetchPeople(String q) async {
    isPeopleLoading.value = true;
    peopleError.value = '';
    _peopleCancelToken?.cancel();
    final token = CancelToken();
    _peopleCancelToken = token;

    final result = await _repo.searchPeople(q, cancelToken: token);

    // A newer keystroke cancelled this request — it now owns the loading flag.
    if (token.isCancelled) return;

    result.fold(
      (failure) => peopleError.value = failure.message,
      (success) {
        final filtered = success.data.where((u) {
          final r = u.role.toLowerCase();
          return r != 'admin' && r != 'super-admin' && r != 'superadmin';
        }).toList();

        // Immediately-available candidates first (stable).
        filtered.sort((a, b) {
          final ai = (a.immediatelyAvailable == true &&
                  a.role.toLowerCase() == 'candidate')
              ? 0
              : 1;
          final bi = (b.immediatelyAvailable == true &&
                  b.role.toLowerCase() == 'candidate')
              ? 0
              : 1;
          return ai.compareTo(bi);
        });

        peopleAll.assignAll(filtered);
        suggestions.assignAll(filtered.take(8).toList());
        _peoplePage = 1;
        _applyPeopleFiltersAndPage();
      },
    );
    isPeopleLoading.value = false;
  }

  void _applyPeopleFiltersAndPage() {
    var list = peopleAll.toList();
    final role = selectedRole.value;
    if (role != 'All Roles') {
      list = list
          .where((u) => u.role.toLowerCase() == role.toLowerCase())
          .toList();
    }
    if (isImmediate.value) {
      list = list.where((u) => u.immediatelyAvailable == true).toList();
    }
    final visibleCount = (_peoplePage * _peoplePageSize).clamp(0, list.length);
    peopleVisible.assignAll(list.take(visibleCount).toList());
    peopleHasMore.value = visibleCount < list.length;
  }

  void loadMorePeople() {
    if (peopleHasMore.value) {
      _peoplePage++;
      _applyPeopleFiltersAndPage();
    }
  }

  void updateRole(String role) {
    selectedRole.value = role;
    _peoplePage = 1;
    _applyPeopleFiltersAndPage();
  }

  void toggleImmediate(bool value) {
    isImmediate.value = value;
    _peoplePage = 1;
    _applyPeopleFiltersAndPage();
  }

  void clearFilters() {
    selectedRole.value = 'All Roles';
    isImmediate.value = false;
    _peoplePage = 1;
    _applyPeopleFiltersAndPage();
  }

  // ---- Jobs ----
  /// Called by SearchResultsScreen on open: loads jobs for the current query
  /// and enables job refresh on subsequent query changes.
  void onResultsScreenOpen() {
    resultsScreenActive = true;
    final q = query.value.trim();
    if (q.isEmpty) return;
    if (peopleAll.isEmpty && !isPeopleLoading.value) fetchPeople(q);
    fetchJobs(isRefresh: true);
  }

  void onResultsScreenClose() => resultsScreenActive = false;

  Future<void> fetchJobs({bool isRefresh = false}) async {
    final q = query.value.trim();
    if (q.isEmpty) {
      jobs.clear();
      jobsHasMore.value = false;
      return;
    }
    if (isRefresh) {
      _jobsPage = 1;
      _jobsTotalPages = 1;
    }
    if (_jobsPage == 1) {
      isJobsLoading.value = true;
    } else {
      isJobsMoreLoading.value = true;
    }
    jobsError.value = '';

    final result = await _repo.searchJobs(title: q, page: _jobsPage, limit: 10);

    result.fold(
      (failure) => jobsError.value = failure.message,
      (success) {
        final data = success.data;
        if (data.meta != null) {
          _jobsPage = data.meta!.currentPage;
          _jobsTotalPages = data.meta!.totalPages;
          jobsTotalItems.value = data.meta!.totalItems;
        }
        if (_jobsPage == 1) {
          jobs.assignAll(data.jobs);
        } else {
          jobs.addAll(data.jobs);
        }
        jobsHasMore.value = _jobsPage < _jobsTotalPages;
      },
    );

    isJobsLoading.value = false;
    isJobsMoreLoading.value = false;
  }

  void loadMoreJobs() {
    if (jobsHasMore.value && !isJobsMoreLoading.value && !isJobsLoading.value) {
      _jobsPage++;
      fetchJobs();
    }
  }

  @override
  void onClose() {
    _debounceWorker?.dispose();
    _peopleCancelToken?.cancel();
    super.onClose();
  }
}
