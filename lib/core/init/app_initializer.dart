import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../di/service_locator.dart';
import '../services/socket_service.dart';
import 'hive_intialization.dart';

class AppInitializer {
  static Future<void> initializeApp() async {
    WidgetsFlutterBinding.ensureInitialized();

    await HiveInitialization.initHive();

    setupServiceLocator();

    // StripeInitializer.intiStripe();

    if (Get.isRegistered<SocketService>()) {
      Get.find<SocketService>().initialize();
    }
  }
}
