import 'package:flutter/material.dart';
import 'package:flutx_core/core/validation/validators.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/common/constants/app_images.dart';
import 'package:karlfive/core/common/widgets/app_logo.dart';
import 'package:karlfive/core/theme/app_buttoms.dart';
import 'package:karlfive/core/theme/input_decoration_extensions.dart';
import 'package:karlfive/features/auth/presentation/controller/auth_controller.dart';

import '../../../../core/common/widgets/app_scaffold.dart';
import '../../../../core/theme/app_colors.dart';

class SetNewPasswordScreen extends StatefulWidget {
  const SetNewPasswordScreen({
    super.key,
    required this.email,
    required this.otp,
  });
  final String email;
  final String otp;

  @override
  State<SetNewPasswordScreen> createState() => _SetNewPasswordScreenState();
}

class _SetNewPasswordScreenState extends State<SetNewPasswordScreen> {
  final _authController = Get.find<AuthController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _confirmPasswordTEController =
      TextEditingController();

  final ValueNotifier<bool> _obscurePassword = ValueNotifier<bool>(true);

  _submit() {
    if (!_formKey.currentState!.validate()) return;

    _authController.setNewPass(
      widget.email,
      widget.otp,
      _passwordTEController.text,
    );
  }

  @override
  void dispose() {
    _passwordTEController.dispose();
    _confirmPasswordTEController.dispose();
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
              SizedBox(height: 49),
              Text(
                'Reset password',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Set New Password',
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
                    ValueListenableBuilder<bool>(
                      valueListenable: _obscurePassword,
                      builder: (context, obscure, _) {
                        return TextFormField(
                          controller: _passwordTEController,
                          focusNode: _passwordFocus,
                          obscureText: obscure,
                          textInputAction: TextInputAction.next,
                          style: TextStyle(color: AppColors.primaryText),
                          decoration: context.primaryInputDecoration.copyWith(
                            hintText: "New Password",
                            hintStyle: TextStyle(
                              color: AppColors.prefixIconColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: AppColors.prefixIconColor,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: AppColors.prefixIconColor,
                              ),
                              onPressed: () =>
                                  _obscurePassword.value = !obscure,
                            ),
                          ),
                          //
                          validator: Validators.password,
                          // onFieldSubmitted: (_) => _submit(),
                        );
                      },
                    ),

                    SizedBox(height: 16),
                    ValueListenableBuilder<bool>(
                      valueListenable: _obscurePassword,
                      builder: (context, obscure, _) {
                        return TextFormField(
                          controller: _confirmPasswordTEController,
                          focusNode: _confirmPasswordFocus,
                          obscureText: obscure,
                          textInputAction: TextInputAction.done,
                          style: TextStyle(color: AppColors.primaryText),
                          decoration: context.primaryInputDecoration.copyWith(
                            hintText: "Confirm Password",
                            hintStyle: TextStyle(
                              color: AppColors.prefixIconColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: AppColors.prefixIconColor,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: AppColors.prefixIconColor,
                              ),
                              onPressed: () =>
                                  _obscurePassword.value = !obscure,
                            ),
                          ),
                          validator: Validators.password,
                          onFieldSubmitted: (_) => _submit(),
                        );
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16),

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
