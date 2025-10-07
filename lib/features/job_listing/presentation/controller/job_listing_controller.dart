import 'package:get/get.dart';

class JobListingController extends GetxController {
  // Observable variables
  final RxList<Map<String, dynamic>> jobs = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> filteredJobs =
      <Map<String, dynamic>>[].obs;
  final RxList<String> selectedFilters = <String>[].obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = true.obs;
  final RxString selectedLocation = 'United States'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchJobs();
  }

  void fetchJobs() async {
    isLoading.value = true;

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Mock job data based on the screenshot
    final mockJobs = [
      {
        'id': '1',
        'title': 'Human Resources Manager',
        'company': 'Lancame',
        'location': 'United States',
        'duration': 'Full Time',
        'salary': '\$ 80k-100k/yr',
        'timePosted': '4 days ago',
        'type': 'Full Time',
        'datePosted': DateTime.now().subtract(const Duration(days: 4)),
      },
      {
        'id': '2',
        'title': 'Human Resources Manager',
        'company': 'Lancame',
        'location': 'United States',
        'duration': 'Full Time',
        'salary': '\$ 80k-100k/yr',
        'timePosted': '4 days ago',
        'type': 'Full Time',
        'datePosted': DateTime.now().subtract(const Duration(days: 4)),
      },
      {
        'id': '3',
        'title': 'Human Resources Manager',
        'company': 'Lancame',
        'location': 'United States',
        'duration': 'Full Time',
        'salary': '\$ 80k-100k/yr',
        'timePosted': '4 days ago',
        'type': 'Full Time',
        'datePosted': DateTime.now().subtract(const Duration(days: 4)),
      },
      {
        'id': '4',
        'title': 'Software Developer',
        'company': 'TechCorp',
        'location': 'United States',
        'duration': 'Part Time',
        'salary': '\$ 60k-80k/yr',
        'timePosted': '2 days ago',
        'type': 'Part Time',
        'datePosted': DateTime.now().subtract(const Duration(days: 2)),
      },
      {
        'id': '5',
        'title': 'Marketing Specialist',
        'company': 'MarketPro',
        'location': 'United States',
        'duration': 'Contract',
        'salary': '\$ 70k-90k/yr',
        'timePosted': '1 day ago',
        'type': 'Contract',
        'datePosted': DateTime.now().subtract(const Duration(days: 1)),
      },
    ];

    jobs.assignAll(mockJobs);
    filteredJobs.assignAll(mockJobs);
    isLoading.value = false;
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
      if (searchQuery.value.isNotEmpty) {
        final query = searchQuery.value.toLowerCase();
        if (!job['title'].toLowerCase().contains(query) &&
            !job['company'].toLowerCase().contains(query)) {
          return false;
        }
      }

      // Location filter
      if (selectedLocation.value != 'All Locations' &&
          job['location'] != selectedLocation.value) {
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
