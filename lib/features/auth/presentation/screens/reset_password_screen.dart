import 'package:flutx_core/core/theme/gap.dart';
import 'package:flutx_core/core/validation/validators.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/common/constants/app_images.dart';
import 'package:karlfive/core/common/widgets/app_logo.dart';
import 'package:karlfive/core/common/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:karlfive/core/theme/app_buttoms.dart';
import 'package:karlfive/core/theme/app_colors.dart';
import 'package:karlfive/core/theme/input_decoration_extensions.dart';

import '../controller/auth_controller.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _emailFocus = FocusNode();

  final TextEditingController _emailController = TextEditingController();

  final _authController = Get.find<AuthController>();

  void _submit() async {
    // Hide keyboard immediately
    if (mounted) FocusScope.of(context).unfocus();

    _authController.resetPass(_emailController.text);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 51),
              AppLogo(
                images: AppImages.appLogoLandscape,
                width: 193,
                height: 193,
              ),

              SizedBox(height: 109),
              Text(
                'Reset password',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Enter your email to receive the OTP',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.rememberMeColor,
                ),
              ),

              SizedBox(height: 32),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      focusNode: _emailFocus,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      style: TextStyle(fontSize: 16, color: AppColors.white),
                      decoration: context.primaryInputDecoration.copyWith(
                        hintText: "Enter your email",
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: AppColors.prefixIconColor,
                        ),
                      ),
                      validator: Validators.email,
                      autofillHints: const [AutofillHints.email],
                    ),

                    Gap.h16,

                    Obx(
                      () => PrimaryButton(
                        onPressed: _submit,
                        isLoading: _authController.isLoading.value,
                        text: 'Sent OTP',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
