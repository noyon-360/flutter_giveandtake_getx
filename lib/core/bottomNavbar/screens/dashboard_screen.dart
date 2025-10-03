import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/bottomNavbar/widgets/custom_bottom_navbar.dart';
import '../../../features/profile_dasboard/presentation/screens/profile_dashboard_screen.dart';
import '../controllers/bottom_nav_controller.dart';



class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final BottomNavController navController = Get.put(BottomNavController());

  final List<Widget> screens = const [
    Center(child: Text("Home Screen")),
    Center(child: Text("Chat Screen")),
    Center(child: Text("Notifications")),
    ProfileDashboardScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => screens[navController.currentIndex.value]),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
