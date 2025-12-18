import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/common/widgets/app_scaffold.dart';
import 'package:karlfive/features/company/presentation/screen/company_edit_profile.dart';
import 'package:karlfive/features/company/presentation/screen/connect_company_dialog_screen.dart';
import 'package:karlfive/features/company_pricing/presentation/screens/plan_pricing_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../recruiter_account/presentation/controller/recruiter_controller.dart';
import '../../../recruiter_account/presentation/screens/create_job_screen.dart';
import '../../../recruiter_account/presentation/screens/video_upload_screen.dart';
import '../../../recruiter_account/presentation/widgets/social_media.dart';
import '../controller/company_details_controller.dart';
import '../widget/elevator-pitch_company_widget.dart';
import 'company_change_password_screen.dart';
import 'employee_screen.dart';
import 'manage_job_req_screen.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.fetchCompanyProfile();
      await controller.fetchEmployee();
    });
  }

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
      ),
      drawer: Drawer(
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
              title: const Text('Connect with Recruiter'),
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
              leading: const Icon(Icons.person),
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
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.userInfo.value?.companies == null ||
            controller.userInfo.value!.companies.isEmpty) {
          return Center(child: Text("No company data"));
        }

        final company = controller.userInfo.value!.companies.first;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 46),

              /// ================= HEADER =================
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// ───────── Avatar ─────────
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(company.clogo),
                    ),

                    /// ───────── Company Name + Location ─────────
                    /// ================= HEADER =================
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Company name
                          Text(
                            company.cname,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),

                          const SizedBox(height: 4),

                          // Industry
                          Text(
                            company.industry ?? "No industry info",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),

                          const SizedBox(height: 6),

                          // Location + Recruiters row
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 14,
                                color: Colors.black54,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "${company.city}, ${company.country}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              const SizedBox(width: 12),
                              Icon(
                                Icons.people,
                                size: 14,
                                color: Colors.black54,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "${company.employeesId.length} recruiter${company.employeesId.length > 1 ? "s" : ""}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 10),
                  ],
                ),
              ),

              /// ================= PROMO SECTION =================
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 18),

                    /// 🔹 Promo text
                    Text(
                      "Post Your First Job at No Cost!",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),

                    Text(
                      "Easily post job openings & reach the right talent fast.",
                      style: TextStyle(fontSize: 12, color: Color(0xFF727272)),
                    ),

                    const SizedBox(height: 20),

                    // ----- Social Media -----
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: (company.sLink)
                          .map(
                            (link) => GestureDetector(
                              onTap: () async {
                                final Uri url = Uri.parse(link.url ?? '');
                                if (await canLaunchUrl(url)) {
                                  await launchUrl(
                                    url,
                                    mode: LaunchMode.externalApplication,
                                  );
                                } else {
                                  Get.snackbar(
                                    'Error',
                                    'Could not open ${link.url}',
                                  );
                                }
                              },
                              child: SocialMedia(
                                image: _getSocialIcon(link.label),
                              ),
                            ),
                          )
                          .toList(),
                    ),

                    const SizedBox(height: 20),

                    /// 🔹 Buttons in one row
                    Row(
                      children: [
                        // ElevatedButton(
                        //   onPressed: () => Get.to(() => ManageJobPostScreen()),
                        //   style: ElevatedButton.styleFrom(
                        //     backgroundColor: Color(0xFF2B7FD0),
                        //     foregroundColor: Colors.white,
                        //     padding: EdgeInsets.symmetric(horizontal: 14),
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(10),
                        //     ),
                        //   ),
                        //   child: Text("Manage Jobs"),
                        // ),

                        // const SizedBox(width: 10),

                        // ElevatedButton(
                        //   onPressed: () {},
                        //   style: ElevatedButton.styleFrom(
                        //     backgroundColor: Color(0xFF2B7FD0),
                        //     foregroundColor: Colors.white,
                        //     padding: EdgeInsets.symmetric(horizontal: 14),
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(10),
                        //     ),
                        //   ),
                        //   child: Text(
                        //     "Post A Job",
                        //   ), // ⬅ added beside Manage Job
                        // ),

                        // const SizedBox(width: 10),
                        // ElevatedButton(
                        //   onPressed: () {
                        //     Get.to(
                        //       () => CompanyEditAccountPage(
                        //         companyData: controller.userInfo.value!,
                        //       ),
                        //     );
                        //   },
                        //   style: ElevatedButton.styleFrom(
                        //     backgroundColor: Color(0xFF2B7FD0),
                        //     foregroundColor: Colors.white,
                        //     padding: EdgeInsets.symmetric(horizontal: 14),
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(10),
                        //     ),
                        //   ),
                        //   child: Text("Edit Profile"),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),

              /// ================= Elevator Pitch =================
              // sectionTitle("Elevator Pitch", canDelete: true),

              // SizedBox(height: 20),
              // Container(
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     border: Border.all(color: const Color(0xFF999999), width: 1),
              //     borderRadius: BorderRadius.circular(12),
              //   ),

              //   //fetch elevated pitch e
              //   child: Container(
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(4),
              //       color: const Color(0xFF191919),
              //     ),
              //     height: 160,
              //     width: double.infinity,
              //     child: ElevatorPitchCompanySection(
              //       videoUrl: company.elevatorPitch?.video.hlsUrl,
              //       httpHeaders: {
              //         'Accept': '*/*',
              //         'Accept-Encoding': 'identity',

              //         "Authorization":
              //             "Bearer ${company.elevatorPitch?.video.encryptionKeyUrl}",
              //         "Custom-Header": "value",
              //       },
              //     ),
              //   ),
              // ),
              /// ================= Elevator Pitch =================
              sectionTitle("Elevator Video Pitch"),
              const SizedBox(height: 20),

              // Check if elevator pitch exists
              company.elevatorPitch?.video.hlsUrl != null &&
                      company.elevatorPitch!.video.hlsUrl.isNotEmpty
                  ? Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: const Color(0xFF999999),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: const Color(0xFF191919),
                        ),
                        height: 160,
                        width: double.infinity,
                        child: ElevatorPitchCompanySection(
                          videoUrl: company.elevatorPitch!.video.hlsUrl,
                          httpHeaders: {
                            'Accept': '*/*',
                            'Accept-Encoding': 'identity',
                            "Authorization":
                                "Bearer ${company.elevatorPitch!.video.encryptionKeyUrl}",
                          },
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        // Navigate to video upload screen (same as create flow)
                        Get.to(() => VideoUploadScreen());
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFF999999),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        height: 160,
                        width: double.infinity,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: const Color(0xFF191919),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/icons/gallery.png', // same icon used in create screen
                                height: 32,
                                width: 32,
                                color: Colors.white70,
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Upload your company elevator pitch',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                ' Upload or view a short video',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

              const SizedBox(height: 20),
              SizedBox(height: 20),

              /// ================= COMPANY DETAILS =================
              infoTile("About us", stripHtmlTags(company.aboutUs)),
              SizedBox(height: 20),
              // infoTile("Industry", company.industry),
              // infoTile("Zip Code", company.zipcode),
              // infoTile("Business Email", company.cemail),
              // infoTile("Services", company.service.join(", ")),
              // infoTile(
              //   "Social Links",
              //   company.sLink.isNotEmpty
              //       ? company.sLink
              //             .map((e) => "• ${e.label} → ${e.url}")
              //             .join("\n")
              //       : "No social links available",
              // ),

              /// ================= Employees =================
              sectionTitle("Internal Recruiters"),
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
                            style: TextStyle(color: Colors.grey, fontSize: 16),
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
                                          controller.removeRecruiter(e.id),
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
                      children: controller.userInfo.value!.honors.map((honor) {
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
                                    _formatDate(honor.programeDate),
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
        );
      }),
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
