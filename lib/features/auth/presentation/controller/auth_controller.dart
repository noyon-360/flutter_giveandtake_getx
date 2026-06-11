import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutx_core/flutx_core.dart';
import 'package:get/get.dart';
import 'package:giveandtake/core/base/base_controller.dart';
import 'package:giveandtake/core/bottomNavbar/controllers/bottom_nav_controller.dart';
import 'package:giveandtake/core/bottomNavbar/screens/dashboard_screen.dart';
import 'package:giveandtake/core/network/api_client.dart';
import 'package:giveandtake/core/network/constants/api_constants.dart';
import 'package:giveandtake/core/services/get_user_profile_service.dart';
import 'package:giveandtake/features/auth/data/models/login_request_model.dart';
import 'package:giveandtake/features/auth/data/models/otp_request_model.dart';
import 'package:giveandtake/features/auth/data/models/otp_request_model_register.dart';
import 'package:giveandtake/features/auth/data/models/refresh_token_request_model.dart';
import 'package:giveandtake/features/auth/data/models/register_request_model.dart';
import 'package:giveandtake/features/auth/data/models/reset_password_request_model.dart';
import 'package:giveandtake/features/auth/data/models/reset_password_with_token_request_model.dart';
import 'package:giveandtake/features/auth/data/models/security_questions_request_model.dart';
import 'package:giveandtake/features/auth/data/models/verify_security_answers_request_model.dart';
import 'package:giveandtake/features/auth/domain/repo/auth_repo.dart';
import 'package:giveandtake/features/auth/presentation/screens/login_screen.dart';
import 'package:giveandtake/features/auth/presentation/screens/otp_verification_for_password_reset_screen.dart';
import 'package:giveandtake/features/auth/presentation/screens/otp_verification_to_complete_register.dart';
import 'package:giveandtake/features/auth/presentation/screens/security_questions_screen.dart';
import 'package:giveandtake/features/auth/presentation/screens/set_new_password_screen.dart';
import 'package:giveandtake/features/company/presentation/controller/company_account_controller.dart';
import 'package:giveandtake/features/elevator/presentation/screens/elevator_resume_screen.dart';
import 'package:giveandtake/features/recruiter_account/presentation/controller/recruiter_controller.dart';
import 'package:giveandtake/features/recruiter_account/presentation/screens/create_recruiter_account.dart';
import 'package:giveandtake/features/recruiter_account/presentation/screens/recruiter_page.dart';

import '../../../../core/network/services/auth_storage_service.dart';
import '../../../../core/network/services/secure_store_services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../Home/presentation/screen/home_screen.dart';
import 'remember_me_controller.dart';

class AuthController extends BaseController {
  final AuthRepository _authRepository;
  final AuthStorageService _authStorageService;

  /// Expose storage service so other widgets can read user role/id without DI coupling.
  AuthStorageService get authStorageService => _authStorageService;

  final isLoggedIn = false.obs;

  AuthController(this._authRepository, this._authStorageService) {
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final token = await _authStorageService.getAccessToken();
    isLoggedIn.value = token != null;
  }

  Timer? _otpTimer;
  final timerSeconds = 600.obs;
  final isOtpExpired = false.obs;

