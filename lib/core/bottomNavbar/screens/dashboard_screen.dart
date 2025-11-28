import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/features/Home/presentation/screen/home_screen.dart';

import '../../../core/bottomNavbar/widgets/custom_bottom_navbar.dart';
import '../../../features/profile_dasboard/presentation/screens/profile_dashboard_screen.dart';
import '../controllers/bottom_nav_controller.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  // Try to find existing controller, or create new one
  final BottomNavController navController = 
    Get.isRegistered<BottomNavController>() 
      ? Get.find<BottomNavController>()
      : Get.put(BottomNavController());

  final List<Widget> screens = const [
    HomeScreen(),
    Center(child: Text("Chat Screen")),
    Center(child: Text("Notifications")),
    ProfileDashboardScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // Reset to index 0 (Home) when this screen is shown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('📱 DashboardScreen built - resetting to Home screen');
      navController.resetToHome();
    });

    return Scaffold(
      body: Obx(() => screens[navController.currentIndex.value]),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
