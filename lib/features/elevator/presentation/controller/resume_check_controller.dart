import 'package:get/get.dart';
import 'package:giveandtake/core/network/api_client.dart';
import 'package:giveandtake/core/network/constants/api_constants.dart';
import 'package:giveandtake/features/Home/presentation/screen/candidate_dashboard_screen.dart';
import 'package:giveandtake/features/elevator/presentation/screens/elevator_resume_screen.dart';
import 'package:giveandtake/features/elevator/presentation/screens/resume_check_loading_screen.dart';

/// Controller to check resume status and navigate accordingly
class ResumeCheckController extends GetxController {
  final ApiClient _apiClient = ApiClient();
  final isLoading = false.obs;

  /// Check resume status and navigate
  /// If resume is null, navigate to ElevatorResumeScreen
  /// If resume exists, navigate to CandidateDashboardScreen
  Future<void> checkResumeAndNavigate() async {
    isLoading.value = true;
    
    // Show loading screen first
    Get.to(() => const ResumeCheckLoadingScreen());
    
    try {
      final endpoint = '${ApiConstants.baseUrl}/create-resume/get-resume';
      
      print('🔍 [ResumeCheck] Checking resume status at: $endpoint');

      final result = await _apiClient.get(
        endpoint,
        fromJsonT: (json) => json as Map<String, dynamic>,
      );

      result.fold(
        (fail) {
          // API failed - navigate to form to create resume
          print('❌ [ResumeCheck] Failed to fetch resume: ${fail.message}');
          Get.offAll(() => const ElevatorResumeScreen());
        },
        (success) {
          final resumeData = success.data;
          final resume = resumeData['resume'];

          print('✅ [ResumeCheck] Resume check completed');
          print('   - Resume is null: ${resume == null}');

          // If resume is null, show the form to create one
          if (resume == null) {
            print('📝 [ResumeCheck] No resume found, navigating to ElevatorResumeScreen');
            Get.offAll(() => const ElevatorResumeScreen());
          } else {
            // Resume exists, show dashboard
            print('✅ [ResumeCheck] Resume found, navigating to CandidateDashboardScreen');
            Get.offAll(() => const CandidateDashboardScreen());
          }
        },
      );
    } catch (e) {
      print('❌ [ResumeCheck] Error checking resume: $e');
      // On error, default to dashboard
      Get.offAll(() => const CandidateDashboardScreen());
    } finally {
      isLoading.value = false;
    }
  }
}
