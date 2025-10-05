import 'package:flutter/material.dart';

/// Custom page route that provides a smooth transition from splash to onboarding
class SplashToOnboardingTransition extends PageRouteBuilder {
  final Widget page;

  SplashToOnboardingTransition({required this.page})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: const Duration(milliseconds: 900),
        reverseTransitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Fade transition for the entire page
          return FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: animation,
                curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
              ),
            ),
            child: child,
          );
        },
      );
}
