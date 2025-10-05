import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutx_core/core/validation/validators.dart';
import 'package:flutx_core/flutx_core.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/common/widgets/app_scaffold.dart';
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

  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _surnameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _countryFocus = FocusNode();
  final FocusNode _phoneNumberFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final FocusNode _dateOfBirthFocus = FocusNode();

  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _surnameTEController = TextEditingController();
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _countryTEController = TextEditingController();
  final TextEditingController _phoneNumberTEController =
      TextEditingController();
  final TextEditingController _dateOfBirthTEController =
      TextEditingController();
  final TextEditingController _confirmPasswordTEController =
      TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();

  final ValueNotifier<bool> _obscurePassword = ValueNotifier<bool>(true);

  late TapGestureRecognizer _termsRecognizer;
  late TapGestureRecognizer _privacyRecognizer;
  late TapGestureRecognizer _signInRecognizer;

  @override
  void initState() {
    super.initState();
    _termsRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Get.to('page');
      };

    _privacyRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Get.to('');
      };

    _signInRecognizer = TapGestureRecognizer()
      ..onTap = () {
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
    _firstNameTEController.dispose();
    _surnameTEController.dispose();
    _emailTEController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (mounted) FocusScope.of(context).unfocus();

    _authController.register(
      _firstNameTEController.text.toString(),
      _surnameTEController.text.toString(),
      _emailTEController.text,
      _passwordTEController.text,
      _phoneNumberTEController.text,
      // _dateOfBirthTEController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: AppScaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap.h32,

                  Center(
                    child: Image(
                      image: AssetImage(AppImages.appLogoBlue),
                      height: 40,
                      width: 100,
                    ),
                  ),
                  SizedBox(height: 59),

                  Text(
                    'Create Your Account',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textBlack,
                    ),
                  ),

                  Gap.h8,

                  Text(
                    'Join us and start applying today',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textGrey,
                    ),
                  ),

                  SizedBox(height: 16),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //* <----------------- First name ----------------->*//
                        Text(
                          'First Name',
                          style: TextStyle(
                            color: AppColors.textBlack,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: _firstNameTEController,
                          focusNode: _firstNameFocus,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.primaryWhite,
                          ),
                          decoration: context.primaryInputDecoration.copyWith(
                            hintText: "Enter First Name",
                            hintStyle: TextStyle(
                              color: AppColors.textFieldLightGrey,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: AppColors.textFieldLightGrey,
                            ),
                          ),
                          validator:
                              Validators.name, //! <---------- Need to change ----------->
                        ),

                        Gap.h16,

                        Text(
                          'Surname',
                          style: TextStyle(
                            color: AppColors.textBlack,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: _surnameTEController,
                          focusNode: _surnameFocus,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.primaryWhite,
                          ),
                          decoration: context.primaryInputDecoration.copyWith(
                            hintText: "Enter Surname",
                            hintStyle: TextStyle(
                              color: AppColors.textFieldLightGrey,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: AppColors.textFieldLightGrey,
                            ),
                          ),
                          validator:
                              Validators.name, //! <---------- Need to change ----------->
                        ),

                        Gap.h16,

                        //* <-----------------Email----------------->*//
                        Text(
                          'Email',
                          style: TextStyle(
                            color: AppColors.textBlack,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: _emailTEController,
                          focusNode: _emailFocus,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.primaryWhite,
                          ),
                          decoration: context.primaryInputDecoration.copyWith(
                            hintText: "Enter Email",
                            hintStyle: TextStyle(
                              color: AppColors.textFieldLightGrey,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: AppColors.textFieldLightGrey,
                            ),
                          ),
                          validator: Validators.email,
                          autofillHints: const [AutofillHints.email],
                        ),

                        Gap.h16,

                        //* <-----------------Country----------------->*//
                        Text(
                          'Country',
                          style: TextStyle(
                            color: AppColors.textBlack,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: _countryTEController,
                          focusNode: _countryFocus,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.primaryWhite,
                          ),
                          decoration: context.primaryInputDecoration.copyWith(
                            hintText: "Country",
                            hintStyle: TextStyle(
                              color: AppColors.textFieldLightGrey,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          validator:
                              Validators.email, //! <---------- Need to change ----------->
                          autofillHints: const [AutofillHints.email],
                        ),

                        Gap.h16,

                        //*<-------------Phone Number--------------->*//
                        Text(
                          'Phone Number',
                          style: TextStyle(
                            color: AppColors.textBlack,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: _phoneNumberTEController,
                          focusNode: _phoneNumberFocus,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.primaryWhite,
                          ),
                          decoration: context.primaryInputDecoration.copyWith(
                            hintText: "Enter Phone Number",
                            hintStyle: TextStyle(
                              color: AppColors.textFieldLightGrey,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                            prefixIcon: Icon(
                              Icons.phone_outlined,
                              color: AppColors.textFieldLightGrey,
                            ),
                          ),
                          validator: Validators.phone,
                          autofillHints: const [AutofillHints.email],
                        ),

                        Gap.h16,

                        //*<-------------Date of Birth--------------->*//
                        Text(
                          'Date of Birth',
                          style: TextStyle(
                            color: AppColors.textBlack,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: _dateOfBirthTEController,
                          focusNode: _dateOfBirthFocus,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.primaryWhite,
                          ),
                          decoration: context.primaryInputDecoration.copyWith(
                            hintText: "MM/DD/YYYY",
                            hintStyle: TextStyle(
                              color: AppColors.textFieldLightGrey,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                            prefixIcon: Icon(
                              Icons.calendar_today_outlined,
                              color: AppColors.textFieldLightGrey,
                            ),
                          ),
                          validator:
                              Validators.phone, //! <---------- Need to change ----------->
                          autofillHints: const [AutofillHints.email], 
                        ),

                        Gap.h16,

                        //* <-----------------Password----------------->*//
                        Text(
                          'Password',
                          style: TextStyle(
                            color: AppColors.textBlack,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
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
                              style: TextStyle(color: AppColors.textBlack),
                              decoration: context.primaryInputDecoration
                                  .copyWith(
                                    hintText: "Create a Password",
                                    hintStyle: TextStyle(
                                      color: AppColors.textFieldLightGrey,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.lock_outlined,
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

                              validator: Validators.password,
                            );
                          },
                        ),

                        SizedBox(height: 16),
                        Text(
                          'Confirm Password',
                          style: TextStyle(
                            color: AppColors.textBlack,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
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
                              style: TextStyle(
                                color: AppColors.textFieldLightGrey,
                              ),
                              decoration: context.primaryInputDecoration
                                  .copyWith(
                                    hintText: "Confirm a Password",
                                    hintStyle: TextStyle(
                                      color: AppColors.textFieldLightGrey,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
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
                              validator: Validators.password, //! <---------- Need to change ----------->
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
                                  if (states.contains(WidgetState.selected)) {
                                    //  Border when checked
                                    return BorderSide(
                                      color: AppColors.textGrey,
                                      width: 1,
                                    );
                                  }
                                  // Border when unchecked
                                  return BorderSide(
                                    color: AppColors.textGrey,
                                    width: 1,
                                  );
                                }),
                                onChanged: (_) => controller.toggleprivacy(),
                              ),
                            ),

                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  text: 'I agree to the ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.textBlack,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Terms & Conditions',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primaryBlue,
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

                        Gap.h32,

                        Center(
                          child: RichText(
                            text: TextSpan(
                              text: 'Already You Have Account? ',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: AppColors.textFieldLightGrey,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Sign In Here',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primaryBlue,
                                  ),
                                  recognizer: _signInRecognizer,
                                ),
                              ],
                            ),
                          ),
                        ),

                        Gap.h16,

                        DifferentLoginApproach(
                          image1: AppImages.googleLogo,
                          image2: AppImages.appleLogo,
                        ),

                        Gap.h16,

                        SecondaryButton(
                          onPressed: () {},
                          text: "Join as a Recruiter",
                          width: double.infinity - 40,
                          textColor: AppColors.primaryBlue,
                          height: 48,
                        ),

                        Gap.h8,

                        SecondaryButton(
                          onPressed: () {},
                          text: "Join as a Company",
                          width: double.infinity - 40,
                          textColor: AppColors.primaryBlue,
                          height: 48,
                        ),
                        Gap.h32,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Already Have An Account?"),
                            GestureDetector(
                              onTap: () {
                                Get.to(LoginScreen());
                              },
                              child: Text(
                                "  Sign In Here",
                                style: TextStyle(
                                  color: AppColors.primaryLightBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 32),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
