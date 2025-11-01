import 'package:get/get.dart';
import 'package:karlfive/features/auth/presentation/controller/auth_controller.dart';
import 'package:karlfive/features/recruiter_account/presentation/controller/recruiter_controller.dart';

void setupController() {
  // Auth Controller
  Get.lazyPut<AuthController>(
    () => AuthController(Get.find(), Get.find()),
    fenix: true,
  );

  Get.lazyPut<RecruiterController>(
    () => RecruiterController(Get.find(), Get.find()),
    fenix: true,
  );
}
