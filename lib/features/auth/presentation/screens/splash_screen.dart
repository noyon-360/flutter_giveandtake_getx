import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:karlfive/features/auth/presentation/controller/splash_screen_controller.dart';

import '../../../../core/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
     {
  // late final AnimationController _ctrl;
  // late final Animation<double> _bgAnimation; // background bubbles
  // late final Animation<double> _fgAnimation; // foreground logo

  // keep existing GetX controller registration
  final controller = Get.put(SplashController());

  @override
  void initState() {
    super.initState();

    // _ctrl = AnimationController(
    //   vsync: this,
    //   duration: const Duration(milliseconds: 1000),
    // );

    // // background bubbles: start slightly earlier
    // _bgAnimation = CurvedAnimation(
    //   parent: _ctrl,
    //   curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    // );

    // // foreground logo: slight delay for nicer stagger
    // _fgAnimation = CurvedAnimation(
    //   parent: _ctrl,
    //   curve: const Interval(0.35, 1.0, curve: Curves.easeOutBack),
    // );

    // // start the animation sequence
    // _ctrl.forward();

    // // Navigate to onboarding after animation completes
    // _ctrl.addStatusListener((status) {
    //   if (status == AnimationStatus.completed) {
    //     Future.delayed(const Duration(milliseconds: 600), () {
    //       Get.off(
    //         () => const OnboardingScreen(),
    //         transition: Transition.fadeIn,
    //         duration: const Duration(milliseconds: 900),
    //       );
    //     });
    //   }
    // });
  }

  @override
  void dispose() {
    // _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // keep exact Positioned values, but animate opacity/scale
              //   Positioned(
              //     right: -screenWidth * 0.25,
              //     bottom: -screenHeight * 0.25,
              //     child: FadeTransition(
              //       opacity: _bgAnimation,
              //       child: ScaleTransition(
              //         scale: Tween<double>(
              //           begin: 0.96,
              //           end: 1.0,
              //         ).animate(_bgAnimation),
              //         child: AppLogo(
              //           images: AppImages.splashBubbles,
              //           height: 300,
              //           width: 300,
              //         ),
              //       ),
              //     ),
              //   ),

              //   // foreground logo stays in same place; animate in place
              //   FadeTransition(
              //     opacity: _fgAnimation,
              //     child: ScaleTransition(
              //       scale: Tween<double>(
              //         begin: 0.8,
              //         end: 1.0,
              //       ).animate(_fgAnimation),
              //       child: Hero(
              //         tag: 'app_logo_transition',
              //         child: AppLogo(
              //           images: AppImages.appLogoWhite,
              //           height: 180,
              //           width: 220,
              //         ),
              //       ),
              //     ),
              //   ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
