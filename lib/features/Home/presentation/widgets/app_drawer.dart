import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/theme/app_colors.dart';
import 'package:karlfive/features/job_listing/presentation/screens/bookmark_jobs_screen.dart';

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
              title: "Blog",
              onTap: () {
                // TODO: Navigate to Blog
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
                        // TODO: Navigate to About Us
                      },
                    ),
                    ListTileForNav(
                      liconPath: "assets/icons/list.png",
                      title: "Privacy Policy",
                      onTap: () {
                        // TODO: Navigate to Privacy Policy
                      },
                    ),
                    ListTileForNav(
                      liconPath: "assets/icons/book-open-01.png",
                      title: "Terms & Conditions",
                      onTap: () {
                        // TODO: Navigate to Terms & Conditions
                      },
                    ),
                    ListTileForNav(
                      liconPath: "assets/icons/Icon (5).png",
                      title: "Frequently Asked Questions",
                      onTap: () {
                        // TODO: Navigate to FAQ
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
                        // TODO: Navigate to Contact Us
                      },
                    ),
                    ListTileForNav(
                      liconPath: "assets/icons/list.png",
                      title: "My Plan",
                      onTap: () {
                        // TODO: Navigate to Contact Us
                      },
                    ),
                    ListTileForNav(
                      title: "Bookmark Jobs",
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
                // TODO: Handle Logout
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
          ? Image.asset(liconPath!, width: 24, height: 24)
          : null,
      title: Text(title ?? '', style: TextStyle(color: AppColors.textBlack)),
      onTap: () => onTap(),
    );
  }
}
