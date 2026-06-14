import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giveandtake/features/company/presentation/screen/company_edit_profile.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../../../core/common/widgets/app_scaffold.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/utils/debug_print.dart';
import '../../../Home/presentation/widgets/app_drawer.dart';
import '../../../company_pricing/presentation/screens/plan_pricing_screen(company).dart';
import '../../../notifications/presentation/controller/notifications_controller.dart';
import '../../../notifications/presentation/widgets/notification_bell.dart';
import '../../../recruiter_account/presentation/controller/recruiter_controller.dart';
import '../../../recruiter_account/presentation/screens/create_job_screen.dart';
import '../../../recruiter_account/presentation/screens/video_upload_screen.dart';
import '../../../recruiter_account/presentation/widgets/elevator_pitch.dart';
import '../../../recruiter_account/presentation/widgets/social_media.dart';
import '../../data/model/single_Company_response_model.dart';
import '../controller/company_details_controller.dart';
import '../widget/elevator-pitch_company_widget.dart';
import 'company_change_password_screen.dart';
import 'connect_company_dialog_screen.dart';
import 'employee_screen.dart';
import 'manage_job_req_screen.dart';
import 'recruiter_request_screen.dart';

class CompanyDetailsPage extends StatefulWidget {
  CompanyDetailsPage({super.key});

  @override
  State<CompanyDetailsPage> createState() => _CompanyDetailsPageState();
}

class _CompanyDetailsPageState extends State<CompanyDetailsPage> {
  final CompanyDetailsController controller = Get.find();
  final RecruiterController recruiterController =
      Get.find<RecruiterController>();

  @override
  void initState() {
    super.initState();
    // Eagerly resolve the notifications controller so its onInit runs after
    // login (loads notifications + joins the user's socket room for live
    // 'newNotification' / 'notificationCountUpdated' events).
    if (!Get.isRegistered<NotificationsController>()) {
      Get.put(NotificationsController(Get.find(), Get.find(), Get.find()));
    } else {
      Get.find<NotificationsController>();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.fetchCompanyProfile();
      await controller.fetchEmployee();
    });
  }

  Future<void> _onRefresh() async {
    await controller.fetchCompanyProfile();
    await controller.fetchEmployee();
  }

  void _confirmRemoveRecruiter(String employeeId, String name) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text("Remove Recruiter"),
        content: Text(
          name.isNotEmpty
              ? "Are you sure you want to remove $name from your internal recruiters?"
              : "Are you sure you want to remove this recruiter?",
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.removeRecruiter(employeeId);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  String? _accessToken;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Company Account",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF2B7FD0),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          NotificationBell(iconColor: Colors.white),
          const SizedBox(width: 4),
        ],
      ),
      drawer: const AppDrawer(),
