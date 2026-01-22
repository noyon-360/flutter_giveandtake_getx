import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutx_core/flutx_core.dart';
import 'package:get/get.dart';
import 'package:giveandtake/core/common/constants/app_images.dart';
import 'package:giveandtake/core/theme/app_buttoms.dart';
import 'package:giveandtake/core/theme/input_decoration_extensions.dart';
import 'package:giveandtake/features/auth/presentation/controller/remember_me_controller.dart';
import 'package:giveandtake/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:giveandtake/features/auth/presentation/screens/signup_screen.dart';
import 'package:giveandtake/features/auth/presentation/widgets/different_login_approach.dart';

import '../../../../core/common/widgets/app_logo.dart';
import '../../../../core/common/widgets/app_scaffold.dart';
import '../../../../core/common/widgets/form_error_message.dart';

import '../../../../core/theme/app_colors.dart';
import '../controller/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final ValueNotifier<bool> _obscurePassword = ValueNotifier<bool>(true);

  /// [Controller]
  final _authController = Get.find<AuthController>();
  final rememberMeController = Get.put(RememberMeController());
  late TapGestureRecognizer _signUpRecognizer;

  @override
  void initState() {
    super.initState();

    // Reset loading state when entering the screen
    _authController.setLoading(false);
    _authController.setError('');

    _signUpRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Get.to(SignupScreen());
      };
  }

  @override
  void dispose() {
    _obscurePassword.dispose();

    _passwordController.dispose();

    _passwordFocus.dispose();

    // _authController.dispose();
    super.dispose();
  }

  /// [Submit the form]
  /// Check the email and password validations
  ///
  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // Hide keyboard immediately
    if (mounted) FocusScope.of(context).unfocus();

    _authController.login(
      email: _emailController.text,
      password: _passwordController.text,
      rememberMeController,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: AppScaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: Column(
            children: [
              AppLogo(images: AppImages.appLogoBlue, height: 128, width: 128),

              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: AppColors.textBlack,
                            fontWeight: FontWeight.w900,
                            fontSize: 24,
                          ),
                        ),

                        SizedBox(height: 48),

                        /// [Api Error messages]
                        ///
                        Obx(() {
                          final error = _authController.errorMessage.value;
                          if (error.isNotEmpty) {
                            return FormErrorMessage(message: error);
                          }
                          return const SizedBox.shrink(); // return empty widget
                        }),

                        // AnimatedBuilder(
                        //   animation: _authController,
                        //   builder: (context, _) {
                        //     return
                        //
                        //   },
                        // ),

                        /// [Text Field] Email
                        TextFormField(
                          controller: _emailController,
                          focusNode: _emailFocus,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textBlack,
                          ),
                          decoration: context.primaryInputDecoration.copyWith(
                            hintText: "Enter your email",
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: AppColors.textFieldLightGrey,
                            ),
                          ),
                          validator: Validators.email,
                          onFieldSubmitted: (_) => FocusScope.of(
                            context,
                          ).requestFocus(_passwordFocus),
                          autofillHints: const [AutofillHints.email],
                        ),

                        Gap.h16,

                        /// [Text field] Password
                        ValueListenableBuilder<bool>(
                          valueListenable: _obscurePassword,
                          builder: (context, obscure, _) {
                            return TextFormField(
                              controller: _passwordController,
                              focusNode: _passwordFocus,
                              obscureText: obscure,
                              textInputAction: TextInputAction.done,
                              style: TextStyle(color: AppColors.textGrey),
                              decoration: context.primaryInputDecoration
                                  .copyWith(
                                    hintText: "Enter your Password",
                                    prefixIcon: Icon(
                                      Icons.lock_open_outlined,
                                      color: AppColors.textFieldLightGrey,
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

                              // validator: Validators.password,
                              onFieldSubmitted: (_) => _submit(),
                            );
                          },
                        ),

                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Obx(
                                  () => Checkbox(
                                    value:
                                        rememberMeController.rememberMe.value,
                                    activeColor: AppColors.primaryBlue,
                                    // fill color when checked
                                    checkColor: AppColors.primaryWhite,
                                    //  tick color
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                    side: WidgetStateBorderSide.resolveWith((
                                      states,
                                    ) {
                                      if (states.contains(
                                        WidgetState.selected,
                                      )) {
                                        //  Border when checked
                                        return BorderSide(
                                          color: AppColors.textBlack,
                                          width: 1,
                                        );
                                      }
                                      // Border when unchecked
                                      return BorderSide(
                                        color: AppColors.textBlack,
                                        width: 1,
                                      );
                                    }),
                                    onChanged: (_) =>
                                        rememberMeController.toggleRememberMe(),
                                  ),
                                ),

                                GestureDetector(
                                  onTap: rememberMeController.toggleRememberMe,
                                  // tap text also toggles
                                  child: const Text(
                                    "Remember Me",
                                    style: TextStyle(color: AppColors.textGrey),
                                  ),
                                ),
                              ],
                            ),

                            TextButton(
                              onPressed: () {
                                Get.to(ResetPasswordScreen());
                              },
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: AppColors.primaryBlue,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  decoration: TextDecoration.underline,
                                  decorationColor: AppColors.primaryBlue,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Gap.h16,

                        Obx(
                          () => PrimaryButton(
                            isLoading: _authController.isLoading.value,
                            onPressed: _submit,
                            text: "Sign In",
                          ),
                        ),

                        Gap.h32,

                        Center(
                          child: RichText(
                            text: TextSpan(
                              text: 'Don\'t have an account? ',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: AppColors.textGrey,
                              ),
                              children: [
                                TextSpan(
                                  text: 'click here',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.primaryBlue,
                                  ),
                                  recognizer: _signUpRecognizer,
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 32),

                        Gap.h16,

                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'or continue with,',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textFieldLightGrey,
                              ),
                            ),
                            SizedBox(height: 16),

                            DifferentLoginApproach(
                              image1: AppImages.googleLogo,
                              image2: AppImages.appleLogo,
                            ),
                          ],
                        ),
                      ],
                    ),
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
