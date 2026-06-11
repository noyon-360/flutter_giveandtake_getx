import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:giveandtake/features/Home/presentation/screens/my_plan_screen.dart';

import 'package:giveandtake/features/recruiter_account/presentation/screens/all_jobs_screen.dart';
import 'package:giveandtake/features/recruiter_account/presentation/screens/change_password_screen.dart';
import 'package:giveandtake/features/recruiter_account/presentation/screens/company_info_screen.dart';
import 'package:giveandtake/features/recruiter_account/presentation/screens/create_job_screen.dart';
import '../../../company_pricing/presentation/screens/plan_pricing_screen(company).dart';
import '../controller/recruiter_controller.dart';
import '../screens/edit_profile_page.dart';
import '../screens/public_view_screen.dart';
import '../screens/connect_with_company_page.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final RecruiterController recruiterController =
      Get.find<RecruiterController>();
  final ScrollController horizontalScrollController = ScrollController();

  late final user = recruiterController.userInfo.value!;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.65, // <-- 70% width drawer
      child: Drawer(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // -------------------- DRAWER HEADER --------------------
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: SizedBox(
                  height: 70,
                  child: DrawerHeader(
                    decoration: const BoxDecoration(color: Color(0xFF2B7FD0)),
                    child: Text(
                      "Recruiter Flow",
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              drawerTile(
                icon: Icons.edit,
                title: "Edit Profile",
                onTap: () {
                  Navigator.pop(context);
                  Future.delayed(const Duration(milliseconds: 150), () {
                    Get.to(() => EditProfilePage(recruiterResponseModel: user));
                  });
                },
              ),

              drawerTile(
                icon: Icons.business_center_outlined,
                title: "Post a Job",
                onTap: () {
                  Navigator.pop(context);
                  Future.delayed(const Duration(milliseconds: 150), () {
                    Get.to(() => CreateJobScreen());
                  });
                },
              ),

              drawerTile(
                icon: Icons.business_center,
                title: "All Jobs",
                onTap: () {
                  Navigator.pop(context);
                  Future.delayed(const Duration(milliseconds: 150), () {
                    Get.to(() => AllJobsScreen());
                  });
                },
              ),

              drawerTile(
                icon: Icons.public,
                title: "Public View",
                onTap: () {
                  Navigator.pop(context);
                  Future.delayed(const Duration(milliseconds: 150), () {
                    Get.to(() => PublicViewScreen());
                  });
                },
              ),

              Obx(() {
                final isConnected =
                    recruiterController.userInfo.value?.companyId != null;
                return drawerTile(
                  icon: Icons.post_add,
                  title: "Connect with Company",
                  color: isConnected ? Colors.grey : Colors.black,
                  onTap: () {
                    if (isConnected) {
                      Get.snackbar(
                        "Information",
                        "You are already connected with a company",
                        backgroundColor: Colors.redAccent,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    } else {
                      Navigator.pop(context);
                      Future.delayed(const Duration(milliseconds: 150), () {
                        Get.to(() => ConnectCompanyPage());
                      });
                    }
                  },
                );
              }),

              drawerTile(
                icon: Icons.info_outline,
                title: "Company Information",
                onTap: () {
                  Navigator.pop(context);
                  Future.delayed(const Duration(milliseconds: 150), () {
                    Get.to(CompanyInformation());
                  });
                },
              ),

              drawerTile(
                icon: Icons.next_plan_outlined,
                title: "My Plan",
                onTap: () {
                  Navigator.pop(context);
                  Future.delayed(const Duration(milliseconds: 150), () {
                    Get.dialog(PlanPricingScreen());
                  });
                },
              ),

              // drawerTile(
              //   icon: Icons.post_add,
              //   title: "My Plan",
              //   onTap: () {
              //     Navigator.pop(context);
              //     Future.delayed(const Duration(milliseconds: 150), () {
              //       Get.dialog(MyPlanScreen());
              //     });
              //   },
              // ),
              drawerTile(
                icon: Icons.lock_outline,
                title: "Change Password",
                onTap: () {
                  Navigator.pop(context);
                  Future.delayed(const Duration(milliseconds: 150), () {
                    Get.to(() => ChangePassword());
                  });
                },
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Divider(color: Colors.grey),
              ),

              drawerTile(
                icon: Icons.logout,
                title: "Logout",
                color: Colors.red,
                onTap: () {
                  Get.back();
                  recruiterController.logout();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------ TILE WIDGET ------------------
  Widget drawerTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = Colors.black,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(fontSize: 16, color: color)),
      onTap: onTap,
    );
  }
}
