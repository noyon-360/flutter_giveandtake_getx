import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/init/app_initializer.dart';
import 'package:karlfive/core/theme/app_theme.dart';

import 'package:karlfive/core/common/constants/stripe_key.dart';
import 'package:karlfive/features/recruiter_account/presentation/screens/create_recruiter_account.dart';


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
      theme: AppTheme.light,
      // home: SplashScreen(),
      home: CreateRecruiterAccount(),
    );
  }
}