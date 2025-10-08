import 'package:flutter/material.dart';
import 'package:flutx_core/flutx_core.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/base/base_controller.dart';
import 'package:karlfive/features/auth/data/models/login_request_model.dart';
import 'package:karlfive/features/auth/data/models/otp_request_model.dart';
import 'package:karlfive/features/auth/data/models/otp_request_model_register.dart';
import 'package:karlfive/features/auth/data/models/refresh_token_request_model.dart';
import 'package:karlfive/features/auth/data/models/register_request_model.dart';
import 'package:karlfive/features/auth/data/models/reset_password_request_model.dart';
import 'package:karlfive/features/auth/data/models/reset_password_with_token_request_model.dart';
import 'package:karlfive/features/auth/data/models/security_questions_request_model.dart';
import 'package:karlfive/features/auth/data/models/verify_security_answers_request_model.dart';
import 'package:karlfive/features/auth/domain/repo/auth_repo.dart';
import 'package:karlfive/features/auth/presentation/screens/home_screen.dart';
import 'package:karlfive/features/auth/presentation/screens/login_screen.dart';
import 'package:karlfive/features/auth/presentation/screens/otp_verification_for_password_reset_screen.dart';
import 'package:karlfive/features/auth/presentation/screens/otp_verification_to_complete_register.dart';
import 'package:karlfive/features/auth/presentation/screens/security_questions_screen.dart';
import 'package:karlfive/features/auth/presentation/screens/set_new_password_screen.dart';
import 'package:karlfive/features/profile_dasboard/presentation/screens/profile_dashboard_screen.dart';
import '../../../../core/network/services/auth_storage_service.dart';
import '../../../../core/network/services/secure_store_services.dart';

import '../../../../core/theme/app_colors.dart';
import 'remember_me_controller.dart';

class AuthController extends BaseController {
  final AuthRepository _authRepository;
  final AuthStorageService _authStorageService;
  bool _isSuccess = false;

  AuthController(this._authRepository, this._authStorageService);


  // Login
  Future<void> login(
    RememberMeController? rememberMeController, {
    required String email,
    required String password,
  }) async {
    setLoading(true);
    setError("");

    // Debug logging for login
    DPrint.log("=== LOGIN DEBUG ===");
    DPrint.log("Email: $email");
    DPrint.log("Password: $password");
    DPrint.log("Password Length: ${password.length}");

    final request = LoginRequestModel(email: email, password: password);

    final result = await _authRepository.login(request);

    DPrint.log("Login Response ${result.isRight()}");

    result.fold(
      (fail) {
        setError(fail.message);
        setLoading(false);
      },
      (success) async {
        final user = success.data.user;
        if (user.role == 'candidate') {
          await _authStorageService.storeAuthData(
            accessToken: success.data.accessToken,
            refreshToken: success.data.refreshToken,
            userId: success.data.user.id,
          );
          if (rememberMeController!.rememberMe.value) {
            final secureStore = SecureStoreServices();
            secureStore.storeData('email', email);
            secureStore.storeData('password', password);
          }
          setLoading(false);
          Get.offAll(() => const ProfileDashboardScreen());
        } else {
          setError("You are not authorized to login as candidate");
          setLoading(false);
        }
      },
    );
  }

  Future<void> register({
    required String firstName,
    required String surname,
    required String email,
    required String password,
    required String phoneNumber,
    required String address,
    required String dateOfBirth,
    String role =
        'candidate', // Default to 'candidate', can be 'recruiter' or 'company' later
  }) async {
    setLoading(true);
    setError('');

    // Merge firstName and surname to create full name
    final String fullName = '$firstName $surname'.trim();

    final request = RegisterRequestModel(
      name: fullName,
      email: email,
      password: password,
      phoneNum: phoneNumber,
      address: address,
      role: role,
      dateOfbirth: dateOfBirth,
    );

    final result = await _authRepository.register(request);

    result.fold(
      (fail) {
        setError(fail.message);
        DPrint.log("Register success result : ${fail.message}");
        setLoading(false);
      },
      (success) {
        DPrint.log("Register success result : ${success.data.id}");
        setLoading(false);
        Get.to(OtpVerificationToCompleteRegister(email: email));
      },
    );
  }

