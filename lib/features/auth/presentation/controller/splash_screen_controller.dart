import 'package:flutx_core/flutx_core.dart';
import 'package:get/get.dart';
import 'package:giveandtake/core/bottomNavbar/screens/dashboard_screen.dart';
import 'package:giveandtake/core/network/services/auth_storage_service.dart';
import 'package:giveandtake/features/auth/presentation/controller/auth_controller.dart';
import 'package:giveandtake/features/company/presentation/screen/company_details_screen.dart';
import 'package:giveandtake/features/recruiter_account/presentation/screens/recruiter_page.dart';

import '../../../company/presentation/screen/company_screen.dart';
import '../screens/login_screen.dart';

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
        Get.offAll(() => RecruiterPageScreen());
      } else if (userRole == 'company') {
        Get.offAll(() => CompanyDetailsPage());
      } else {
        // Unknown role, go to login
        Get.offAll(() => LoginScreen());
      }
    } else {
      Get.offAll(() => LoginScreen(), transition: Transition.fade);
    }
  }
}
