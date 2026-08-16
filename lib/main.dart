import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart' show FlutterQuillLocalizations;
import 'package:get/get.dart';
import 'package:giveandtake/core/init/app_initializer.dart';
import 'package:giveandtake/core/services/deep_link_service.dart';
import 'package:giveandtake/core/theme/app_theme.dart';
import 'package:giveandtake/features/auth/presentation/screens/splash_screen.dart';
import 'package:giveandtake/features/content_pages/presentation/screens/content_page_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DeepLinkService.instance.initialize();

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
      localizationsDelegates: const [
        ...GlobalMaterialLocalizations.delegates,
        GlobalWidgetsLocalizations.delegate,
        FlutterQuillLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      getPages: [
        GetPage(
          name: '/pages/:slug',
          page: () => ContentPageScreen(slug: Get.parameters['slug'] ?? ''),
        ),
      ],
      home: SplashScreen(),
    );
  }
}
