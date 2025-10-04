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

import 'package:karlfive/features/profile_dasboard/presentation/screens/profile_dashboard_screen.dart';
import 'package:karlfive/features/auth/presentation/screens/splash_screen.dart';
import 'package:karlfive/core/common/constants/stripe_key.dart';

import 'core/bottomNavbar/controllers/bottom_nav_controller.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // App initialize
  await AppInitializer.initializeApp();

  // Stripe setup

  Stripe.publishableKey = StripeKey.publishableKey;
  Stripe.merchantIdentifier = 'merchant.com.yourapp';
  await Stripe.instance.applySettings();

  // Inject BottomNavController globally
  Get.put(BottomNavController());

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
      home: ProfileDashboardScreen(),
    );
  }
}
