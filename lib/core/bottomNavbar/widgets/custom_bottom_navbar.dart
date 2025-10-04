import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../features/Navbar/controllers/bottom_nav_controller.dart';




class CustomBottomNavBar extends StatelessWidget {
  final BottomNavController navController = Get.find<BottomNavController>();

  CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => BottomNavigationBar(
      currentIndex: navController.currentIndex.value,
      onTap: (index) => navController.changeIndex(index),
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(0xFFF4F6FF),
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.black,
      items: [
        BottomNavigationBarItem(
          icon: Image.asset("assets/icons/nav_home.png", width: 24, height: 24),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Image.asset("assets/icons/nav_chat.png", width: 24, height: 24),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Image.asset("assets/icons/nav_noti.png", width: 24, height: 24),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Image.asset("assets/icons/nav_profile.png", width: 24, height: 24),
          label: '',
        ),
      ],
    ));
  }
}