/*      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero, // Very important!
          children: [
            // SMALL & BEAUTIFUL CUSTOM HEADER
            Container(
              height:
                  120, // Change this value to make it smaller or bigger (80–120 looks great)
              color: const Color(0xFF2B7FD0),
              padding: const EdgeInsets.fromLTRB(
                16,
                24,
                16,
                16,
              ), // top padding for status bar feel
              child: Align(
                alignment:
                    Alignment.bottomLeft, // puts text at bottom (looks modern)
                child: Text(
                  controller.userInfo.value?.companies.first.cname ??
                      "Company Flow",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),

            // Your menu items
            ListTile(
              leading: const Icon(Icons.work_outline),
              title: const Text('Manage Jobs'),
              onTap: () {
                Get.back();
                Get.to(() => ManageJobPostScreen());
              },
            ),
            ListTile(
              leading: const Icon(Icons.post_add_outlined),
              title: const Text('Post a Job'),
              onTap: () {
                Get.back();
                Get.to(() => CreateJobScreen());
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),

              title: const Text('Edit Profile'),

              onTap: () {
                Get.back();

                Get.to(
                  () => CompanyEditAccountPage(
                    companyData: controller.userInfo.value!,
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Add Company Recruiters'),
              onTap: () {
                Navigator.pop(context);
                final company = controller.userInfo.value!.companies.first;
                Future.delayed(const Duration(milliseconds: 150), () {
                  Get.dialog(
                    RecruiterDialogContent(),
                    barrierDismissible: false, // prevents accidental close
                  );
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_2_outlined),
              title: const Text('Internal Recruiters'),
              onTap: () {
                Get.back();
                Get.to(() => CompanyEmployeesScreen()); // or your profile page
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit_calendar_sharp),
              title: const Text('My Plan'),
              onTap: () {
                Get.back();
                Get.to(() => PlanPricingScreen()); // or your profile page
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_add_outlined),
              title: const Text('Recruiter Requests'),
              onTap: () {
                Get.back();
                Get.to(() => RecruiterRequestsScreen()); // or your profile page
              },
            ),
            ListTile(
              leading: const Icon(Icons.lock_clock_outlined),
              title: const Text('Change Password'),
              onTap: () {
                Get.back();
                Get.to(
                  () => CompanyChangePasswordScreen(),
                ); // or your profile page
              },
            ),

            const Divider(
              height: 1,
              thickness: 1,
              indent: 16,
              endIndent: 16,
              color: Color(0xFFE0E0E0),
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'Log out',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),

              onTap: () {
                recruiterController.logout();
              },
            ),
          ],
        ),
      ),*/

      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.userInfo.value?.companies == null ||
            controller.userInfo.value!.companies.isEmpty) {
          return Center(child: Text("No company data"));
        }

        final company = controller.userInfo.value!.companies.first;

        return RefreshIndicator(
          onRefresh: _onRefresh,
          color: Colors.blue,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                /// ================= HEADER =================
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      /// ───────── Avatar (with gradient ring + fallback) ─────────
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Color(0xFF2B7FD0), Color(0xFF4DA3F0)],
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 32,
                          backgroundColor: Colors.grey.shade100,
                          backgroundImage: company.clogo.isNotEmpty
                              ? NetworkImage(company.clogo)
                              : null,
                          child: company.clogo.isEmpty
                              ? Text(
                                  company.cname.isNotEmpty
                                      ? company.cname[0].toUpperCase()
                                      : "C",
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2B7FD0),
                                  ),
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(width: 14),

                      /// ───────── Name + Industry + Chips ─────────
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              company.cname,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A1A1A),
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            if (company.industry.trim().isNotEmpty) ...[
                              const SizedBox(height: 3),
                              Text(
                                company.industry,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 6,
                              children: [
                                _headerChip(
                                  Icons.location_on_outlined,
                                  "${company.city}, ${company.country}",
                                ),
                                _headerChip(
                                  Icons.people_outline,
                                  "${company.employeesId.length} recruiter${company.employeesId.length == 1 ? '' : 's'}",
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                /// ================= PROMO CARD =================
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF2B7FD0), Color(0xFF1B6FC0)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2B7FD0).withOpacity(0.30),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.rocket_launch,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              "Post Your First Job at No Cost!",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Easily post job openings & reach the right talent fast.",
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFFE8F1FB),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => Get.to(() => CreateJobScreen()),
                          icon: const Icon(
                            Icons.add,
                            size: 18,
                            color: Color(0xFF2B7FD0),
                          ),
                          label: const Text(
                            "Post a Job",
                            style: TextStyle(
                              color: Color(0xFF2B7FD0),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                /// ================= SOCIAL LINKS =================
                Text(
                  "Connect with us",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 12),
                buildSocialLinks(company),
                const SizedBox(height: 20),

                /// ================= Elevator Pitch =================
                ElevatorPitchSection(
                  isOwnProfile: true, // Enable managing the pitch
                  onDelete: () async {
                    await Future.delayed(const Duration(milliseconds: 500));
                    await controller.fetchCompanyProfile();
                  },
                  onUpload: () async {
                    await Future.delayed(const Duration(milliseconds: 1000));
                    await controller.fetchCompanyProfile();
                  },
                  videoUrl: company.elevatorPitch?.id != null
                      ? "${ApiConstants.baseUrl}/elevator-pitch/stream/${company.elevatorPitch!.id}"
                      : null,
                  httpHeaders: {
                    "Custom-Header": "value",
                    if (_accessToken != null) ...{
                      "Authorization": "Bearer $_accessToken",
                    },
                  },
                ),

                const SizedBox(height: 22),

                /// ================= ABOUT US =================
                sectionTitle("About us"),
                const SizedBox(height: 6),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    stripHtmlTags(company.aboutUs),
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                /// ================= Employees =================
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Internal Recruiters",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      InkWell(
                        onTap: () => Get.to(() => const CompanyEmployeesScreen()),
                        borderRadius: BorderRadius.circular(8),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "See more",
                                style: TextStyle(
                                  color: Color(0xFF2B7FD0),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(width: 3),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 13,
                                color: Color(0xFF2B7FD0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Full-width Beautiful Table Card
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return const Padding(
                          padding: EdgeInsets.all(40),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final emp = controller.employee.value;

                      if (emp == null || emp.employees.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(40),
                          child: Center(
                            child: Text(
                              "No internal recruiters yet",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      }

                      return SingleChildScrollView(
                        // scrollDirection: Axis .horizontal, // Only scroll horizontally if content overflows
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth:
                                MediaQuery.of(context).size.width -
                                32, // Full width minus margins
                          ),
                          child: DataTable(
                            headingRowHeight: 56,
                            headingRowColor: MaterialStateProperty.all(
                              const Color(0xFFF8F9FB),
                            ),
                            dataRowHeight: 68,
                            columnSpacing: 16,
                            dividerThickness: 0,
                            columns: const [
                              DataColumn(
                                label: Padding(
                                  padding: EdgeInsets.only(left: 12),
                                  child: Text(
                                    "Recruiter Name",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ),

                              DataColumn(
                                label: Center(
                                  child: Text(
                                    "Role",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  "Action",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                            rows: emp.employees.map((e) {
                              return DataRow(
                                cells: [
                                  DataCell(
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                        horizontal: 12,
                                      ),
                                      child: Row(
                                        children: [
                                          // CircleAvatar(
                                          //   radius: 18,
                                          //   backgroundColor: Colors.grey.shade200,
                                          //   backgroundImage:
                                          //       e.avatarUrl.isNotEmpty
                                          //       ? NetworkImage(e.avatarUrl)
                                          //       : null,
                                          //   child: e.avatarUrl.isEmpty
                                          //       ? Text(
                                          //           e.name.isNotEmpty
                                          //               ? e.name[0].toUpperCase()
                                          //               : "R",
                                          //           style: const TextStyle(
                                          //             fontWeight: FontWeight.bold,
                                          //             color: Colors.black54,
                                          //           ),
                                          //         )
                                          //       : null,
                                          // ),
                                          Expanded(
                                            child: Text(
                                              e.name,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(
                                          0xFFE3F2FD,
                                        ), // Exact light-blue background
                                        borderRadius: BorderRadius.circular(
                                          20,
                                        ), // Pill shape
                                        border: Border.all(
                                          color: const Color(
                                            0xFFBBDEFB,
                                          ), // Slightly darker blue border
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Text(
                                        e.role,
                                        style: const TextStyle(
                                          color: Color(
                                            0xFF1976D2,
                                          ), // Deep blue text (matches your design)
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Padding(
                                      padding: const EdgeInsets.only(right: 12),
                                      child: GestureDetector(
                                        onTap: () =>
                                            _confirmRemoveRecruiter(e.id, e.name),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.red.shade50,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.delete_outline,
                                                color: Colors.red,
                                                size: 20,
                                              ),
                                              SizedBox(width: 6),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 20),
                // Align(
                //   alignment: Alignment.centerRight,
                //   child: TextButton(onPressed: () {}, child: Text("See all")),
                // ),

                // -------------------- 🏅 Honors & Achievements --------------------
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Text(
                    "Awards and Honors",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),

                controller.userInfo.value?.honors != null &&
                        controller.userInfo.value!.honors.isNotEmpty
                    ? Column(
                        children: controller.userInfo.value!.honors.map((
                          honor,
                        ) {
                          return Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade300),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 3,
                                  spreadRadius: 1,
                                  color: Colors.black.withOpacity(.05),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 🏆 Honor Title
                                Row(
                                  children: [
                                    // Icon(
                                    //   Icons.workspace_premium,
                                    //   size: 20,
                                    //   color: Colors.amber,
                                    // ),
                                    // SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        honor.title,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 6),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        honor.programeName,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 6),

                                // 🔸 Issued By + Date
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_month_outlined,
                                      size: 14,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      _formatDate(
                                        honor.programeDate.toIso8601String(),
                                      ),
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 6),
                                SizedBox(width: 6),

                                // 📝 Description
                                Text(
                                  honor.description,
                                  style: TextStyle(
                                    color: Colors.black87,
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        child: Text(
                          "No honors awarded yet.",
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),

                SizedBox(height: 20),
              ],
            ),
          ),
        );
      }),
    );
  }
  // ================= SOCIAL MEDIA LINKS =================

  Widget buildSocialLinks(Company company) {
    final validSocialLinks = company.sLink
        .where((link) => link.url.trim().isNotEmpty)
        .toList();

    if (validSocialLinks.isEmpty) {
      return const Text(
        "No social links available",
        style: TextStyle(color: Colors.black54, fontSize: 12),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: validSocialLinks.map((link) {
        return GestureDetector(
          onTap: () async {
            final Uri url = Uri.parse(link.url);

            if (await canLaunchUrl(url)) {
              await launchUrl(url, mode: LaunchMode.externalApplication);
            } else {
              Get.snackbar(
                "Error",
                "Could not open ${link.label}",
                snackPosition: SnackPosition.BOTTOM,
              );
            }
          },
          child: SocialMedia(image: _getSocialIcon(link.label)),
        );
      }).toList(),
    );
  }

  Widget _headerChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F6FC),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: const Color(0xFF2B7FD0)),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11.5,
              color: Color(0xFF445566),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget sectionTitle(String title, {bool canDelete = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          if (canDelete) Icon(Icons.delete_outline, color: Colors.red),
        ],
      ),
    );
  }

  Widget infoTile(String title, String value) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      subtitle: Text(value),
    );
  }
}

String _formatDate(String isoDateString) {
  try {
    // Example input: "2025-09-01T00:00:00.000Z"
    final DateTime date = DateTime.parse(isoDateString);
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  } catch (e) {
    return "Invalid Date";
  }
}

String stripHtmlTags(String? htmlString) {
  if (htmlString == null || htmlString.isEmpty) {
    return "No description available.";
  }

  // Remove all HTML tags
  String noTags = htmlString.replaceAll(RegExp(r'<[^>]*>'), ' ');

  // Replace multiple spaces/newlines with single space
  String cleanText = noTags.replaceAll(RegExp(r'\s+'), ' ').trim();

  return cleanText.isEmpty ? "No description available." : cleanText;
}

String _getSocialIcon(String? label) {
  switch (label?.toLowerCase()) {
    case 'linkedin':
      return 'assets/icons/linkedin.png';
    case 'twitter':
      return 'assets/icons/twitter.png';
    case 'upwork':
      return 'assets/icons/upwork_logo_icon_168329.png';
    case 'facebook':
      return 'assets/icons/facebook.png';
    case 'tiktok':
      return 'assets/icons/tiktok.png';
    case 'instagram':
      return 'assets/icons/instagram.png';

    case 'fiverr':
      return 'assets/icons/fiverrIcon.png';
    case 'website':
      return 'assets/icons/webIcon.png';
    default:
      return 'assets/icons/link.png';
  }
}
