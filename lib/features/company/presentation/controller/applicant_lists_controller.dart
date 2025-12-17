import 'package:get/get.dart';

class ApplicantListController extends GetxController {
  final String jobId;

  ApplicantListController(this.jobId);

  /// Applicant List
  RxList applicants = <dynamic>[].obs;

  /// Loading state
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchApplicants();
  }

  /// ---------------- FETCH APPLICANT LIST ----------------
  Future<void> fetchApplicants() async {
    try {
      isLoading(true);

      // TODO: Replace with real API call
      await Future.delayed(const Duration(seconds: 1));

      // Dummy Data Example
      applicants.value = [
        {
          'name': 'John Doe',
          'appliedDate': 'Jan 25, 2025',
          'status': 'Pending',
        },
        {
          'name': 'Sarah Khan',
          'appliedDate': 'Jan 27, 2025',
          'status': 'Reviewed',
        }
      ];

      // If real API returns empty, applicants will remain empty
      // applicants.value = apiResponseList;

    } catch (e) {
      print("Error fetching applicants: $e");
    } finally {
      isLoading(false);
    }
  }
}
