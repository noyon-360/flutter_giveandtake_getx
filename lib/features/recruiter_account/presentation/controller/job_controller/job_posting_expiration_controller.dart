import 'package:get/get.dart';

class JobPostingExpirationController extends GetxController {
  final RxString selectedJobPostingExpiration = ''.obs;

  // Reactive variable for final calculated deadline date
  final Rx<DateTime?> finalDeadlineDate = Rx<DateTime?>(null);

  @override
  void onInit() {
    super.onInit();
    // Initialize with today's date if not set yet
    calculateDeadline(DateTime.now());
  }

  // List of available expiration options with their durations
  final Map<String, int> jobPostingExpirationMap = {
    '7 days': 7,
    '14 days': 14,
    '30 days': 30,
    '60 days': 60,
    '90 days': 90,
  };

  List<String> get jobPostingExpiration => jobPostingExpirationMap.keys.toList();

  /// Calculates and updates the final deadline date
  void calculateDeadline(DateTime selectedPublishDate) {
    final days = jobPostingExpirationMap[selectedJobPostingExpiration.value] ?? 0;
    if (days > 0) {
      final calculatedDate = selectedPublishDate.add(Duration(days: days));
      finalDeadlineDate.value = calculatedDate;
    } else {
      finalDeadlineDate.value = null;
    }
  }

  /// Converts the deadline to ISO string for backend
  String getDeadlineIso() {
    if (finalDeadlineDate.value == null) return '';
    return finalDeadlineDate.value!.toIso8601String();
  }
}
