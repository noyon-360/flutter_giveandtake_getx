// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:karlfive/core/common/widgets/app_scaffold.dart';
// import 'package:karlfive/features/company/presentation/screen/company_edit_profile.dart';
// import 'package:karlfive/features/company/presentation/screen/connect_company_dialog_screen.dart';
// import 'package:karlfive/features/company_pricing/presentation/screens/plan_pricing_screen.dart';

// import 'package:url_launcher/url_launcher.dart';
// import '../../../recruiter_account/presentation/controller/recruiter_controller.dart';
// import '../../../recruiter_account/presentation/screens/create_job_screen.dart';
// import '../../../recruiter_account/presentation/widgets/elevator_pitch.dart';
// import '../../../recruiter_account/presentation/widgets/social_media.dart';
// import '../controller/company_details_controller.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import '../widget/elevator-pitch_company_widget.dart';
// import '../widget/falcon_button_widget.dart';
// import 'company_change_password_screen.dart';
// import 'employee_screen.dart';
// import 'manage_job_req_screen.dart';

// class CandidateDetailsScreen extends StatefulWidget {
//   CandidateDetailsScreen({super.key});

//   @override
//   State<CandidateDetailsScreen> createState() => _CandidateDetailsScreenState();
// }

// class _CandidateDetailsScreenState extends State<CandidateDetailsScreen> {
//   final CompanyDetailsController controller = Get.find();
//   final RecruiterController recruiterController =
//       Get.find<RecruiterController>();

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await controller.fetchCandidate();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AppScaffold(
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
//           onPressed: () => Get.back(),
//         ),
//         title: const Text(
//           "Back to Applicants",
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 20,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//       ),

//       body: Obx(() {
//         // if (controller.isCompanyLoading.value &&
//         //     controller.isEmployeeLoading.value) {
//         //   return const Center(child: CircularProgressIndicator());
//         // }

//         // if (controller.userInfo.value?.companies == null ||
//         //     controller.userInfo.value!.companies.isEmpty) {
//         //   return const Center(child: Text("No company data"));
//         // }

//         // final company = controller.userInfo.value!.companies.first;
//         if (controller.isLoading.value) {
//           return Center(child: CircularProgressIndicator());
//         }

//         if (controller.candidate.value?.resume == null ||
//             controller.candidate.value?.resume == true) {
//           return Center(child: Text("No applicants data"));
//         }

//         final company = controller.candidate.value!;

//         return SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 20),

//               /// ================= HEADER =================
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(10),
//                   border: Border.all(color: Colors.grey.shade300),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black12,
//                       blurRadius: 6,
//                       offset: Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 padding: const EdgeInsets.all(16),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     /// ───────── Avatar ─────────
//                     CircleAvatar(
//                       radius: 30,
//                       backgroundImage: NetworkImage(
//                         company.resume?.photo ?? "",
//                       ),
//                     ),

//                     /// ───────── Company Name + Location ─────────
//                     /// ================= HEADER =================
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // Company name
//                           Row(
//                             children: [
//                               // Text(
//                               //   company.resume?.firstName??"",
//                               //   style: const TextStyle(
//                               //     fontSize: 18,
//                               //     fontWeight: FontWeight.bold,
//                               //   ),
//                               //   overflow: TextOverflow.ellipsis,
//                               //   maxLines: 1,
//                               // ),
//                               Text(
//                                 "${company.resume?.firstName ?? ""} ${company.resume?.lastName ?? ""} ",
//                                 style: const TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                                 overflow: TextOverflow.ellipsis,
//                                 maxLines: 1,
//                               ),
//                             ],
//                           ),

//                           const SizedBox(height: 4),

//                           const SizedBox(height: 6),

//                           // Location + Recruiters row
//                           Row(
//                             children: [
//                               Icon(
//                                 Icons.location_on,
//                                 size: 14,
//                                 color: Colors.black54,
//                               ),
//                               const SizedBox(width: 4),
//                               Text(
//                                 "${company.resume?.country ?? ""} ",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                   color: Colors.black54,
//                                 ),
//                                 overflow: TextOverflow.ellipsis,
//                                 maxLines: 1,
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),

//                     const SizedBox(width: 10),
//                   ],
//                 ),
//               ),

