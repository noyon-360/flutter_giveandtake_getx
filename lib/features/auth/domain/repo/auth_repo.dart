import 'package:giveandtake/features/auth/data/models/auth_response_model.dart';
import 'package:giveandtake/features/auth/data/models/default_security_questions_response_model.dart';
import 'package:giveandtake/features/auth/data/models/login_request_model.dart';
import 'package:giveandtake/features/auth/data/models/otp_request_model.dart';
import 'package:giveandtake/features/auth/data/models/otp_request_model_register.dart';
import 'package:giveandtake/features/auth/data/models/otp_response_model.dart';
import 'package:giveandtake/features/auth/data/models/otp_response_model_register.dart';
import 'package:giveandtake/features/auth/data/models/refresh_token_request_model.dart';
import 'package:giveandtake/features/auth/data/models/refresh_token_response_model.dart';
import 'package:giveandtake/features/auth/data/models/register_request_model.dart';
import 'package:giveandtake/features/auth/data/models/reset_password_request_model.dart';
import 'package:giveandtake/features/auth/data/models/reset_password_response_model.dart';
import 'package:giveandtake/features/auth/data/models/reset_password_with_token_request_model.dart';
import 'package:giveandtake/features/auth/data/models/security_questions_request_model.dart';
import 'package:giveandtake/features/auth/data/models/security_questions_response_model.dart';
import 'package:giveandtake/features/auth/data/models/set_new_password_request_model.dart';
import 'package:giveandtake/features/auth/data/models/user_model.dart';
import 'package:giveandtake/features/auth/data/models/verify_security_answers_request_model.dart';

import '../../../../core/network/network_result.dart';
import '../../data/models/register_response_model.dart';
import '../../data/models/set_new_password_response_model.dart';

abstract class AuthRepository {
  NetworkResult<AuthResponseData> login(LoginRequestModel request);
  NetworkResult<RegisterResponseModel> register(RegisterRequestModel request);
  NetworkResult<ResetPasswordResponseModel> resetPassword(
    ResetPasswordRequestModel request,
  );
  NetworkResult<OtpVerificationResponseModel> otpVerify(
    OtpVerificationRequestModel request,
  );
  NetworkResult<SetNewPasswordResponseModel> setNewPassword(
    SetNewPasswordRequestModel request,
  );
  NetworkResult<RefreshTokenResponseModel> refreshToken(
    RefreshTokenRequestModel request,
  );
  NetworkResult<OtpResponseModelRegister> otpVerifyRegister(
    OtpRequestModelRegister request,
  );
  NetworkResult<UserModel> getUserProfile();

  // Security Questions
  NetworkResult<DefaultSecurityQuestionsResponseModel>
  getDefaultSecurityQuestions();
  NetworkResult<SecurityQuestionsResponseModel> submitSecurityAnswers(
    SecurityQuestionsRequestModel request,
  );
  NetworkResult<SecurityQuestionsResponseModel> verifySecurityAnswers(
    VerifySecurityAnswersRequestModel request,
  );
  NetworkResult<SecurityQuestionsResponseModel> resetPasswordWithToken(
    String token,
    ResetPasswordWithTokenRequestModel request,
  );
}
