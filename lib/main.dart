import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/init/app_initializer.dart';
import 'package:karlfive/core/theme/app_theme.dart';
import 'package:karlfive/features/auth/presentation/screens/login_screen.dart';
import 'package:karlfive/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:karlfive/features/auth/presentation/screens/set_new_password_screen.dart';
import 'features/auth/presentation/screens/splash_screen.dart';
import 'package:karlfive/core/common/constants/stripe_key.dart';

import 'features/company_pricing/presentation/screens/plan_pricing_screen.dart';

void main() async {
  await AppInitializer.initializeApp();

  Stripe.publishableKey = StripeKey.publishableKey;
  Stripe.merchantIdentifier = 'merchant.com.yourapp';
  await Stripe.instance.applySettings();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GiveAndTake',
      theme: AppTheme.dark,
      // home: SplashScreen(),
      home: ResetPasswordScreen(),
    );
  }
}
