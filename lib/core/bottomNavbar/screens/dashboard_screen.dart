import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/features/Home/presentation/screen/home_screen.dart';

import '../../../features/profile_dasboard/presentation/screens/profile_dashboard_screen.dart';
import '../controllers/bottom_nav_controller.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  // Try to find existing controller, or create new one
  final BottomNavController navController =
      Get.isRegistered<BottomNavController>()
      ? Get.find<BottomNavController>()
      : Get.put(BottomNavController());

  @override
  Widget build(BuildContext context) {
    // Reset to index 0 (Home) when this screen is shown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('📱 DashboardScreen built - resetting to Home screen');
      navController.resetToHome();
    });

    final List<Widget> screens = [
      const HomeScreen(),
      const Center(child: Text("Chat Screen")),
      const Center(child: Text("Notifications")),
      const ProfileDashboardScreen(),
    ];

    return Scaffold(
      body: Obx(() => screens[navController.currentIndex.value]),
      // bottomNavigationBar: CustomBottomNavBar(), // Removed as per user request
    );
  }
}
