import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/features/Home/presentation/screen/home_screen.dart';

import '../../../core/bottomNavbar/widgets/custom_bottom_navbar.dart';
import '../../../core/services/get_user_profile_service.dart';
import '../../../features/Home/presentation/screen/candidate_dashboard_screen.dart';
import '../../../features/profile_dasboard/presentation/screens/profile_dashboard_screen.dart';
import '../controllers/bottom_nav_controller.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  // Try to find existing controller, or create new one
  final BottomNavController navController = 
    Get.isRegistered<BottomNavController>() 
      ? Get.find<BottomNavController>()
      : Get.put(BottomNavController());

  final GetUserProfileService profileService = Get.find<GetUserProfileService>();

  @override
  Widget build(BuildContext context) {
    // Reset to index 0 (Home) when this screen is shown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('📱 DashboardScreen built - resetting to Home screen');
      navController.resetToHome();
    });

    return Scaffold(
      body: Obx(() {
        final user = profileService.userInfoRx.value;
        Widget home = const HomeScreen();
        
        if (user != null && user.role == 'candidate') {
           home = const CandidateDashboardScreen();
        }

        final List<Widget> screens = [
          home,
          const Center(child: Text("Chat Screen")),
          const Center(child: Text("Notifications")),
          const ProfileDashboardScreen(),
        ];
        
        return screens[navController.currentIndex.value];
      }),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
