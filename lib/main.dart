import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/init/app_initializer.dart';
import 'package:karlfive/core/theme/app_theme.dart';
import 'package:karlfive/features/Home/presentation/screen/home_screen.dart';
import 'package:karlfive/features/auth/presentation/screens/splash_screen.dart';
import 'package:karlfive/features/company/presentation/screen/public_view_seach_screen.dart';
import 'package:karlfive/features/recruiter_account/presentation/screens/public_view_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // App initialize
  await AppInitializer.initializeApp();

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
      home: HomeScreen(),
    );
  }
}