  Future resetPass(String email) async {
    setLoading(true);
    setError('');

    final request = ResetPasswordRequestModel(email: email);
    final result = await _authRepository.resetPassword(request);

    result.fold(
      (fail) {
        setError(fail.message);
        DPrint.log("reset pass failed: ${fail.message}");
        Get.snackbar(
          'Error',
          fail.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        setLoading(false);
      },
      (success) {
        DPrint.log("reset pass success: ${success.data.message}");
        Get.snackbar(
          'OTP Sent',
          'We have sent an OTP to $email. Please check your email.',
          backgroundColor: const Color(0xFF10B287),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        setLoading(false);
        // Navigate to OTP verification screen for password reset
        Get.to(() => OtpVerificationForPasswordResetScreen(email: email));
      },
    );
  }

  Future resendOTP(String email) async {
    setLoading(true);
    setError("");

    final request = ResetPasswordRequestModel(email: email);
    final result = await _authRepository.resetPassword(request);

    result.fold(
      (fail) {
        setError(fail.message);
        DPrint.log("reset pass success result : ${fail.message}");
        setLoading(false);
      },
      (success) {
        DPrint.log("reset pass success result : ${success.data.message}");
        Get.snackbar("OTP Sent", "We have resent the OTP to $email");
        setLoading(false);
      },
    );
  }

  // This method is now only used for registration OTP verification
  // For password reset, we navigate directly to SetNewPasswordScreen from resetPass
  Future verifyOTPForRegistration(String email, String otp) async {
    setLoading(true);
    setError("");

    final result = await _authRepository.otpVerifyRegister(
      OtpRequestModelRegister(email: email, otp: otp),
    );

    result.fold(
      (fail) {
        setError(fail.message);
        DPrint.log("verify otp failed: ${fail.message}");
        Get.snackbar(
          'Error',
          fail.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        setLoading(false);
      },
      (success) {
        DPrint.log("verify otp success: ${success.message}");
        setLoading(false);
        Get.snackbar(
          'Success',
          'Registration completed successfully!',
          backgroundColor: const Color(0xFF10B287),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        // Navigate to security questions for new users
        Get.to(() => SecurityQuestionsScreen(email: email));
      },
    );
  }

  Future verifyOTPRegister(String email, String otp) async {
    setLoading(true);
    setError("");

    final request = OtpRequestModelRegister(email: email, otp: otp);
    final result = await _authRepository.otpVerifyRegister(request);

    result.fold(
      (fail) {
        // Check if the error is "User already verified"
        // In this case, still proceed to security questions
        if (fail.message.toLowerCase().contains('already verified')) {
          DPrint.log("User already verified, proceeding to security questions");
          setLoading(false);
          // Show info snackbar
          Get.snackbar(
            'Already Verified',
            'Your account is already verified. Proceeding to security questions.',
            backgroundColor: const Color(0xFF10B287),
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
          );
          // Small delay for user to see the message
          Future.delayed(const Duration(milliseconds: 500), () {
            Get.to(() => SecurityQuestionsScreen(email: email));
          });
        } else {
          setError(fail.message);
          DPrint.log("verify otp failed: ${fail.message}");
          setLoading(false);
          // Don't show snackbar here - the error dialog will show
        }
      },
      (success) {
        DPrint.log("verify otp success: ${success.message}");
        setLoading(false);
        // Clear any previous errors
        setError("");
        // Show success message
        Get.snackbar(
          'Success',
          success.message.isNotEmpty
              ? success.message
              : 'OTP verified successfully',
          backgroundColor: const Color(0xFF10B287),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
        // Small delay to let user see the success message
        Future.delayed(const Duration(milliseconds: 500), () {
          Get.to(() => SecurityQuestionsScreen(email: email));
        });
      },
    );
  }

  void verifyOTPForPasswordReset(String email, String otp) {
    //* <--- Client-side validation only ---> *//
    DPrint.log("OTP format validated: $otp");
    Get.snackbar(
      'OTP Accepted',
      'Please enter your new password',
      backgroundColor: const Color(0xFF10B287),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
    //* <--- Navigate to set new password screen with the OTP ---> *//
    Get.to(() => SetNewPasswordScreen(email: email, otp: otp));
  }

  Future setNewPass(String email, String otp, String newPassword) async {
    setLoading(true);
    setError("");

    //* <--- Debug logging to see what we're sending --->
    DPrint.log("=== NEW PASSWORD DEBUG ===");
    DPrint.log("Email: $email");
    DPrint.log("OTP: $otp");
    DPrint.log("New Password: $newPassword");
    DPrint.log("Password Length: ${newPassword.length}");

    //* <--- For reset password flow, we use the OTP verification endpoint with the new password --->
    final request = OtpVerificationRequestModel(
      email: email,
      otp: otp,
      newPassword: newPassword,
    );

    DPrint.log("Request JSON: ${request.toJson()}");
    final result = await _authRepository.otpVerify(request);

    result.fold(
      (fail) {
        setError(fail.message);
        DPrint.log("New Password set failed result : ${fail.message}");
        Get.snackbar(
          'Error',
          fail.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        setLoading(false);
      },
      (success) {
        DPrint.log(
          "New Password set successfully result : ${success.data.message}",
        );
        setLoading(false);
        // Show success message
        Get.snackbar(
          'Success',
          'Password reset successfully! Please login with your new password.',
          backgroundColor: const Color(0xFF10B287),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
        // Navigate to login screen after a short delay
        Future.delayed(const Duration(seconds: 1), () {
          Get.offAll(() => LoginScreen());
        });
      },
    );
  }

  Future refreshToken() async {
    setLoading(true);

    final refreshToken = await _authStorageService.getRefreshToken();
    DPrint.log("Got refresh token: $refreshToken");
    final request = RefreshTokenRequestModel(refreshToken: refreshToken);

    final result = await _authRepository.refreshToken(request);

    final navi = result.fold(
      (fail) {
        DPrint.log("Refresh token failed: ${fail.message}");
        setLoading(false);
        return _isSuccess = false;
      },
      (success) async {
        DPrint.log("Refresh token success: ${success.message}");
        await _authStorageService.storeAccessToken(success.data.accessToken);
        await _authStorageService.storeRefreshToken(success.data.refreshToken);

        setLoading(false);
        //  Get.to(() => JoinLeagueScreen(), transition: Transition.rightToLeft); <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        return _isSuccess = true;
      },
    );
    return navi;
  }

  // Security Questions
  List<dynamic> _securityQuestions = [];
  List<dynamic> get securityQuestions => _securityQuestions;

  String? _securityToken;
  String? get securityToken => _securityToken;

  Future<void> getDefaultSecurityQuestions() async {
    setLoading(true);
    setError("");

    final result = await _authRepository.getDefaultSecurityQuestions();

    result.fold(
      (fail) {
        setError(fail.message);
        DPrint.log("Get security questions failed: ${fail.message}");
        setLoading(false);
      },
      (success) {
        _securityQuestions = success.data.questions;
        DPrint.log("Got ${_securityQuestions.length} security questions");
        setLoading(false);
        update();
      },
    );
  }

  Future<void> submitSecurityAnswers({
    required String email,
    required List<SecurityQuestionAnswer> questions,
    bool isRegistration = true,
  }) async {
    setLoading(true);
    setError("");

    final request = SecurityQuestionsRequestModel(
      email: email,
      securityQuestions: questions,
    );
    final result = await _authRepository.submitSecurityAnswers(request);

    result.fold(
      (fail) {
        setError(fail.message);
        DPrint.log("Submit security answers failed: ${fail.message}");
        setLoading(false);
        //* <--- Show error snackbar --->
        Get.snackbar(
          'Error',
          fail.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      },
      (success) {
        DPrint.log("Security answers submitted successfully");
        setLoading(false);

        if (isRegistration) {
          //* <--- Show success message --->
          Get.snackbar(
            'Success!',
            'Security questions saved successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.primaryLightBlue,
            colorText: AppColors.primaryWhite,
            duration: const Duration(seconds: 2),
            margin: EdgeInsets.all(16),
            borderRadius: 8,
          );

          //* <--- Wait for snackbar to show, then navigate to login --->
          Future.delayed(const Duration(seconds: 2), () {
            Get.offAll(() => LoginScreen());
          });
        }
      },
    );
  }

  Future<void> verifySecurityAnswers({
    required String email,
    required List<String> answers,
  }) async {
    setLoading(true);
    setError("");

    final request = VerifySecurityAnswersRequestModel(
      email: email,
      answers: answers,
    );
    final result = await _authRepository.verifySecurityAnswers(request);

    result.fold(
      (fail) {
        setError(fail.message);
        DPrint.log("Verify security answers failed: ${fail.message}");
        setLoading(false);
      },
      (success) {
        _securityToken = success.data.token;
        DPrint.log("Security answers verified, got token");
        setLoading(false);

        if (_securityToken != null) {
          //* <--- Navigate to set new password screen with token --->
          Get.to(
            () => SetNewPasswordScreen(
              email: email,
              otp: '', 
            ),
          );
        }
      },
    );
  }

  Future<void> resetPasswordWithToken({
    required String token,
    required String newPassword,
  }) async {
    setLoading(true);
    setError("");

    final request = ResetPasswordWithTokenRequestModel(
      newPassword: newPassword,
    );
    final result = await _authRepository.resetPasswordWithToken(token, request);

    result.fold(
      (fail) {
        setError(fail.message);
        DPrint.log("Reset password failed: ${fail.message}");
        setLoading(false);
      },
      (success) {
        DPrint.log("Password reset successfully");
        setLoading(false);
        Get.offAll(() => LoginScreen());
      },
    );
  }

  Future<void> logout() async {
    await _authStorageService.clearAuthData();
    final secureStore = SecureStoreServices();
    await secureStore.deleteData(
      'previewConfirmed',
    ); // or storeData('previewConfirmed', 'false');
    // await secureStore.deleteData('email');
    // await secureStore.deleteData('password');

    setLoading(false);
    setError('');
    Get.offAll(() => LoginScreen());
  }
}
