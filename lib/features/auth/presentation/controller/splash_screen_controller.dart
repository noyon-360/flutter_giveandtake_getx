import 'package:flutx_core/core/debug_print.dart';
import 'package:get/get.dart';
import 'package:giveandtake/core/bottomNavbar/screens/dashboard_screen.dart';
import 'package:giveandtake/core/network/services/auth_storage_service.dart';
import 'package:giveandtake/core/services/deep_link_service.dart';
import 'package:giveandtake/features/recruiter_account/presentation/controller/recruiter_controller.dart';
import 'package:giveandtake/features/company/presentation/controller/company_account_controller.dart';
import 'package:giveandtake/features/recruiter_account/presentation/screens/create_recruiter_account.dart';
import 'package:giveandtake/features/recruiter_account/presentation/screens/recruiter_page.dart';

import '../../../Home/presentation/screen/home_screen.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _checkStartupFlow();
  }

  final AuthStorageService _authStorageService = AuthStorageService();

  Future<void> _checkStartupFlow() async {
    // Remove the old delay, but add a tiny one to ensure overlay is ready
    await Future.delayed(const Duration(milliseconds: 500));

    final accessToken = await _authStorageService.getAccessToken();

    if (accessToken != null) {
      final userRole = await _authStorageService.getUserRole();

      if (userRole == 'candidate') {
        Get.offAll(() => DashboardScreen());
      } else if (userRole == 'recruiter') {
        await _routeRecruiter();
      } else if (userRole == 'company') {
        await _routeCompany();
      } else {
        // Unknown role, go to login
        Get.offAll(() => HomeScreen());
      }
    } else {
      Get.offAll(() => HomeScreen(), transition: Transition.fade);
    }

    Get.find<DeepLinkService>().markAppReady();
  }

  /// Recruiter startup routing.
  /// Mirrors the login-success flow: fetch the recruiter profile and route to
  /// the profile-creation form when no profile exists yet, otherwise to the
  /// recruiter dashboard.
  Future<void> _routeRecruiter() async {
    final userId = await _authStorageService.getUserId();
    if (userId == null || userId.isEmpty) {
      Get.offAll(() => HomeScreen());
      return;
    }

    try {
      // Route on whether a real, populated recruiter profile exists — not on a
      // (structurally always-null) message string, which previously sent
      // profile-less users to the dashboard on cold relaunch.
      final hasProfile =
          await Get.find<RecruiterController>().hasRecruiterProfile();
      DPrint.log('Recruiter hasProfile: $hasProfile');
      if (hasProfile) {
        Get.offAll(() => const RecruiterPageScreen());
      } else {
        Get.offAll(() => CreateRecruiterAccount());
      }
    } catch (e) {
      DPrint.log('Recruiter routing error: $e');
      Get.offAll(() => CreateRecruiterAccount());
    }
  }

  /// Company startup routing.
  /// Reuses the shared company controller helper which fetches the company
  /// profile and routes to the create-company form when the companies list is
  /// empty, otherwise to the company dashboard.
  Future<void> _routeCompany() async {
    final companyController = Get.find<CompanyAccountController>();
    await companyController.navigateFromElevatorPitch(clearStack: true);
  }
}
