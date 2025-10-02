import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/common/constants/app_images.dart';
import 'package:karlfive/core/common/widgets/app_logo.dart';
import 'package:karlfive/core/theme/app_buttoms.dart';
import 'package:karlfive/features/auth/presentation/controller/auth_controller.dart';
import 'package:karlfive/features/auth/presentation/widgets/otp_code_field.dart';

import '../../../../core/common/widgets/app_scaffold.dart';
import '../../../../core/common/widgets/form_error_message.dart';
import '../../../../core/theme/app_colors.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key, required this.email});
  final String email;

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  late TapGestureRecognizer _resendOtp;
  final _authController = Get.find<AuthController>();
  final TextEditingController otpController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _resendOtp = TapGestureRecognizer()
      ..onTap = () {
        _authController.resendOTP(widget.email);
      };

    super.initState();
  }

  _submit() {
    _authController.verifyOTP(widget.email, otpController.text);
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
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 51),
              AppLogo(images: AppImages.appLogoLandscape),
              SizedBox(height: 74),

              Text(
                'Enter OTP',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Enter your receive OTP',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.rememberMeColor,
                ),
              ),

              Obx(() {
                final error = _authController.errorMessage.value;
                if (error.isNotEmpty) {
                  return FormErrorMessage(message: error);
                }
                return const SizedBox.shrink(); // return empty widget
              }),

              SizedBox(height: 32),

              PinCode(otpController: otpController),

              SizedBox(height: 24),

              Center(
                child: RichText(
                  text: TextSpan(
                    text: 'Didn\'t Receive OTP? ',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: AppColors.rememberMeColor,
                    ),
                    children: [
                      TextSpan(
                        text: 'RESEND OTP',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: AppColors.primaryGreen,
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
                  onPressed: _submit,
                  isLoading: _authController.isLoading.value,
                  text: 'Verify Now',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