  void startOtpTimer() {
    _otpTimer?.cancel();
    timerSeconds.value = 600;
    isOtpExpired.value = false;
    _otpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerSeconds.value > 0) {
        timerSeconds.value--;
      } else {
        isOtpExpired.value = true;
        _otpTimer?.cancel();
      }
    });
  }

  void resetOtpTimer() {
    startOtpTimer();
  }

  String get timerDisplay {
    final minutes = (timerSeconds.value / 60).floor().toString().padLeft(
      2,
      '0',
    );
    final seconds = (timerSeconds.value % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  void onClose() {
    _otpTimer?.cancel();
    super.onClose();
  }

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
            userRole: user.role,
          );
          // Populate the shared GetUserProfileService with the user from login response
          try {
            Get.find<GetUserProfileService>().setUserInfo(user);
          } catch (_) {
            // If service not found, ignore silently (DI should normally register it)
          }
          if (rememberMeController!.rememberMe.value) {
            final secureStore = SecureStoreServices();
            secureStore.storeData('email', email);
            secureStore.storeData('password', password);
          }
          isLoggedIn.value = true;
          setLoading(false);

          // Reset nav controller to show home screen
          if (Get.isRegistered<BottomNavController>()) {
            Get.find<BottomNavController>().resetToHome();
            print('✅ BottomNavController reset to Home');
          }

          // Fetch resume data to check if profile is complete
          try {
            final resumeEndpoint =
                '${ApiConstants.baseUrl}/create-resume/get-resume';
            final resumeResult = await ApiClient().get(
              resumeEndpoint,
              fromJsonT: (json) => json as Map<String, dynamic>,
            );

            resumeResult.fold(
              (fail) {
                // If resume fetch fails, go to form to create one
                DPrint.log(
                  'Resume fetch failed, navigating to ElevatorResumeScreen',
                );
                Get.offAll(() => ElevatorResumeScreen());
              },
              (success) {
                final resumeData = success.data;
                final city = resumeData['resume']?['city'];

                DPrint.log('Resume city: $city');

                // If city is null or empty, profile is incomplete - go to form
                if (city == null || city.toString().isEmpty) {
                  DPrint.log(
                    'City is null/empty, navigating to ElevatorResumeScreen',
                  );
                  Get.offAll(() => ElevatorResumeScreen());
                } else {
                  // Profile is complete - go to dashboard
                  DPrint.log('Profile complete, navigating to DashboardScreen');
                  Get.offAll(() => DashboardScreen());
                }
              },
            );
          } catch (e) {
            DPrint.log('Error checking resume: $e');
            // On error, default to dashboard
            Get.offAll(() => DashboardScreen());
          }
        } else if (user.role == 'recruiter') {
          await _authStorageService.storeAuthData(
            accessToken: success.data.accessToken,
            refreshToken: success.data.refreshToken,
            userId: success.data.user.id,
            userRole: user.role,
          );
          // Populate the shared profile so the drawer header shows the
          // recruiter's name / photo instead of the "Your account" placeholder.
          try {
            Get.find<GetUserProfileService>().setUserInfo(user);
          } catch (_) {}

          if (rememberMeController!.rememberMe.value) {
            final secureStore = SecureStoreServices();
            secureStore.storeData('email', email);
            secureStore.storeData('password', password);
          }
          isLoggedIn.value = true;
          setLoading(false);

          // Show loading overlay while fetching recruiter profile
          Get.dialog(
            const Center(child: CircularProgressIndicator()),
            barrierDismissible: false,
          );

          try {
            // Route on a real recruiter profile, not the always-null message.
            final hasProfile =
                await Get.find<RecruiterController>().hasRecruiterProfile();
            if (Get.isDialogOpen ?? false) Get.back();
            DPrint.log('Recruiter hasProfile: $hasProfile');
            if (hasProfile) {
              Get.offAll(() => const RecruiterPageScreen());
            } else {
              Get.offAll(() => CreateRecruiterAccount());
            }
          } catch (e) {
            // Close loading overlay on exception
            if (Get.isDialogOpen ?? false) Get.back();
            DPrint.log('Recruiter fetch error: $e');
            Get.offAll(() => CreateRecruiterAccount());
          }
        } else if (user.role == 'company') {
          await _authStorageService.storeAuthData(
            accessToken: success.data.accessToken,
            refreshToken: success.data.refreshToken,
            userId: success.data.user.id,
            userRole: user.role,
          );
          // Populate the shared profile so the drawer header shows the
          // account's name / photo instead of the "Your account" placeholder.
          try {
            Get.find<GetUserProfileService>().setUserInfo(user);
          } catch (_) {}

          if (rememberMeController!.rememberMe.value) {
            final secureStore = SecureStoreServices();
            secureStore.storeData('email', email);
            secureStore.storeData('password', password);
          }
          isLoggedIn.value = true;
          setLoading(false);

          // Fetch company info and navigate based on whether company exists:
          //  - non-empty companies list → CompanyDetailsPage
          //  - empty companies list    → CreateCompanyAccountPage
          final companyController = Get.find<CompanyAccountController>();
          await companyController.navigateFromElevatorPitch(clearStack: true);
        } else {
          setError("You are not authorized to log in as a candidate");
          isLoggedIn.value = true;
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
        startOtpTimer();
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
        startOtpTimer();
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
        resetOtpTimer();
        setLoading(false);
      },
    );
  }

  // This method is now only used for registration OTP verification
  // For password reset, we navigate directly to SetNewPasswordScreen from resetPass
  // Future verifyOTPForRegistration(String email, String otp) async {
  //   setLoading(true);
  //   setError("");
  //
  //   final result = await _authRepository.otpVerifyRegister(
  //     OtpRequestModelRegister(email: email, otp: otp),
  //   );
  //
  //   result.fold(
  //     (fail) {
  //       setError(fail.message);
  //       DPrint.log("verify otp failed: ${fail.message}");
  //       Get.snackbar(
  //         'Error',
  //         fail.message,
  //         backgroundColor: Colors.red,
  //         colorText: Colors.white,
  //         snackPosition: SnackPosition.BOTTOM,
  //       );
  //       setLoading(false);
  //     },
  //     (success) {
  //       DPrint.log("verify otp success: ${success.message}");
  //       setLoading(false);
  //       Get.snackbar(
  //         'Success',
  //         'Registration completed successfully!',
  //         backgroundColor: const Color(0xFF10B287),
  //         colorText: Colors.white,
  //         snackPosition: SnackPosition.BOTTOM,
  //       );
  //       //* <--- Navigate to security questions for Sign Up --->
  //       Get.to(() => SecurityQuestionsScreen(email: email));
  //     },
  //   );
  // }

  Future verifyOTPRegister(String email, String otp) async {
    setLoading(true);
    setError("");

    final request = OtpVerifyRequestModel(email: email, otp: otp);
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

  /// Verify OTP for password reset flow using /user/verify-reset-otp endpoint
  Future<void> verifyOTPForPasswordReset(String email, String otp) async {
    setLoading(true);
    setError("");

    try {
      final request = OtpVerificationRequestModel(email: email, otp: otp);
      final result = await _authRepository.otpVerify(request);

      result.fold(
        (fail) {
          setError(fail.message);
          DPrint.log("Verify-reset OTP failed: ${fail.message}");
          Get.snackbar(
            'Invalid OTP',
            fail.message,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
          setLoading(false);
        },
        (success) {
          DPrint.log("Verify-reset OTP success: ${success.message}");
          setLoading(false);
          Get.snackbar(
            'OTP Verified',
            'Please enter your new password',
            backgroundColor: const Color(0xFF10B287),
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
          );
          // Navigate to set new password screen after successful verification
          Get.to(() => SetNewPasswordScreen(email: email, otp: otp));
        },
      );
    } catch (e, stackTrace) {
      DPrint.log("verifyOTPForPasswordReset exception: $e");
      DPrint.log("Stack trace: $stackTrace");
      setError("An unexpected error occurred");
      setLoading(false);
      Get.snackbar(
        'Error',
        'Unable to verify OTP. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future setNewPass(String email, String otp, String newPassword) async {
    setLoading(true);
    setError("");

    try {
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
            'Password reset successfully. Please log in with your new password.',
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
    } catch (e, stackTrace) {
      DPrint.log("setNewPass exception: $e");
      DPrint.log("Stack trace: $stackTrace");
      setError("An unexpected error occurred");
      setLoading(false);
      Get.snackbar(
        'Error',
        'Unable to reset password. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
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
        return false;
      },
      (success) async {
        DPrint.log("Refresh token success: ${success.message}");
        await _authStorageService.storeAccessToken(success.data.accessToken);
        await _authStorageService.storeRefreshToken(success.data.refreshToken);

        setLoading(false);
        Get.to(
          () => HomeScreen(),
          transition: Transition.rightToLeft,
        ); //! <<< If the user is already logged in, go to home screen >>>
        return true;
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
          Get.to(() => SetNewPasswordScreen(email: email, otp: ''));
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
    try {
      setLoading(true);

      // Clear all auth storage data (tokens, user ID, role, user profile)
      await _authStorageService.clearAuthData();

      // Clear user data from GetUserProfileService
      try {
        Get.find<GetUserProfileService>().clearUserData();
      } catch (_) {
        // If service not found, ignore silently
      }

      // Clear all secure storage data (includes remember me credentials and other cached data)
      final secureStore = SecureStoreServices();
      await secureStore.deleteAllData();

      isLoggedIn.value = false;
      setLoading(false);
      setError('');

      // Navigate to login screen
      Get.offAll(() => LoginScreen());
    } catch (e) {
      DPrint.log("Logout error: $e");
      setLoading(false);
      setError("Failed to logout");
    }
  }
}
