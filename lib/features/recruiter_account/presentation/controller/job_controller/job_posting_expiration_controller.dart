import 'package:get/get.dart';

class JobPostingExpirationController extends GetxController {
  final RxString selectedJobPostingExpiration = ''.obs;

  // Display value → Duration mapping
  final Map<String, int> jobPostingExpirationMap = {
    '7 days': 7,
    '14 days': 14,
    '30 days': 30,
    '60 days': 60,
    '90 days': 90,
  };

  List<String> get jobPostingExpiration => jobPostingExpirationMap.keys.toList();

  /// Get actual deadline date based on selected value
  DateTime getDeadlineDate() {
    final days = jobPostingExpirationMap[selectedJobPostingExpiration.value] ?? 0;
    return DateTime.now().add(Duration(days: days));
  }

  /// Get ISO string to send to backend
  String getDeadlineIso() {
    return getDeadlineDate().toIso8601String();
  }
}
