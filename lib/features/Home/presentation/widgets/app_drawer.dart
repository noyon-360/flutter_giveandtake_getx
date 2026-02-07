import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/theme/app_colors.dart';
import 'package:karlfive/features/auth/presentation/controller/auth_controller.dart';
import 'package:karlfive/features/company/presentation/screen/public_view_seach_screen.dart';
import 'package:karlfive/features/elevator/presentation/screens/elevator_resume_screen.dart';
import 'package:karlfive/features/home_static_screens/data/models/contactus_model.dart';
import 'package:karlfive/features/home_static_screens/presentation/screen/contact_us_screen.dart';
import 'package:karlfive/features/job_listing/presentation/screens/bookmark_jobs_screen.dart';

import '../../../company/data/model/seach_all_user_response_model.dart';
import '../../../company/presentation/controller/company_details_controller.dart';
import '../../../company/presentation/controller/search_controller.dart';
import '../../../company/presentation/screen/public_view_show_result.dart';
import '../../../company/presentation/widget/custom_search_company.dart';
import '../../../home_static_screens/presentation/screen/Terms_screen.dart';
import '../../../home_static_screens/presentation/screen/aboutus_screen.dart';
import '../../../home_static_screens/presentation/screen/blog.dart';
import '../../../home_static_screens/presentation/screen/frequently_questions.dart';
import '../../../home_static_screens/presentation/screen/privacy_policy.dart';
import '../../../job_listing/presentation/screens/all_jobs_screen.dart';
import '../../../profile_dasboard/presentation/screens/change_pass_screen.dart';
import '../../../profile_dasboard/presentation/screens/job_history.dart';
import '../../../profile_dasboard/presentation/screens/payment_history.dart';
import '../screen/candidate_dashboard_screen.dart';
import '../screens/my_plan_screen.dart';
import 'custom_searchbox.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool _isHelpExpanded = false;
  bool _isMoreExpanded = false;

  final _searchController = TextEditingController();

  late final CompanyDetailsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<CompanyDetailsController>();

    // Load users if not already loaded
    if (controller.searchInfo.isEmpty &&
        !controller.isLoading.value &&
        controller.searchQuery.value != null) {
      controller.fetchSearchUser("");
    }

    // Optional: clear previous search when drawer opens
    _searchController.clear();
    controller.clearSearch();

    // Sync text field with reactive searchQuery
    _searchController.addListener(() {
      controller.searchQuery.value = _searchController.text;
    });
  }

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

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 48,
                    child: CustomSearchCompany(
                      hintText: "Search people...",
                      controller: _searchController,
                      onChanged: (value) {
                        controller.searchQuery.value = value;
                        controller.searchUsers(value);
                      },
                      // onChanged is optional now — we use listener
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Reactive search results
                  Obx(() {
                    // final users = controller.searchInfo;
                    final users = controller.filteredSearchInfo;

                    if (controller.searchQuery.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    if (users.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: Text(
                            "No matching users found",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      );
                    }
                    if (users.isEmpty) {
                      return const SizedBox.shrink(); // or show "Start typing..." message
                    }

                    return Container(
                      constraints: const BoxConstraints(maxHeight: 340),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Scrollable list
                          Flexible(
                            child: ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemCount: users.length,
                              itemBuilder: (context, index) {
                                final user = users[index];
                                return ListTile(
                                  dense: true,
                                  leading: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.grey[300],
                                    backgroundImage: user.avatar?.url != null
                                        ? NetworkImage(user.avatar!.url!)
                                        : null,
                                    child: user.avatar?.url == null
                                        ? Text(
                                            (user.name?[0] ?? '?')
                                                .toUpperCase(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          )
                                        : null,
                                  ),
                                  title: Text(
                                    user.name ?? 'Unknown',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Text(user.address ?? ''),
                                  trailing: const Icon(Icons.person_outline),
                                  onTap: () {
                                    final slug = user.slug;

                                    if (slug == null || slug.isEmpty) {
                                      Get.snackbar(
                                        'Error',
                                        'This user has no public profile',
                                      );
                                      return;
                                    }

                                    Get.to(
                                      () => PublicViewSeachScreen(slug: slug),
                                    );
                                  },
                                );
                              },
                            ),
                          ),

                          const Divider(height: 1),

                          TextButton(
                            onPressed: () {
                              Get.to(() => PublicViewShowResultScreen());
                            },
                            child: const Text("Show All Results"),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),

            ListTileForNav(
              title: "Elevator Pitch & Resume",
              onTap: () {
                Get.to(() => ElevatorResumeScreen());
              },
            ),
            ListTileForNav(
              title: "Jobs",
              liconPath:
                  "assets/icons/list.png", // Reusing list icon or suitable one
              onTap: () {
                Get.to(() => const AllJobsScreen());
              },
            ),
            ListTileForNav(
              title: "Blogs",
              onTap: () {
                Get.to(() => BlogScreen());
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
                        Get.to(() => AboutUs());
                      },
                    ),
                    ListTileForNav(
                      liconPath: "assets/icons/list.png",
                      title: "Privacy Policy",
                      onTap: () {
                        Get.to(() => PrivacyPolicy());
                      },
                    ),
                    ListTileForNav(
                      liconPath: "assets/icons/book-open-01.png",
                      title: "Terms & Conditions",
                      onTap: () {
                        Get.to(() => TermsandConditions());
                      },
                    ),
                    ListTileForNav(
                      liconPath: "assets/icons/Icon (5).png",
                      title: "Frequently Asked Questions",
                      onTap: () {
                        Get.to(() => FrequentlyQuestions());
                      },
                    ),

                    ListTileForNav(
                      liconPath: "assets/icons/contactus.png",
                      title: "Contact Us",
                      onTap: () {
                        Get.to(
                          () => ContactUsScreen(member: EditProfileModel()),
                        );
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
                      title: "My EVP Profile",
                      onTap: () {
                        Get.back(); // Close drawer first
                        Get.to(() => const CandidateDashboardScreen());
                      },
                    ),
                    ListTileForNav(
                      liconPath: "assets/icons/list.png",
                      title: "Job History",
                      onTap: () {
                        Get.back(); // Close drawer first
                        Get.to(() => const JobHistoryScreen());
                      },
                    ),
                    ListTileForNav(
                      liconPath: "assets/icons/book-open-01.png",
                      title: "Payment History",
                      onTap: () {
                        Get.back(); // Close drawer first
                        Get.to(() => const PaymentHistoryScreen());
                      },
                    ),
                    ListTileForNav(
                      liconPath: "assets/icons/list.png",
                      title: "All Plans",
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
                    ListTileForNav(
                      liconPath: "assets/icons/changepass.png",
                      title: "Change Password",
                      onTap: () {
                        Get.back(); // Close drawer first
                        Get.to(() => ChangePasswordScreen());
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
