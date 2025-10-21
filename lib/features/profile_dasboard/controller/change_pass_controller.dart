import 'package:get/get.dart';
import '../data/models/change_password_request_model.dart';
import '../data/repo/change_password_repo_impl.dart';

/// Controller for Change Password Screen
class ChangePasswordController extends GetxController {
  final ChangePasswordRepoImpl _repo = ChangePasswordRepoImpl();

  var currentPassword = ''.obs;
  var newPassword = ''.obs;
  var confirmPassword = ''.obs;

  var hasError = false.obs;
  var isSuccess = false.obs;
  var isLoading = false.obs;
  var serverError = ''.obs;

  void clearServerError() => serverError.value = '';

  Future<void> validateAndSubmit() async {
    hasError.value = false;
    isSuccess.value = false;
    clearServerError();

    if (newPassword.value.length < 12 ||
        !newPassword.value.contains(RegExp(r'[A-Z]')) ||
        !newPassword.value.contains(RegExp(r'[a-z]')) ||
        !newPassword.value.contains(RegExp(r'[0-9]')) ||
        !newPassword.value.contains(RegExp(r'[!@#\$&*~]')) ||
        newPassword.value != confirmPassword.value) {
      hasError.value = true;
      return;
    }

    // call API
    isLoading.value = true;
    final request = ChangePasswordRequestModel(
      oldPassword: currentPassword.value,
      newPassword: newPassword.value,
    );




    final result = await _repo.changePassword(request);
    result.fold(
      (fail) {
        serverError.value = fail.message;
        isLoading.value = false;
      },
      (_) {
        isSuccess.value = true;
        isLoading.value = false;
      },
    );
  }
}
