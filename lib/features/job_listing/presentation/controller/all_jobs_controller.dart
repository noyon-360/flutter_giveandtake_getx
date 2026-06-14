import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../../../core/network/network_result.dart';
import '../../../../core/network/services/auth_storage_service.dart';
import '../../data/models/job_listing_response_model.dart';
import '../../data/models/job_model.dart';
import '../../domain/usecases/get_jobs_usecase.dart';

class AllJobsController extends GetxController {
  final GetJobsUseCase _getJobsUseCase;

  AllJobsController(this._getJobsUseCase);

  // State
  var isLoading = false.obs;
  var isMoreLoading = false.obs;
  var jobList = <JobModel>[].obs;

  // Current user role — gates the Apply button (candidates/guests only).
  final role = Rxn<String>();
  bool get canApply {
    final r = role.value?.trim().toLowerCase();
    return r != 'recruiter' && r != 'company';
  }

  // Pagination
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  var totalItems = 0.obs;
  final int itemsPerPage = 10;

  // Search
  final searchController = TextEditingController();
  var searchText = ''.obs;
  Worker? _debounceWorker;

  @override
  void onInit() {
    super.onInit();
    _loadRole();
    // Debounce search input
    _debounceWorker = debounce(searchText, (callback) {
      if (callback.length > 2 || callback.isEmpty) {
        fetchJobs(isRefresh: true);
      }
    }, time: const Duration(milliseconds: 500));
    
    fetchJobs();
  }

  Future<void> _loadRole() async {
    role.value = (await AuthStorageService().getUserRole())?.trim().toLowerCase();
  }

  @override
  void onClose() {
    _debounceWorker?.dispose();
    searchController.dispose();
    super.onClose();
  }

  Future<void> fetchJobs({bool isRefresh = false}) async {
    if (isRefresh) {
      currentPage.value = 1;
      jobList.clear();
      totalPages.value = 1;
    }

    if (currentPage.value == 1) {
      isLoading.value = true;
    } else {
      isMoreLoading.value = true;
    }

    final result = await _getJobsUseCase(
      page: currentPage.value,
      limit: itemsPerPage,
      search: searchText.value.isEmpty ? null : searchText.value,
    );

    result.fold(
      (failure) {
        print("DEBUG: AllJobsController fetchJobs failed: ${failure.message}");
        Get.snackbar("Error", failure.message);
      },
      (success) {
        final data = success.data;
        print("DEBUG: AllJobsController fetchJobs success. Jobs count: ${data.jobs.length}");
        if (data.meta != null) {
          print("DEBUG: Pagination - Current: ${data.meta!.currentPage}, Total: ${data.meta!.totalPages}");
          currentPage.value = data.meta!.currentPage;
          totalPages.value = data.meta!.totalPages;
          totalItems.value = data.meta!.totalItems;
        }

        if (currentPage.value == 1) {
          jobList.assignAll(data.jobs);
        } else {
          jobList.addAll(data.jobs);
        }
      },
    );

    isLoading.value = false;
    isMoreLoading.value = false;
  }

  void loadMore() {
    if (currentPage.value < totalPages.value && !isMoreLoading.value && !isLoading.value) {
      currentPage.value++;
      fetchJobs();
    }
  }
}
