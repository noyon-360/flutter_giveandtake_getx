import 'package:flutter/material.dart';

import '../../../../core/common/constants/app_images.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // App Logo
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.blue[300],
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  "YOUR LOGO",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Top image with rounded bottom edges
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              child: Image.asset(
                AppImages.onboardingBG, // replace with your image path
                height: MediaQuery.of(context).size.height * 0.35,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 32),

            // Rich text title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  children: [
                    TextSpan(
                      text: "Build Your ",
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextSpan(
                      text: "Personal Brand ",
                      style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                      text: "& ",
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextSpan(
                      text: "Get Hired Faster.",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Description text
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                "Create a powerful profile, showcase your video pitch, and connect with top recruiters all in one app. Create a powerful profile, showcase your video pitch, and connect with top recruiters all in one app.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
            ),

            const Spacer(),

            // Get Started Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    // TODO: Navigate to next screen
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
                      // TODO: Navigate to Login screen
                    },
                    child: const Text(
                      "Log In",
                      style: TextStyle(
                        color: Colors.lightBlueAccent,
                        fontWeight: FontWeight.w500,
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
