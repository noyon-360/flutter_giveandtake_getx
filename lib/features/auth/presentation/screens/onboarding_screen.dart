import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:karlfive/features/auth/presentation/screens/login_screen.dart';
import 'package:karlfive/features/auth/presentation/screens/signup_screen.dart';

import '../../../../core/common/constants/app_images.dart';
import '../../../../core/common/widgets/app_logo.dart';
import '../../../../core/theme/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // No animation controller needed - Hero handles the transition

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.primaryWhite,
      body: SafeArea(
        top: false,
        bottom: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // App Logo with Hero animation
            Stack(
              alignment: Alignment.center,
              children: [
                // Top image with rounded bottom edges
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                  child: Image.asset(
                    AppImages.onboardingBG,
                    height: screenHeight * 0.45,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                // Hero widget wraps the logo for smooth transition
                // Center(
                //   child: Hero(
                //     tag: 'app_logo_transition',
                //     child: AppLogo(
                //       images: AppImages.appLogoWhite,
                //       height: 250,
                //       width: 250,
                //     ),
                //   ),
                // ),
              ],
            ),

            const SizedBox(height: 32),

            // Rich text title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: RichText(
                textAlign: TextAlign.start,
                text: const TextSpan(
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                  children: [
                    TextSpan(
                      text: "Build Your ",
                      style: TextStyle(color: AppColors.textGrey),
                    ),
                    TextSpan(
                      text: "Personal Brand ",
                      style: TextStyle(color: AppColors.textBlack),
                    ),
                    TextSpan(
                      text: "& ",
                      style: TextStyle(color: AppColors.textGrey),
                    ),
                    TextSpan(
                      text: "Get Hired Faster.",
                      style: TextStyle(color: AppColors.primaryBlue),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Description text
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Create a powerful profile, showcase your video pitch, and connect with top recruiters all in one app. Create a powerful profile, showcase your video pitch, and connect with top recruiters all in one app.",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 14.0,
                  color: AppColors.textGrey,
                  height: 1.5,
                ),
              ),
            ),

            const Spacer(),

            // Get Started Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Get.to(() => SignupScreen());
                  },
                  child: const Text(
                    "Get Started",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Login text
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account? ",
                    style: TextStyle(color: Colors.black87),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => LoginScreen());
                    },
                    child: const Text(
                      "Log In",
                      style: TextStyle(
                        color: AppColors.primaryLightBlue,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
