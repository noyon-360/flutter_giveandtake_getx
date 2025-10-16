import 'package:get/get.dart';
import 'package:karlfive/features/job_listing/domain/usecases/get_jobs_usecase.dart';

class JobListingController extends GetxController {
  final GetJobsUseCase _getJobsUseCase;

  JobListingController({required GetJobsUseCase getJobsUseCase})
    : _getJobsUseCase = getJobsUseCase;

  // Observable variables
  final RxList<Map<String, dynamic>> jobs = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> filteredJobs =
      <Map<String, dynamic>>[].obs;
  final RxList<String> selectedFilters = <String>[].obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = true.obs;
  final RxString selectedLocation = 'All Locations'.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchJobs();
  }

  void fetchJobs() async {
    isLoading.value = true;
    errorMessage.value = '';

    final result = await _getJobsUseCase(limit: 100);

    result.fold(
      (failure) {
        errorMessage.value = failure.message;
        isLoading.value = false;
        Get.snackbar(
          'Error',
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      (success) {
        // Convert JobModel list to Map format for UI compatibility
        final jobMaps = success.data.jobs
            .map((job) => job.toDisplayMap())
            .toList();
        jobs.assignAll(jobMaps);
        filteredJobs.assignAll(jobMaps);
        isLoading.value = false;
      },
    );
  }

  void toggleFilter(String filter) {
    if (selectedFilters.contains(filter)) {
      selectedFilters.remove(filter);
    } else {
      selectedFilters.add(filter);
    }
    applyFilters();
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  void updateLocation(String location) {
    selectedLocation.value = location;
    applyFilters();
  }

  void applyFilters() {
    var filtered = jobs.where((job) {
      // Search filter
      final trimmed = searchQuery.value.trim();
      if (trimmed.isNotEmpty) {
        final query = trimmed.toLowerCase();
        // allow multi-keyword search: any token matching any of the fields
        final tokens = query.split(RegExp(r"\s+"));

        final title = (job['title'] ?? '').toString().toLowerCase();
        final company = (job['company'] ?? '').toString().toLowerCase();
        final location = (job['location'] ?? '').toString().toLowerCase();

        final matched = tokens.any(
          (t) =>
              title.contains(t) || company.contains(t) || location.contains(t),
        );

        if (!matched) return false;
      }

      // Location filter
      if (selectedLocation.value != 'All Locations' &&
          job['location'].toString().toLowerCase() !=
              selectedLocation.value.toString().toLowerCase()) {
        return false;
      }

      // Job Type filter
      if (selectedFilters.contains('Job Type')) {
        // Additional job type filtering logic can be added here
      }

      // Date posted filter
      if (selectedFilters.contains('Date posted')) {
        // Additional date filtering logic can be added here
      }

      return true;
    }).toList();

    filteredJobs.assignAll(filtered);
  }

  void onJobTap(Map<String, dynamic> job) {
    // Navigate to job details
    Get.snackbar(
      'Job Selected',
      'Opening ${job['title']} at ${job['company']}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void onEasyApply(Map<String, dynamic> job) {
    // Handle easy apply
    Get.snackbar(
      'Application Submitted',
      'Your application for ${job['title']} has been submitted!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
