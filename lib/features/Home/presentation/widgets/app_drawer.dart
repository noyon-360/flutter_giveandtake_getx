import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/theme/app_colors.dart';
import 'package:karlfive/features/auth/presentation/controller/auth_controller.dart';
import 'package:karlfive/features/home_static_screens/data/models/contactus_model.dart';
import 'package:karlfive/features/home_static_screens/presentation/screen/contact_us_screen.dart';
import 'package:karlfive/features/job_listing/presentation/screens/bookmark_jobs_screen.dart';
import 'package:karlfive/features/profile_dasboard/presentation/screens/personal_iformation_screen.dart';

import '../../../home_static_screens/presentation/screen/Terms_screen.dart';
import '../../../home_static_screens/presentation/screen/aboutus_screen.dart';
import '../../../home_static_screens/presentation/screen/blog.dart';
import '../../../home_static_screens/presentation/screen/frequently_questions.dart';
import '../../../home_static_screens/presentation/screen/privacy_policy.dart';
import '../screens/my_plan_screen.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool _isHelpExpanded = false;
  bool _isMoreExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.primaryWhite,
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTileForNav(
              title: "Back",
              liconPath: "assets/icons/drawer_back.png",
              onTap: () => Get.back(),
            ),
            ListTileForNav(
              title: "Elevator Pitch & Resume",
              onTap: () {
                // TODO: Navigate to Elevator Pitch & Resume
              },
            ),
            ListTileForNav(
              title: "Blogs",
              onTap: () {
                Get.to (()=> BlogScreen());
              },
            ),

            // Help & Info with expandable sub-items
            ListTileForNav(
              title: "Help & Info",
              ticonPath: "assets/icons/Icon_down_homeDawer.png",
              isExpanded: _isHelpExpanded,
              onTap: () {
                setState(() {
                  _isHelpExpanded = !_isHelpExpanded;
                });
              },
            ),

            // Help & Info sub-items
            if (_isHelpExpanded) ...[
              Container(
                margin: const EdgeInsets.only(left: 20),
                child: Column(
                  children: [
                    ListTileForNav(
                      liconPath: "assets/icons/home.png",
                      title: "About Us",
                      onTap: () {
                       Get.to(()=> AboutUs());
                      },
                    ),
                    ListTileForNav(
                      liconPath: "assets/icons/list.png",
                      title: "Privacy Policy",
                      onTap: () {
                        Get.to(()=> PrivacyPolicy());
                      },
                    ),
                    ListTileForNav(
                      liconPath: "assets/icons/book-open-01.png",
                      title: "Terms & Conditions",
                      onTap: () {
                        Get.to(()=> TermsandConditions());
                      },
                    ),
                    ListTileForNav(
                      liconPath: "assets/icons/Icon (5).png",
                      title: "Frequently Asked Questions",
                      onTap: () {
                        Get.to(()=> FrequentlyQuestions());
                      },
                    ),

                    ListTileForNav(
                      liconPath: "assets/icons/contactus.png",
                      title: "Contact Us",
                      onTap: () {
                        Get.to(()=> ContactUsScreen(member: EditProfileModel()));
                      },
                    ),
                    
                  ],
                ),
              ),
            ],

            // More with expandable functionality
            ListTileForNav(
              title: "More",
              ticonPath: "assets/icons/Icon_down_homeDawer.png",
              isExpanded: _isMoreExpanded,
              onTap: () {
                setState(() {
                  _isMoreExpanded = !_isMoreExpanded;
                });
              },
            ),

            // More sub-items (add as needed)
            if (_isMoreExpanded) ...[
              Container(
                margin: const EdgeInsets.only(left: 20),
                child: Column(
                  children: [
                    ListTileForNav(
                      liconPath: "assets/icons/home.png",
                      title: "My Profile",
                      onTap: () {
                        Get.to(()=> PersonalInfoScreen());
                      },
                    ),
                    ListTileForNav(
                      liconPath: "assets/icons/list.png",
                      title: "My Plan",
                      onTap: () {
                        Get.back();
                        Get.to(() => const MyPlanScreen());
                      },
                    ),
                    ListTileForNav(
                      title: "Bookmarked Jobs",
                      liconPath: "assets/icons/book-open-01.png",
                      onTap: () {
                        // Close the drawer then navigate to Bookmark Jobs screen
                        Get.back();
                        Get.to(() => BookmarkJobsScreen());
                      },
                    ),
                  ],
                ),
              ),
            ],

            ListTileForNav(
              title: "Logout",
              liconPath: "assets/icons/logout_icon_dawer.png",
              onTap: () {
                Get.find<AuthController>().logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ListTileForNav extends StatelessWidget {
  final String? title;
  final String? liconPath;
  final String? ticonPath;
  final VoidCallback onTap;
  final bool isExpanded;

  const ListTileForNav({
    super.key,
    required this.title,
    required this.onTap,
    this.liconPath,
    this.ticonPath,
    this.isExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: ticonPath != null
          ? Transform.rotate(
              angle: isExpanded
                  ? 3.14159
                  : 0, // Rotate 180 degrees when expanded
              child: Image.asset(
                ticonPath!,
                fit: BoxFit.cover,
                width: 15,
                height: 9,
              ),
            )
          : null,
      leading: liconPath != null
          ? Image.asset(liconPath!, width: 16, height: 16)
          : null,
      title: Text(
        title ?? '',
        style: TextStyle(
          color: Color(0xff333333),
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: -1,
        ),
      ),
      onTap: () => onTap(),
    );
  }
}
