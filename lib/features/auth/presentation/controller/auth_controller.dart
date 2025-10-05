import 'package:flutx_core/flutx_core.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/base/base_controller.dart';
import 'package:karlfive/core/services/get_user_profile_service.dart';
import 'package:karlfive/features/auth/data/models/login_request_model.dart';
import 'package:karlfive/features/auth/data/models/otp_request_model.dart';
import 'package:karlfive/features/auth/data/models/otp_request_model_register.dart';
import 'package:karlfive/features/auth/data/models/refresh_token_request_model.dart';
import 'package:karlfive/features/auth/data/models/register_request_model.dart';
import 'package:karlfive/features/auth/data/models/reset_password_request_model.dart';
import 'package:karlfive/features/auth/data/models/reset_password_with_token_request_model.dart';
import 'package:karlfive/features/auth/data/models/security_questions_request_model.dart';
import 'package:karlfive/features/auth/data/models/set_new_password_request_model.dart';
import 'package:karlfive/features/auth/data/models/verify_security_answers_request_model.dart';
import 'package:karlfive/features/auth/domain/repo/auth_repo.dart';
import 'package:karlfive/features/auth/presentation/screens/home_screen.dart';
import 'package:karlfive/features/auth/presentation/screens/login_screen.dart';
import 'package:karlfive/features/auth/presentation/screens/otp_verification_screen.dart';
import 'package:karlfive/features/auth/presentation/screens/otp_verification_to_complete_register.dart';
import 'package:karlfive/features/auth/presentation/screens/security_questions_screen.dart';
import 'package:karlfive/features/auth/presentation/screens/set_new_password_screen.dart';
import '../../../../core/network/services/auth_storage_service.dart';
import '../../../../core/network/services/secure_store_services.dart';

import 'remember_me_controller.dart';

class AuthController extends BaseController {
  final AuthRepository _authRepository;
  final AuthStorageService _authStorageService;
  bool _isSuccess = false;

  AuthController(this._authRepository, this._authStorageService);

  final userProfileService = Get.find<GetUserProfileService>();

  // Login
  Future<void> login(
    RememberMeController? rememberMeController, {
    required String email,
    required String password,
  }) async {
    setLoading(true);
    setError("");

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
          Get.offAll(() => const HomeScreen());
        } else {
          setError("You are not authorized to login as candidate");
          setLoading(false);
        }
      },
    );
  }

  Future<void> register(
    String name,
    String email,
    String password,
    String phoneNumber,
    String address,
  ) async {
    setLoading(true);
    setError('');

    final request = RegisterRequestModel(
      name: name,
      email: email,
      password: password,
      phoneNum: phoneNumber,
      address: address,
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
        DPrint.log("reset pass success result : ${fail.message}");
        setLoading(false);
      },
      (success) {
        DPrint.log("reset pass success result : ${success.data.message}");
        setLoading(false);
        Get.offAll(() => OtpVerificationScreen(email: email));
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

  Future verifyOTP(String email, String otp) async {
    setLoading(true);
    setError("");

    final request = OtpVerificationRequestModel(email: email, otp: otp);
    final result = await _authRepository.otpVerify(request);

    result.fold(
      (fail) {
        setError(fail.message);
        DPrint.log("verify otp success result : ${fail.message}");
        setLoading(false);
      },
      (success) {
        DPrint.log("verify otp success result : ${success.data.message}");
        setLoading(false);
        // Navigate to security questions screen for forgot password flow
        Get.to(() => const SecurityQuestionsScreen());
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
        setError(fail.message);
        DPrint.log("verify otp success result : ${fail.message}");
        setLoading(false);
      },
      (success) {
        DPrint.log("verify otp success result : ${success.data.message}");
        setLoading(false);
        // Navigate to security questions screen after OTP verification
        Get.to(() => const SecurityQuestionsScreen());
      },
    );
  }

  Future setNewPass(String email, String otp, String newPassword) async {
    setLoading(true);
    setError("");

    final request = SetNewPasswordRequestModel(
      email: email,
      otp: otp,
      newPassword: newPassword,
    );
    final result = await _authRepository.setNewPassword(request);

    result.fold(
      (fail) {
        setError(fail.message);
        DPrint.log("New Password set failed result : ${fail.message}");
        setLoading(false);
      },
      (success) {
        DPrint.log(
          "New Password set successfully result : ${success.data.message}",
        );
        setLoading(false);
        Get.to(LoginScreen());
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
        // _authStorageService.clearAuthData();
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
        // Note: API returns "date" instead of "data" - handle typo
        _securityQuestions = success.data.date;
        DPrint.log("Got ${_securityQuestions.length} security questions");
        setLoading(false);
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
      },
      (success) {
        DPrint.log("Security answers submitted successfully");
        setLoading(false);

        if (isRegistration) {
          // After registration flow completes, go to login
          Get.offAll(() => LoginScreen());
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
          // Navigate to set new password screen with token
          Get.to(
            () => SetNewPasswordScreen(
              email: email,
              otp: '', // Not used in new flow
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
