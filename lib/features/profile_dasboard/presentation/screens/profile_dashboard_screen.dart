import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/features/profile_dasboard/presentation/screens/change_pass_screen.dart';
import 'package:karlfive/features/profile_dasboard/presentation/screens/personal_iformation_screen.dart';

import '../../../../core/bottomNavbar/widgets/custom_bottom_navbar.dart';

class ProfileDashboardScreen extends StatelessWidget {
  const ProfileDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Profile",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Color(0xFF000929),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _menuTile("assets/icons/personalinfo.png", "Personal Information", () {
              Get.to(() => const PersonalInfoScreen());
            }),
            _menuTile("assets/icons/changepass.png", "Change Password", () {
              Get.to(() => ChangePasswordScreen());
            }),
            _menuTile("assets/icons/jobhistory.png", "Job History", () {}),
            _menuTile("assets/icons/paymenthistory.png", "Payment History", () {}),
            _menuTile("assets/icons/logout.png", "Log out", () {}),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  Widget _menuTile(String iconPath, String title, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      leading: Image.asset(
        iconPath,
        width: 24,
        height: 24,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFF272727),
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
    );
  }
}
