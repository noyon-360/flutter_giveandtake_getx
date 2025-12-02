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

  Future<void> _checkStartupFlow() async {
    await Future.delayed(const Duration(seconds: 2));

    final AuthStorageService _authStorageService = AuthStorageService();

    final accessToken = await _authStorageService.getAccessToken();

    if (accessToken != null) {
      // User is logged in, check their role and navigate accordingly
      final userRole = await _authStorageService.getUserRole();
      DPrint.log("User Role: $userRole");

      if (userRole == 'candidate') {
        Get.offAll(() => DashboardScreen());
      } 
      else if (userRole == 'recruiter') {
        Get.offAll(() => RecruiterPageScreen());
      } 
      // else if (userRole == 'company') {
      //   Get.offAll(() => CreateCompanyAccountPage());
      // }
          else {
        // Unknown role, go to login
        Get.offAll(() => LoginScreen());
      }
    } else {
      // No access token, go to login
      Get.offAll(() => LoginScreen());
    }
  }
}