//               /// ================= PROMO SECTION =================
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     /// 🔹 Social Links on top
//                     // Align(
//                     //   alignment: Alignment.centerRight,
//                     //   child: Container(
//                     //     padding: const EdgeInsets.symmetric(
//                     //       horizontal: 6,
//                     //       vertical: 6,
//                     //     ),
//                     //     decoration: BoxDecoration(
//                     //       color: Colors.white,
//                     //       borderRadius: BorderRadius.circular(8),
//                     //       border: Border.all(color: Colors.grey.shade400),
//                     //     ),
//                     //     child: Wrap(
//                     //       spacing: 6,
//                     //       children: company.sLink.map((e) {
//                     //         IconData icon = FontAwesomeIcons.link;
//                     //         if (e.label.contains("LinkedIn"))
//                     //           icon = FontAwesomeIcons.linkedin;
//                     //         if (e.label.contains("Twitter"))
//                     //           icon = FontAwesomeIcons.twitter;
//                     //         if (e.label.contains("Facebook"))
//                     //           icon = FontAwesomeIcons.facebook;
//                     //         if (e.label.contains("Instagram"))
//                     //           icon = FontAwesomeIcons.instagram;

//                     //         return FaIcon(icon, size: 14, color: Colors.black);
//                     //       }).toList(),
//                     //     ),
//                     //   ),
//                     // ),
//                     const SizedBox(height: 18),

//                     /// 🔹 Promo text
//                     Text(
//                       "About ",
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     const SizedBox(height: 6),

//                     Text(
//                       "${company.resume?.aboutUs ?? ""} ",
//                       style: TextStyle(fontSize: 12, color: Colors.black54),
//                       overflow: TextOverflow.ellipsis,
//                       maxLines: 1,
//                     ),

//                     const SizedBox(height: 20),

//                     // ----- Social Media -----
//                   ],
//                 ),
//               ),

//               /// ================= Elevator Pitch =================
//               sectionTitle("Elevator Pitch", canDelete: true),

//               SizedBox(height: 20),
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   border: Border.all(color: const Color(0xFF999999), width: 1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),

//                 //fetch elevated pitch e
//                 child: Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(4),
//                     color: const Color(0xFF191919),
//                   ),
//                   height: 160,
//                   width: double.infinity,
//                   child: ElevatorPitchCompanySection(
//                     // videoUrl: company.elevatorPitch?.video.hlsUrl,
//                     // httpHeaders: {
//                     //   'Accept': '*/*',
//                     //   'Accept-Encoding': 'identity',

//                     //   "Authorization":
//                     //       "Bearer ${company.elevatorPitch?.video.encryptionKeyUrl}",
//                     //   "Custom-Header": "value",
//                     // },
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20),
//               Text(
//                 "Skills",
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//               ),
//               const SizedBox(height: 6),

//               Text(
//                 "${company.resume?.sLink ?? ""} ",
//                 style: TextStyle(fontSize: 12, color: Colors.black54),
//                 overflow: TextOverflow.ellipsis,
//                 maxLines: 1,
//               ),

//               SizedBox(height: 20),
//             ],
//           ),
//         );
//       }),
//     );
//   }

//   Widget sectionTitle(String title, {bool canDelete = false}) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//           ),
//           if (canDelete) Icon(Icons.delete_outline, color: Colors.red),
//         ],
//       ),
//     );
//   }

//   Widget infoTile(String title, String value) {
//     return ListTile(
//       title: Text(
//         title,
//         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//       ),
//       subtitle: Text(value),
//     );
//   }
// }

// String _formatDate(String isoDateString) {
//   try {
//     // Example input: "2025-09-01T00:00:00.000Z"
//     final DateTime date = DateTime.parse(isoDateString);
//     return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
//   } catch (e) {
//     return "Invalid Date";
//   }
// }

// String stripHtmlTags(String? htmlString) {
//   if (htmlString == null || htmlString.isEmpty) {
//     return "No description available.";
//   }

//   // Remove all HTML tags
//   String noTags = htmlString.replaceAll(RegExp(r'<[^>]*>'), ' ');

//   // Replace multiple spaces/newlines with single space
//   String cleanText = noTags.replaceAll(RegExp(r'\s+'), ' ').trim();

//   return cleanText.isEmpty ? "No description available." : cleanText;
// }

// String _getSocialIcon(String? label) {
//   switch (label?.toLowerCase()) {
//     case 'linkedin':
//       return 'assets/icons/linkedin.png';
//     case 'twitter':
//       return 'assets/icons/twitter.png';
//     case 'upwork':
//       return 'assets/icons/upwork_logo_icon_168329.png';
//     case 'facebook':
//       return 'assets/icons/facebook.png';
//     case 'tiktok':
//       return 'assets/icons/tiktok.png';
//     case 'instagram':
//       return 'assets/icons/instagram.png';

