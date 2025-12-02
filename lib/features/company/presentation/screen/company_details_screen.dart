import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/common/widgets/app_scaffold.dart';
import 'package:karlfive/features/company/presentation/screen/company_edit_profile.dart';
import 'package:karlfive/features/recruiter_account/presentation/screens/post_job_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../recruiter_account/presentation/widgets/elevator_pitch.dart';
import '../../../recruiter_account/presentation/widgets/social_media.dart';
import '../controller/company_details_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widget/elevator-pitch_company_widget.dart';
import '../widget/falcon_button_widget.dart';
import 'manage_job_req_screen.dart';

class CompanyDetailsPage extends StatefulWidget {
  CompanyDetailsPage({super.key});

  @override
  State<CompanyDetailsPage> createState() => _CompanyDetailsPageState();
}

class _CompanyDetailsPageState extends State<CompanyDetailsPage> {
  final CompanyDetailsController controller = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.fetchCompanyProfile();
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
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Get.back();
                // Get.to(() => CompanyDetailsPage()); // or your profile page
              },
            ),
          ],
        ),
      ),

      body: Obx(() {
        if (controller.userInfo.value == null) {
          return Center(child: CircularProgressIndicator());
        }

        /// MAIN API DATA
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
                padding: const EdgeInsets.all(16),
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
                    /// 🔹 Social Links on top
                    // Align(
                    //   alignment: Alignment.centerRight,
                    //   child: Container(
                    //     padding: const EdgeInsets.symmetric(
                    //       horizontal: 6,
                    //       vertical: 6,
                    //     ),
                    //     decoration: BoxDecoration(
                    //       color: Colors.white,
                    //       borderRadius: BorderRadius.circular(8),
                    //       border: Border.all(color: Colors.grey.shade400),
                    //     ),
                    //     child: Wrap(
                    //       spacing: 6,
                    //       children: company.sLink.map((e) {
                    //         IconData icon = FontAwesomeIcons.link;
                    //         if (e.label.contains("LinkedIn"))
                    //           icon = FontAwesomeIcons.linkedin;
                    //         if (e.label.contains("Twitter"))
                    //           icon = FontAwesomeIcons.twitter;
                    //         if (e.label.contains("Facebook"))
                    //           icon = FontAwesomeIcons.facebook;
                    //         if (e.label.contains("Instagram"))
                    //           icon = FontAwesomeIcons.instagram;

                    //         return FaIcon(icon, size: 14, color: Colors.black);
                    //       }).toList(),
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(height: 18),

                    /// 🔹 Promo text
                    Text(
                      "Try It Free – Post Your First Job at No Cost!",
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
              sectionTitle("Elevator Pitch", canDelete: true),

              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFF999999), width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),

                //fetch elevated pitch e
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: const Color(0xFF191919),
                  ),
                  height: 160,
                  width: double.infinity,
                  child: ElevatorPitchCompanySection(
                    videoUrl: company.elevatorPitch?.video.hlsUrl,
                    httpHeaders: {
                      'Accept': '*/*',
                      'Accept-Encoding': 'identity',

                      "Authorization":
                          "Bearer ${company.elevatorPitch?.video.encryptionKeyUrl}",
                      "Custom-Header": "value",
                    },
                  ),
                ),
              ),
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
              sectionTitle("Employees"),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 16,
                  headingRowColor: MaterialStateProperty.all(Color(0xFFF8F8F8)),
                  columns: [
                    DataColumn(label: Text("Employee ID")),
                    DataColumn(label: Text("Action")),
                  ],
                  rows: company.employeesId
                      .map(
                        (id) => DataRow(
                          cells: [
                            DataCell(Text(id)),
                            DataCell(
                              Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(onPressed: () {}, child: Text("See all")),
              ),

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
                        String formattedDate = _formatDate(honor.createdAt);

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
                                  Icon(
                                    Icons.workspace_premium,
                                    size: 20,
                                    color: Colors.amber,
                                  ),
                                  SizedBox(width: 6),
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

                              // 🔸 Issued By + Date
                              Row(
                                children: [
                                  Icon(
                                    Icons.account_balance,
                                    size: 14,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    honor.issuer,
                                    style: TextStyle(color: Colors.black54),
                                  ),

                                  SizedBox(width: 12),
                                  Icon(
                                    Icons.calendar_month,
                                    size: 14,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    formattedDate,
                                    style: TextStyle(color: Colors.black45),
                                  ),
                                ],
                              ),

                              SizedBox(height: 6),

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

String _formatDate(DateTime date) {
  return "${date.day}-${date.month}-${date.year}";
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
    default:
      return 'assets/icons/webIcon.png';
  }
}
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:karlfive/core/common/widgets/app_scaffold.dart';
// import '../controller/company_details_controller.dart';
// import 'manage_job_req_screen.dart';

// class CompanyDetailsPage extends StatefulWidget {
//   CompanyDetailsPage({super.key});

//   @override
//   State<CompanyDetailsPage> createState() => _CompanyDetailsPageState();
// }

// class _CompanyDetailsPageState extends State<CompanyDetailsPage> {
//   final CompanyDetailsController controller = Get.find();

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await controller.fetchCompanyProfile();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Company Account"),
//         backgroundColor: const Color(0xFF2B7FD0),
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             DrawerHeader(
//               decoration: const BoxDecoration(
//                 color: Color(0xFF2B7FD0),
//               ),
//               child: Text(
//                 controller.userInfo.value?.companies.first.cname ?? "Company Name",
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             ListTile(
//               leading: const Icon(Icons.work_outline),
//               title: const Text('Manage Jobs'),
//               onTap: () {
//                 Get.to(() => ManageJobPostScreen());
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.post_add_outlined),
//               title: const Text('Post a Job'),
//               onTap: () {
//                 // Navigate to post a job page
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.edit),
//               title: const Text('Edit Profile'),
//               onTap: () {
//                 // Navigate to edit profile page
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.person),
//               title: const Text('Profile'),
//               onTap: () {
//                 // Navigate to profile page
//               },
//             ),
//           ],
//         ),
//       ),
//       body: Obx(() {
//         if (controller.userInfo.value == null) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         final company = controller.userInfo.value!.companies.first;

//         return SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 16),

//               /// ================= HEADER (Avatar + Company Info) =================
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(10),
//                   border: Border.all(color: Colors.grey.shade300),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black12,
//                       blurRadius: 6,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 padding: const EdgeInsets.all(16),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     CircleAvatar(
//                       radius: 30,
//                       backgroundImage: NetworkImage(company.clogo),
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             company.cname,
//                             style: const TextStyle(
//                                 fontSize: 18, fontWeight: FontWeight.bold),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             company.industry ?? "No industry info",
//                             style:
//                                 const TextStyle(fontSize: 13, color: Colors.black54),
//                           ),
//                           const SizedBox(height: 6),
//                           Row(
//                             children: [
//                               const Icon(Icons.location_on,
//                                   size: 14, color: Colors.black54),
//                               const SizedBox(width: 4),
//                               Text("${company.city}, ${company.country}",
//                                   style: const TextStyle(
//                                       fontSize: 12, color: Colors.black54)),
//                               const SizedBox(width: 12),
//                               const Icon(Icons.people,
//                                   size: 14, color: Colors.black54),
//                               const SizedBox(width: 4),
//                               Text(
//                                   "${company.employeesId.length} recruiter${company.employeesId.length > 1 ? "s" : ""}",
//                                   style: const TextStyle(
//                                       fontSize: 12, color: Colors.black54)),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 16),

//               /// ================= PROMO / Buttons Section =================
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Try It Free – Post Your First Job at No Cost!",
//                       style: TextStyle(
//                           fontSize: 16, fontWeight: FontWeight.w600),
//                     ),
//                     const SizedBox(height: 6),
//                     Text(
//                       "Easily post job openings & reach the right talent fast.",
//                       style:
//                           TextStyle(fontSize: 12, color: Color(0xFF727272)),
//                     ),
//                     const SizedBox(height: 12),
//                     Row(
//                       children: [
//                         ElevatedButton(
//                           onPressed: () =>
//                               Get.to(() => ManageJobPostScreen()),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Color(0xFF2B7FD0),
//                             foregroundColor: Colors.white,
//                             padding: const EdgeInsets.symmetric(horizontal: 14),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                           child: const Text("Manage Jobs"),
//                         ),
//                         const SizedBox(width: 10),
//                         ElevatedButton(
//                           onPressed: () {},
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Color(0xFF2B7FD0),
//                             foregroundColor: Colors.white,
//                             padding: const EdgeInsets.symmetric(horizontal: 14),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                           child: const Text("Post A Job"),
//                         ),
//                         const SizedBox(width: 10),
//                         ElevatedButton(
//                           onPressed: () {},
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Color(0xFF2B7FD0),
//                             foregroundColor: Colors.white,
//                             padding: const EdgeInsets.symmetric(horizontal: 14),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                           child: const Text("Edit Profile"),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),

//               /// ================= Elevator Pitch / Other Sections =================
//               // Keep the rest of your widgets here as before
//               // infoTile(), sectionTitle(), employees table, etc.
//             ],
//           ),
//         );
//       }),
//     );
//   }

//   Widget infoTile(String title, String value) {
//     return ListTile(
//       title: Text(title,
//           style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
//       subtitle: Text(value),
//     );
//   }

//   Widget sectionTitle(String title, {bool canDelete = false}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(title,
//               style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
//           if (canDelete) const Icon(Icons.delete_outline, color: Colors.red),
//         ],
//       ),
//     );
//   }
// }
