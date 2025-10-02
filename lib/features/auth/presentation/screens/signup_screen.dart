import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutx_core/core/validation/validators.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/common/widgets/app_scaffold.dart';
import 'package:karlfive/core/common/widgets/or_divider_with_circle.dart';
import 'package:karlfive/core/theme/app_buttoms.dart';
import 'package:karlfive/core/theme/app_colors.dart';
import 'package:karlfive/core/theme/input_decoration_extensions.dart';
import 'package:karlfive/features/auth/presentation/controller/auth_controller.dart';
import 'package:karlfive/features/auth/presentation/controller/term_of_services_and_privacy_policy_controller.dart';
import 'package:karlfive/features/auth/presentation/screens/login_screen.dart';
import 'package:karlfive/features/auth/presentation/screens/otp_verification_to_complete_register.dart';

import '../../../../core/common/constants/app_images.dart';
import '../../../../core/common/widgets/form_error_message.dart';
import '../widgets/different_login_approach.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final controller = Get.put(TermOfServicesAndPrivacyPolicyController());

  final _authController = Get.find<AuthController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneNumberFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  final TextEditingController _nameTEController = TextEditingController();
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _phoneNumberTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _confirmPasswordTEController = TextEditingController();

  final ValueNotifier<bool> _obscurePassword = ValueNotifier<bool>(true);

  late TapGestureRecognizer _termsRecognizer;
  late TapGestureRecognizer _privacyRecognizer;
  late TapGestureRecognizer _signInRecognizer;

  @override
  void initState() {
    super.initState();
    _termsRecognizer = TapGestureRecognizer()
      ..onTap = () {
        // Navigate to Terms of Service page

        Get.to('page');
      };

    _privacyRecognizer = TapGestureRecognizer()
      ..onTap = () {
        // Navigate to Privacy Policy page
        Get.to('');
      };

    _signInRecognizer = TapGestureRecognizer()
      ..onTap = () {
        // Navigate to Privacy Policy page
        Get.to(LoginScreen());
      };
  }

  @override
  void dispose() {
    _obscurePassword.dispose();

    _passwordTEController.dispose();

    _passwordFocus.dispose();
    _termsRecognizer.dispose();
    _privacyRecognizer.dispose();
    _signInRecognizer.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  /// [Submit the form]
  /// Check the email and password validations
  ///
  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // Hide keyboard immediately
    if (mounted) FocusScope.of(context).unfocus();

    _authController.register(
      _nameTEController.text.toString(),
      _emailTEController.text,
      _passwordTEController.text,
      _phoneNumberTEController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: AppScaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 59),
                Text(
                  'Create Your Account',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),

                SizedBox(height: 16),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name',
                        style: TextStyle(
                          color: AppColors.textFieldTitle,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: _nameTEController,
                        focusNode: _nameFocus,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.white,
                        ),
                        decoration: context.primaryInputDecoration.copyWith(
                          hintText: "Enter your Full Name",
                          hintStyle: TextStyle(
                            color: AppColors.prefixIconColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: AppColors.prefixIconColor,
                          ),
                        ),
                        validator: Validators.name,
                      ),

                      ///Email
                      SizedBox(height: 16),
                      Text(
                        'Email',
                        style: TextStyle(
                          color: AppColors.textFieldTitle,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: _emailTEController,
                        focusNode: _emailFocus,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        style: TextStyle(fontSize: 16, color: AppColors.white),
                        decoration: context.primaryInputDecoration.copyWith(
                          hintText: "Enter your email",
                          hintStyle: TextStyle(
                            color: AppColors.prefixIconColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: AppColors.prefixIconColor,
                          ),
                        ),
                        validator: Validators.email,
                        autofillHints: const [AutofillHints.email],
                      ),

                      SizedBox(height: 16),
                      Text(
                        'Phone Number',
                        style: TextStyle(
                          color: AppColors.textFieldTitle,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: _phoneNumberTEController,
                        focusNode: _phoneNumberFocus,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        style: TextStyle(fontSize: 16, color: AppColors.white),
                        decoration: context.primaryInputDecoration.copyWith(
                          hintText: "Enter your Phone Number",
                          hintStyle: TextStyle(
                            color: AppColors.prefixIconColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          prefixIcon: Icon(
                            Icons.phone_outlined,
                            color: AppColors.prefixIconColor,
                          ),
                        ),
                        validator: Validators.phone,
                        autofillHints: const [AutofillHints.email],
                      ),

                      SizedBox(height: 16),
                      Text(
                        'Password',
                        style: TextStyle(
                          color: AppColors.textFieldTitle,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
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
                              hintText: "Create a Password",
                              hintStyle: TextStyle(
                                color: AppColors.prefixIconColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                              prefixIcon: Icon(
                                Icons.lock_outlined,
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
                      Text(
                        'Confirm Password',
                        style: TextStyle(
                          color: AppColors.textFieldTitle,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
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
                              hintText: "Confirm a Password",
                              hintStyle: TextStyle(
                                color: AppColors.prefixIconColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                              prefixIcon: Icon(
                                Icons.lock_open_outlined,
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

                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(
                            () => Checkbox(
                              value: controller.privacy.value,
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
                                if (states.contains(WidgetState.selected)) {
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
                              onChanged: (_) => controller.toggleprivacy(),
                            ),
                          ),

                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                text: 'By Registration, You agree to the ',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.white,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'term of services ',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.primaryGreen,
                                    ),
                                    recognizer: _termsRecognizer,
                                  ),

                                  TextSpan(
                                    text: 'and ',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.white,
                                    ),
                                  ),

                                  TextSpan(
                                    text: 'privacy policy.',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.primaryGreen,
                                    ),
                                    recognizer: _privacyRecognizer,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 16),

                      Obx(
                        () => PrimaryButton(
                          isLoading: _authController.isLoading.value,
                          onPressed: () {
                            _submit();
                          },
                          text: "Sign Up",
                        ),
                      ),

                      SizedBox(height: 16),

                      Center(
                        child: RichText(
                          text: TextSpan(
                            text: 'Already You Have Account? ',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: AppColors.rememberMeColor,
                            ),
                            children: [
                              TextSpan(
                                text: 'Sign In Here',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.primaryGreen,
                                ),
                                recognizer: _signInRecognizer,
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 16),

                      OrDividerWithCircle(),

                      SizedBox(height: 16),
                      DifferentLoginApproach(
                        text: 'Continue With Google',
                        image: AppImages.googleLogo,
                      ),
                    ],
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
