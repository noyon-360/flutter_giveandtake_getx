import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutx_core/flutx_core.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/common/constants/app_images.dart';
import 'package:karlfive/core/network/services/secure_store_services.dart';
import 'package:karlfive/core/theme/app_buttoms.dart';
import 'package:karlfive/core/theme/input_decoration_extensions.dart';
import 'package:karlfive/features/auth/presentation/controller/remember_me_controller.dart';
import 'package:karlfive/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:karlfive/features/auth/presentation/screens/signup_screen.dart';
import 'package:karlfive/features/auth/presentation/widgets/different_login_approach.dart';

import '../../../../core/common/widgets/app_logo.dart';
import '../../../../core/common/widgets/app_scaffold.dart';
import '../../../../core/common/widgets/form_error_message.dart';
import '../../../../core/common/widgets/or_divider_with_circle.dart';
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
    // TODO: implement initState
    _signUpRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Get.to(SignupScreen());
      };

    super.initState();
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


    _authController.login(email:  _emailController.text, password:  _passwordController.text, rememberMeController);
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: AppScaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AppLogo(
                          images: AppImages.appLogoLandscape,
                          height: 193,
                          width: 193,
                        ),

                        SizedBox(height: 37),

                        Text(
                          'Log In Your Account',
                          style: TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 24,
                          ),
                        ),

                        SizedBox(height: 16),

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
                            color: AppColors.white,
                          ),
                          decoration: context.primaryInputDecoration.copyWith(
                            hintText: "Enter your email",
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: AppColors.prefixIconColor,
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
                              style: TextStyle(color: AppColors.primaryText),
                              decoration: context.primaryInputDecoration
                                  .copyWith(
                                    hintText: "Enter your Password",
                                    prefixIcon: Icon(
                                      Icons.lock_open_outlined,
                                      color: AppColors.prefixIconColor,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        obscure
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: AppColors.buttonText,
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

                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Obx(
                                  () => Checkbox(
                                    value:
                                        rememberMeController.rememberMe.value,
                                    activeColor: AppColors.checkboxColor,
                                    // fill color when checked
                                    checkColor: AppColors.prefixIconColor,
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
                                          color: AppColors.prefixIconColor,
                                          width: 2,
                                        );
                                      }
                                      // Border when unchecked
                                      return BorderSide(
                                        color: AppColors.prefixIconColor,
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
                                    style: TextStyle(
                                      color: AppColors.rememberMeColor,
                                    ),
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
                                  color: AppColors.primaryGreen,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Gap.h16,

                        /// [Button] Sign In
                        // ListenableBuilder(
                        //   listenable: _authController,
                        //   builder: (context, _) {
                        //     return PrimaryButton(
                        //       isLoading: _authController.isLoading.value,
                        //       onPressed: _submit,
                        //       text: "Sign In",
                        //     );
                        //   },
                        // ),
                        Obx(
                          () => PrimaryButton(
                            isLoading: _authController.isLoading.value,
                            onPressed: _submit,
                            text: "Sign In",
                          ),
                        ),

                        Gap.h16,

                        Center(
                          child: RichText(
                            text: TextSpan(
                              text: 'New To our Platform? ',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: AppColors.rememberMeColor,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Sign Up Here',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.primaryGreen,
                                  ),
                                  recognizer: _signUpRecognizer,
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 16),

                        OrDividerWithCircle(),

                        Gap.h16,

                        DifferentLoginApproach(
                          text: 'Continue With Google',
                          image: AppImages.googleLogo,
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
