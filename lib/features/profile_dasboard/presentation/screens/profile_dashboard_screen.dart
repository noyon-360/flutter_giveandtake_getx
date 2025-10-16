import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/common/widgets/app_scaffold.dart';
import 'package:karlfive/features/auth/presentation/screens/login_screen.dart';
import 'package:karlfive/features/home_static_screens/data/models/contactus_model.dart';
import 'package:karlfive/features/home_static_screens/presantation/screen/blog.dart';
import 'package:karlfive/features/profile_dasboard/presentation/screens/change_pass_screen.dart';
import 'package:karlfive/features/profile_dasboard/presentation/screens/job_history.dart';
import 'package:karlfive/features/profile_dasboard/presentation/screens/payment_history.dart';
import 'package:karlfive/features/profile_dasboard/presentation/screens/personal_iformation_screen.dart';
import '../../../home_static_screens/presantation/screen/Terms & Conditions.dart';
import '../../../home_static_screens/presantation/screen/aboutus_screen.dart';
import '../../../home_static_screens/presantation/screen/contact_us_screen.dart';
import '../../../home_static_screens/presantation/screen/frequently_questions.dart';
import '../../../home_static_screens/presantation/screen/privacy_policy.dart';

class ProfileDashboardScreen extends StatelessWidget {
  const ProfileDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _menuTile("assets/icons/personalinfo.png", "Personal Information", () {
                  Get.to(() => const PersonalInfoScreen());
                }),
                _menuTile("assets/icons/changepass.png", "Change Password", () {
                  Get.to(() => ChangePasswordScreen());
                }),
                _menuTile("assets/icons/jobhistory.png", "Job History", () {
                  Get.to(() =>  const JobHistoryScreen());
                }),
                _menuTile("assets/icons/paymenthistory.png", "Payment History", () {
                  Get.to(() => const PaymentHistoryScreen());
                }),
                _menuTile("assets/icons/logout.png", "Log out", () {
                  Get.to(() => const LoginScreen());
                }),

                _menuTile("assets/images/about.png", "About Us", (){
                  Get.to (() => const AboutUs());
                }),
                _menuTile("assets/images/pricacy.png", "Privacy Policy", (){
                  Get.to (() => const PrivacyPolicy());
                }),

                _menuTile("assets/images/trm.png", "Terms & Conditions", (){
                  Get.to (() => const TermsandConditions());
                }),

                _menuTile("assets/images/faq.png", "FrequentlyQuestions", (){
                  Get.to (() => const FrequentlyQuestions());
                }),

                _menuTile("assets/icons/nav_chat.png", "ContactUsScreen", (){
                  Get.to (() =>  ContactUsScreen(member: EditProfileModel()));
                }),

                _menuTile("assets/icons/profile_contactus.png", "Blog", (){
                  Get.to (() =>  BlogScreen());
                })
              ],
            ),
          ),
        ),
      ),

    );
  }

  Widget _menuTile(String iconPath, String title, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      leading: Image.asset(
        iconPath,
        width: 22,
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
