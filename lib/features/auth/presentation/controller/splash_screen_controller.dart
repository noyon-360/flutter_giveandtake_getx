import 'package:flutx_core/flutx_core.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/bottomNavbar/screens/dashboard_screen.dart';
import 'package:karlfive/core/network/services/auth_storage_service.dart';

import 'package:karlfive/features/recruiter_account/presentation/screens/recruiter_page.dart';

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
        Get.offAll(() => DashboardScreen(), transition: Transition.fade);
      } else if (userRole == 'recruiter') {
        Get.offAll(() => RecruiterPageScreen(), transition: Transition.fade);
      } else if (userRole == 'company') {
        Get.offAll(
          () => CreateCompanyAccountPage(),
          transition: Transition.fade,
        );
      } else {
        Get.offAll(() => LoginScreen(), transition: Transition.fade);
      }
    } else {
      Get.offAll(() => LoginScreen(), transition: Transition.fade);
    }
  }
}
