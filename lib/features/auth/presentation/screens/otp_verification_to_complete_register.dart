import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giveandtake/core/common/constants/app_images.dart';
import 'package:giveandtake/core/common/widgets/app_logo.dart';
import 'package:giveandtake/core/theme/app_buttoms.dart';
import 'package:giveandtake/features/auth/presentation/controller/auth_controller.dart';
import 'package:giveandtake/features/auth/presentation/widgets/otp_code_field.dart';

import '../../../../core/common/widgets/app_scaffold.dart';
import '../../../../core/common/widgets/form_error_message.dart';
import '../../../../core/theme/app_colors.dart';

class OtpVerificationToCompleteRegister extends StatefulWidget {
  const OtpVerificationToCompleteRegister({super.key, required this.email});
  final String email;

  @override
  State<OtpVerificationToCompleteRegister> createState() =>
      _OtpVerificationToCompleteRegisterState();
}

class _OtpVerificationToCompleteRegisterState
    extends State<OtpVerificationToCompleteRegister> {
  late TapGestureRecognizer _resendOtp;
  final _authController = Get.find<AuthController>();
  final TextEditingController otpController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Reset controller state when entering this screen
    _authController.setLoading(false);
    _authController.setError('');

    _resendOtp = TapGestureRecognizer()
      ..onTap = () {
        _authController.resendOTP(widget.email);
      };
  }

  void _submit() {
    if (otpController.text.length == 6) {
      _authController.verifyOTPRegister(widget.email, otpController.text);
    } else {
      Get.snackbar(
        'Invalid OTP',
        'Please enter a 6-digit OTP',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void dispose() {
    _resendOtp.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 51),
                AppLogo(images: AppImages.appLogoBlue),
                SizedBox(height: 74),

                Text(
                  'Enter OTP',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryWhite,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Enter your receive OTP',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textGrey,
                  ),
                ),
                SizedBox(height: 32),

                Obx(() {
                  final error = _authController.errorMessage.value;
                  if (error.isNotEmpty) {
                    return FormErrorMessage(message: error);
                  }
                  return const SizedBox.shrink(); // return empty widget
                }),

                Obx(
                  () => PinCode(
                    otpController: otpController,
                    enabled: !_authController.isOtpExpired.value,
                  ),
                ),

                SizedBox(height: 16),

                Obx(
                  () => Text(
                    _authController.timerDisplay,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: _authController.isOtpExpired.value
                          ? Colors.red
                          : Colors.black,
                    ),
                  ),
                ),

                SizedBox(height: 24),

                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Didn\'t Receive OTP? ',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: AppColors.textGrey,
                      ),
                      children: [
                        TextSpan(
                          text: 'RESEND OTP',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textGreen,
                          ),
                          recognizer: _resendOtp,
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 12),
                Obx(
                  () => PrimaryButton(
                    onPressed: _authController.isOtpExpired.value
                        ? null
                        : _submit,
                    isLoading: _authController.isLoading.value,
                    text: _authController.isOtpExpired.value
                        ? 'OTP Expired'
                        : 'Verify Now',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
