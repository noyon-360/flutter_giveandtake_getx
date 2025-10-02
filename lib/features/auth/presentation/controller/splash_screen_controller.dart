import 'package:get/get.dart';
import 'package:karlfive/features/auth/presentation/controller/auth_controller.dart';
import 'package:karlfive/features/auth/presentation/screens/account_preview_screen.dart';
import 'package:karlfive/features/auth/presentation/screens/login_screen.dart';

import '../../../../core/network/services/secure_store_services.dart';
import '../../../home/presentation/screens/home_screen.dart';

// import '../../../home/presentation/screens/home_screen.dart';

// import '../screens/home_screen.dart';

import '../../../home/presentation/screens/home_screen.dart';
import '../screens/login_screen.dart';
import 'auth_controller.dart';


class SplashController extends GetxController {
  final _authController = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    _checkStartupFlow();
  }

  Future<void> _checkStartupFlow() async {
    await Future.delayed(const Duration(seconds: 2));

    final secureStore = SecureStoreServices();
    final savedEmail = await secureStore.retrieveData("email");
    final savedPassword = await secureStore.retrieveData("password");
    final previewConfirmed = await secureStore.retrieveData("previewConfirmed"); // 'true' or null

    final success = await _authController.refreshToken();

    if (savedEmail != null && savedPassword != null) {
      // if they previously confirmed preview, go straight to Home
      if (previewConfirmed == 'true') {
        Get.offAll(() => HomeScreen());
      } else {
        // show preview until they confirm
        Get.offAll(() => const AccountPreviewScreen());
      }
    } else {
      // no saved credentials — try token refresh flow
      if (success) {
        Get.offAll(() => HomeScreen());
      } else {
        Get.offAll(() => LoginScreen());
      }
    }
  }
}
