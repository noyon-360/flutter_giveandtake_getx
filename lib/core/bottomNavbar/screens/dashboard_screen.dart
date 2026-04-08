import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giveandtake/features/Home/presentation/screen/home_screen.dart';
import 'package:giveandtake/features/messaging/presentation/screens/messaging_screen.dart';
import 'package:giveandtake/features/notifications/presentation/screens/notifications_screen.dart';

import '../../../features/profile_dasboard/presentation/screens/profile_dashboard_screen.dart';
import '../controllers/bottom_nav_controller.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final BottomNavController navController =
      Get.isRegistered<BottomNavController>()
      ? Get.find<BottomNavController>()
      : Get.put(BottomNavController());

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      const HomeScreen(),
      MessagingScreen(),
      NotificationsScreen(),
      const ProfileDashboardScreen(),
    ];

    return Scaffold(
      body: Obx(() => screens[navController.currentIndex.value]),
    );
  }
}
