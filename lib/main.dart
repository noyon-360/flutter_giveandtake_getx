import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giveandtake/core/init/app_initializer.dart';
import 'package:giveandtake/core/theme/app_theme.dart';
import 'package:giveandtake/features/Home/presentation/screen/home_screen.dart';
import 'package:giveandtake/features/auth/presentation/screens/splash_screen.dart';

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
