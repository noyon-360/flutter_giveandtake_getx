import 'package:karlfive/features/auth/data/models/auth_response_model.dart';
import 'package:karlfive/features/auth/data/models/default_security_questions_response_model.dart';
import 'package:karlfive/features/auth/data/models/login_request_model.dart';
import 'package:karlfive/features/auth/data/models/otp_request_model_register.dart';
import 'package:karlfive/features/auth/data/models/otp_response_model_register.dart';
import 'package:karlfive/features/auth/data/models/reset_password_with_token_request_model.dart';
import 'package:karlfive/features/auth/data/models/security_questions_request_model.dart';
import 'package:karlfive/features/auth/data/models/security_questions_response_model.dart';
import 'package:karlfive/features/auth/data/models/verify_security_answers_request_model.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/network_result.dart';
import '../../domain/repo/auth_repo.dart';
import '../models/otp_request_model.dart';
import '../models/otp_response_model.dart';
import '../models/refresh_token_request_model.dart';
import '../models/refresh_token_response_model.dart';
import '../models/register_request_model.dart';
import '../models/register_response_model.dart';
import '../models/reset_password_request_model.dart';
import '../models/reset_password_response_model.dart';
import '../models/set_new_password_request_model.dart';
import '../models/set_new_password_response_model.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _apiClient;

  AuthRepositoryImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  NetworkResult<AuthResponseData> login(LoginRequestModel request) {
    return _apiClient.post<AuthResponseData>(
      ApiConstants.auth.login,
      data: request.toJson(),
      fromJsonT: (json) => AuthResponseData.fromJson(json),
      // isFormData: true
    );
  }

  @override
  NetworkResult<RegisterResponseModel> register(RegisterRequestModel request) {
    return _apiClient.post<RegisterResponseModel>(
      ApiConstants.auth.register,
      data: request.toJson(),
      fromJsonT: (json) => RegisterResponseModel.fromJson(json),
    );
  }

  @override
  NetworkResult<ResetPasswordResponseModel> resetPassword(
    ResetPasswordRequestModel request,
  ) {
    return _apiClient.post(
      ApiConstants.auth.resetPass,
      data: request.toJson(),
      fromJsonT: (json) => ResetPasswordResponseModel.fromJson(json),
    );
  }

  @override
  NetworkResult<OtpVerificationResponseModel> otpVerify(
    OtpVerificationRequestModel request,
  ) {
    return _apiClient.post(
      ApiConstants.auth.otpVerifyResetPassword,
      data: request.toJson(),
      fromJsonT: (json) => OtpVerificationResponseModel.fromJson(json),
    );
  }

  @override
  NetworkResult<OtpResponseModelRegister> otpVerifyRegister(
    OtpRequestModelRegister request,
  ) {
    return _apiClient.post(
      ApiConstants.auth.otpVerifyRegister,
      data: request.toJson(),
      // Pass whatever is in the data field (empty string, null, or object)
      fromJsonT: (json) => OtpResponseModelRegister.fromJson(json),
    );
  }

  @override
  NetworkResult<SetNewPasswordResponseModel> setNewPassword(
    SetNewPasswordRequestModel request,
  ) {
    return _apiClient.post(
      ApiConstants.auth.changePassword,
      data: request.toJson(),
      fromJsonT: (json) => SetNewPasswordResponseModel.fromJson(json),
    );
  }

  @override
  NetworkResult<RefreshTokenResponseModel> refreshToken(
    RefreshTokenRequestModel request,
  ) {
    return _apiClient.post(
      ApiConstants.auth.refreshToken,
      data: request.toJson(),
      fromJsonT: (json) => RefreshTokenResponseModel.fromJson(json),
    );
  }

  @override
  NetworkResult<UserModel> getUserProfile() {
    return _apiClient.get<UserModel>(
      ApiConstants.user.getUserProfile,
      fromJsonT: (json) => UserModel.fromJson(json),
    );
  }

  @override
  NetworkResult<DefaultSecurityQuestionsResponseModel>
  getDefaultSecurityQuestions() {
    // Note: API returns questions in 'date' field at root level, not in 'data' field
    // Our model's fromJson handles both 'data' and 'date' fields
    return _apiClient.get<DefaultSecurityQuestionsResponseModel>(
      ApiConstants.auth.defaultSecurityQuestions,
      fromJsonT: (json) => DefaultSecurityQuestionsResponseModel.fromJson(json),
    );
  }

  @override
  NetworkResult<SecurityQuestionsResponseModel> submitSecurityAnswers(
    SecurityQuestionsRequestModel request,
  ) {
    return _apiClient.post<SecurityQuestionsResponseModel>(
      ApiConstants.auth.securityAnswers,
      data: request.toJson(),
      fromJsonT: (json) => SecurityQuestionsResponseModel.fromJson(json),
    );
  }

  @override
  NetworkResult<SecurityQuestionsResponseModel> verifySecurityAnswers(
    VerifySecurityAnswersRequestModel request,
  ) {
    return _apiClient.post<SecurityQuestionsResponseModel>(
      ApiConstants.auth.verifySecurityAnswers,
      data: request.toJson(),
      fromJsonT: (json) => SecurityQuestionsResponseModel.fromJson(json),
    );
  }

  @override
  NetworkResult<SecurityQuestionsResponseModel> resetPasswordWithToken(
    String token,
    ResetPasswordWithTokenRequestModel request,
  ) {
    return _apiClient.post<SecurityQuestionsResponseModel>(
      '${ApiConstants.auth.resetPasswordWithToken}?token=$token',
      data: request.toJson(),
      fromJsonT: (json) => SecurityQuestionsResponseModel.fromJson(json),
    );
  }
}