//     case 'fiverr':
//       return 'assets/icons/fiverrIcon.png';
//     case 'website':
//       return 'assets/icons/webIcon.png';
//     default:
//       return 'assets/icons/link.png';
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/common/widgets/app_scaffold.dart';
import 'package:karlfive/features/company/presentation/controller/company_details_controller.dart';
import 'package:karlfive/features/company/presentation/widget/elevator-pitch_company_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class CandidateDetailsScreen extends StatefulWidget {
  const CandidateDetailsScreen({super.key});

  @override
  State<CandidateDetailsScreen> createState() => _CandidateDetailsScreenState();
}

class _CandidateDetailsScreenState extends State<CandidateDetailsScreen> {
  final CompanyDetailsController controller = Get.find<CompanyDetailsController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.fetchCandidate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Back to Applicants",
          style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final candidateData = controller.candidate.value;

        if (candidateData == null || candidateData.resume == null) {
          return const Center(child: Text("No candidate data available"));
        }

        final resume = candidateData.resume!;
        final elevatorPitches = candidateData.elevatorPitch;
        final hasElevatorPitch = elevatorPitches.isNotEmpty &&
            elevatorPitches.first.video?.hlsUrl != null;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // ==================== HEADER ====================
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Profile Photo
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage: resume.photo != null && resume.photo!.isNotEmpty
                            ? CachedNetworkImageProvider(resume.photo!)
                            : null,
                        child: resume.photo == null || resume.photo!.isEmpty
                            ? const Icon(Icons.person, size: 40, color: Colors.grey)
                            : null,
                      ),
                      const SizedBox(width: 16),

                      // Name + Location
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${resume.firstName ?? ''} ${resume.lastName ?? ''}".trim(),
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            if (resume.title != null && resume.title!.isNotEmpty)
                              Text(
                                resume.title!,
                                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                              ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                                const SizedBox(width: 4),
                                Text(
                                  "${resume.city ?? ''}${resume.city != null ? ', ' : ''}${resume.country ?? ''}",
                                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ==================== ABOUT ====================
         if (resume.aboutUs != null && resume.aboutUs!.isNotEmpty) ...[
                const Text("About", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    resume.aboutUs!,
                    style: const TextStyle(fontSize: 14, height: 1.6, color: Colors.black87),
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // ==================== ELEVATOR PITCH ====================
              sectionTitle("Elevator Pitch", canDelete: false),
              const SizedBox(height: 12),

              if (hasElevatorPitch)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 220,
                    width: double.infinity,
                    color: Colors.black,
                    child: ElevatorPitchCompanySection(
                      videoUrl: elevatorPitches.first.video!.hlsUrl!,
                      httpHeaders: elevatorPitches.first.video!.encryptionKeyUrl != null
                          ? {
                              "Authorization":
                                  "Bearer ${elevatorPitches.first.video!.encryptionKeyUrl}",
                              "Accept": "*/*",
                            }
                          : {"Accept": "*/*"},
                    ),
                  ),
                )
              else
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      "No Elevator Pitch Video",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                ),

              const SizedBox(height: 24),

              // ==================== SKILLS ====================
              if (resume.skills.isNotEmpty) ...[
                const Text("Skills", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: resume.skills.map((skill) {
                      return Chip(
                        label: Text(
                          skill.trim(),
                          style: const TextStyle(fontSize: 13),
                        ),
                        backgroundColor: Colors.grey[200],
                        labelStyle: TextStyle(color: Colors.black),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(color: Colors.grey),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 24),
              ],
              // ==================== SOCIAL LINKS ====================
              if (resume.sLink.isNotEmpty) ...[
                const Text("Social Links", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 16,
                  children: resume.sLink.map((link) {
                    IconData icon = FontAwesomeIcons.globe;
                    if (link.toLowerCase().contains("linkedin")) icon = FontAwesomeIcons.linkedin;
                    if (link.toLowerCase().contains("twitter") || link.toLowerCase().contains("x.com")) {
                      icon = FontAwesomeIcons.twitter;
                    }
                    if (link.toLowerCase().contains("github")) icon = FontAwesomeIcons.github;
                    if (link.toLowerCase().contains("facebook")) icon = FontAwesomeIcons.facebook;

                    return InkWell(
                      onTap: () => launchUrl(Uri.parse(link)),
                      child: FaIcon(icon, size: 28, color: Colors.blue),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
              ],

              
            ],
          ),
        );
      }),
    );
  }

  Widget sectionTitle(String title, {bool canDelete = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
          if (canDelete) const Icon(Icons.delete_outline, color: Colors.red),
        ],
      ),
    );
  }
}