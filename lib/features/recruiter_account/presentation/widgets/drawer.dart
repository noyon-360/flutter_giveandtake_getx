import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:karlfive/features/recruiter_account/presentation/screens/all_jobs_screen.dart';
import '../../../profile_dasboard/presentation/screens/change_pass_screen.dart';
import '../controller/recruiter_controller.dart';
import '../screens/edit_profile_page.dart';
import '../screens/post_job_screen.dart';
import '../screens/public_view_screen.dart';
import 'connect_with_company_dialog.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final RecruiterController recruiterController = Get.find<RecruiterController>();
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
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                    ),
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
                  Get.back();
                  Get.to(() => EditProfilePage(recruiterResponseModel: user));
                },
              ),

              drawerTile(
                icon: Icons.business_center_outlined,
                title: "Post a Job",
                onTap: () {
                  Get.back();
                  Get.to(() => CreateJobScreen());
                },
              ),

              drawerTile(
                icon: Icons.public,
                title: "Public View",
                onTap: () {
                  Get.back();
                  Get.to(() => PublicViewScreen());
                },
              ),

              drawerTile(
                icon: Icons.post_add,
                title: "Connect with Company",
                onTap: () {
                  Get.back();
                  Get.dialog(ConnectCompanyDialog());
                },
              ),

              drawerTile(
                icon: Icons.lock_outline,
                title: "Change Password",
                onTap: () {
                  Get.back();
                  Get.to(() => ChangePasswordScreen());
                },
              ),

              drawerTile(
                icon: Icons.lock_outline,
                title: "All Jobs",
                onTap: () {
                  Get.back();
                  Get.to(() => AllJobsScreen());
                },
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Divider(color: Colors.grey,),
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
