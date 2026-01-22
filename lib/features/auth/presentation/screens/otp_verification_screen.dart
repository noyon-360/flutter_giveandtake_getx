import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutx_core/flutx_core.dart';
import 'package:get/get.dart';
import 'package:giveandtake/core/common/constants/app_images.dart';
import 'package:giveandtake/core/common/widgets/app_logo.dart';
import 'package:giveandtake/core/theme/app_buttoms.dart';
import 'package:giveandtake/features/auth/presentation/controller/auth_controller.dart';
import 'package:giveandtake/features/auth/presentation/widgets/otp_code_field.dart';

import '../../../../core/common/widgets/app_scaffold.dart';
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 25),
              Center(child: AppLogo(images: AppImages.appLogoBlue)),
              SizedBox(height: 50),

              Text(
                'Enter OTP',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textBlack,
                ),
              ),

              Gap.h8,

              Text(
                'Enter your receive OTP',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textGrey,
                ),
              ),

              // Obx(() {
              //   final error = _authController.errorMessage.value;
              //   if (error.isNotEmpty) {
              //     return FormErrorMessage(message: error);
              //   }
              //   return const SizedBox.shrink(); // return empty widget
              // }),
              Gap.h64,

              PinCode(otpController: otpController),

              SizedBox(height: 24),

              Obx(
                () => PrimaryButton(
                  onPressed: () {
                    if (otpController.text.length == 6) {
                      _authController.verifyOTPForPasswordReset(
                        widget.email,
                        otpController.text,
                      );
                    } else {
                      Get.snackbar(
                        'Invalid OTP',
                        'Please enter a 6-digit OTP',
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  },
                  isLoading: _authController.isLoading.value,
                  text: 'Verify',
                ),
              ),

              Gap.h32,

              Center(
                child: RichText(
                  text: TextSpan(
                    text: 'Didn\'t get a code? ',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: AppColors.textGrey,
                    ),
                    children: [
                      TextSpan(
                        text: 'Resend',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryLightBlue,
                        ),
                        recognizer: _resendOtp,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
