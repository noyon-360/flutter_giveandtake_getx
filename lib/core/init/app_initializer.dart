import 'package:flutter/widgets.dart';

import '../di/service_locator.dart';
import 'hive_intialization.dart';

class AppInitializer {
  static Future<void> initializeApp() async {
    WidgetsFlutterBinding.ensureInitialized();

    await HiveInitialization.initHive();

    setupServiceLocator();

    // StripeInitializer.intiStripe();

    // NOTE: the socket is intentionally NOT initialized here. At first launch
    // there is no access token yet, so an early socket would connect
    // unauthenticated and never be rebuilt. It is instead created lazily by
    // NotificationsController -> SocketService.joinNotification(userId) AFTER
    // login, so the handshake always carries a valid token, and onConnect
    // re-joins the room on every reconnect.
  }
}
