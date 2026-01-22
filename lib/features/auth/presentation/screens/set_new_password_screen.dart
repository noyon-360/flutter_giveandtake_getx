import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giveandtake/core/common/constants/app_images.dart';
import 'package:giveandtake/core/common/widgets/app_logo.dart';
import 'package:giveandtake/core/theme/app_buttoms.dart';
import 'package:giveandtake/core/theme/input_decoration_extensions.dart';
import 'package:giveandtake/features/auth/presentation/controller/auth_controller.dart';

import '../../../../core/common/widgets/app_scaffold.dart';
import '../../../../core/theme/app_colors.dart';

const passwordRequirements = '''Passwords should be:\n
A minimum of ’10 characters’
A minimum of 1 number
A minimum of 1 special character
A minimum of 1 upper case character
A minimum of 1 lower case character
You should not use any of your last 5 passwords
Keep your password as safe as your bank pin number!''';

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
  final ValueNotifier<bool> _showValidationError = ValueNotifier<bool>(false);

  _submit() {
    // Check if passwords match and meet requirements
    if (_passwordTEController.text.isEmpty ||
        _confirmPasswordTEController.text.isEmpty ||
        _passwordTEController.text != _confirmPasswordTEController.text ||
        _passwordTEController.text.length < 8) {
      _showValidationError.value = true;
      return;
    }

    _showValidationError.value = false;

    // Trim whitespace from password to avoid issues
    final cleanPassword = _passwordTEController.text.trim();

    print('=== PASSWORD RESET SCREEN ===');
    print('Email: ${widget.email}');
    print('OTP: ${widget.otp}');
    print('Original Password: "${_passwordTEController.text}"');
    print('Cleaned Password: "$cleanPassword"');
    print('Password Length: ${cleanPassword.length}');

    _authController.setNewPass(
      widget.email.trim(),
      widget.otp.trim(),
      cleanPassword,
    );
  }

  @override
  void dispose() {
    _passwordTEController.dispose();
    _confirmPasswordTEController.dispose();
    _obscurePassword.dispose();
    _showValidationError.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 51),

                Center(child: AppLogo(images: AppImages.appLogoBlue)),

                SizedBox(height: 49),

                Text(
                  'Reset password',
                  style: TextStyle(
                    color: AppColors.textBlack,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                SizedBox(height: 8),

                Text(
                  'Create a new password',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textGrey,
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
                            style: TextStyle(color: AppColors.textGrey),
                            decoration: context.primaryInputDecoration.copyWith(
                              hintText: "New Password",
                              hintStyle: TextStyle(
                                color: AppColors.textFieldLightGrey,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  obscure
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: AppColors.textFieldLightGrey,
                                ),
                                onPressed: () =>
                                    _obscurePassword.value = !obscure,
                              ),
                            ),
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
                            style: TextStyle(color: AppColors.textBlack),
                            decoration: context.primaryInputDecoration.copyWith(
                              hintText: "Confirm Password",
                              hintStyle: TextStyle(
                                color: AppColors.textFieldLightGrey,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  obscure
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: AppColors.textFieldLightGrey,
                                ),
                                onPressed: () =>
                                    _obscurePassword.value = !obscure,
                              ),
                            ),
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
                    height: 50,
                    onPressed: _submit,
                    isLoading: _authController.isLoading.value,
                    text: 'Reset Password',
                  ),
                ),

                SizedBox(height: 8),

                Center(
                  child: ValueListenableBuilder<bool>(
                    valueListenable: _showValidationError,
                    builder: (context, showError, _) {
                      if (!showError) return SizedBox.shrink();
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 16),
                            child: Text(
                              'Your new password does not meet our password policy requirements’.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Text(
                            passwordRequirements,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
