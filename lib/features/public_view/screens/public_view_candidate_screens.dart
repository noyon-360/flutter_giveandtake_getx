// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../company/presentation/controller/company_details_controller.dart';
// import '../models/get_resume_public_view_response_model.dart';
// // import '../../company/data/model/get_resume_public_view_response_model.dart';

// class PublicViewCandidateScreen extends StatefulWidget {
//   final String slug;
//   const PublicViewCandidateScreen({super.key, required this.slug});

//   @override
//   State<PublicViewCandidateScreen> createState() =>
//       _PublicViewCandidateScreenState();
// }

// class _PublicViewCandidateScreenState
//     extends State<PublicViewCandidateScreen> {

//   final controller = Get.find<CompanyDetailsController>();

//   @override
//   void initState() {
//     super.initState();
//     controller.getCandidatePublicView(widget.slug);
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Hardcoded data to bypass API
//     final resume = Resume(
//       id: "mock_id",
//       firstName: "Soykot",
//       lastName: "Rahman2",
//       country: "Bangladesh",
//       city: "Dhaka",
//       banner: "", // placeholder handled in UI logic
//       photo: "",
//       email: "soykot@example.com",
//       aboutUs: "No description provided",
//       skills: ["Flutter", "Java"],
//       immediatelyAvailable: true,
//       certifications: [],
//       languages: [],
//       sLink: [],
//     );

//     final data = GetResumePublicViewResponseModel(
//       resume: resume,
//       experiences: [],
//       education: [],
//       awardsAndHonors: [],
//       elevatorPitch: [],
//     );

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [

//               /// ================= HEADER =================
//               Stack(
//                 clipBehavior: Clip.none,
//                 children: [

//                   /// Banner
//                   Container(
//                     height: 180,
//                     width: double.infinity,
//                     color: Colors.yellow, // Placeholder color matching image
//                     child: resume.banner != null &&
//                             resume.banner!.isNotEmpty
//                         ? Image.network(resume.banner!, fit: BoxFit.cover)
//                         : null,
//                   ),

//                   /// Profile Photo
//                   Positioned(
//                     bottom: -45,
//                     left: 20,
//                     child: Container(
//                       padding: const EdgeInsets.all(3),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(14),
//                         child: resume.photo != null &&
//                                 resume.photo!.isNotEmpty
//                             ? Image.network(
//                                 resume.photo!,
//                                 height: 90,
//                                 width: 90,
//                                 fit: BoxFit.cover,
//                               )
//                             : Image.asset(
//                                 "assets/profile.jpg", // Ensure this asset exists or use a network placeholder if needed, user provided this
//                                 height: 90,
//                                 width: 90,
//                                 fit: BoxFit.cover,
//                                 errorBuilder: (context, error, stackTrace) {
//                                    return Container(
//                                      height: 90,
//                                      width: 90,
//                                      color: Colors.grey.shade300,
//                                      child: const Icon(Icons.person, size: 50, color: Colors.grey),
//                                    );
//                                 },
//                               ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 60),

//               /// ================= NAME =================
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [

//                     Text(
//                       "${resume.firstName ?? ""} ${resume.lastName ?? ""}",
//                       style: const TextStyle(
//                           fontSize: 22, fontWeight: FontWeight.bold),
//                     ),

//                     const SizedBox(height: 6),

//                     Row(
//                       children: [
//                         const Icon(Icons.location_on_outlined,
//                             size: 16, color: Colors.grey),
//                         const SizedBox(width: 4),
//                         Text(
//                           "${resume.country ?? ""}${resume.city != null && resume.city!.isNotEmpty ? ", ${resume.city}" : ""}",
//                           style: const TextStyle(color: Colors.grey),
//                         ),
//                       ],
//                     ),

//                     const SizedBox(height: 6),

//                     if (resume.immediatelyAvailable == true)
//                       const Row(
//                         children: [
//                           Icon(Icons.circle,
//                               size: 10, color: Colors.green),
//                           SizedBox(width: 6),
//                           Text(
//                             "Immediately Available",
//                             style: TextStyle(
//                                 color: Colors.green,
//                                 fontWeight: FontWeight.w600),
//                           ),
//                         ],
//                       ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 24),

//               /// ================= ABOUT =================
//                Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         _sectionTitle("About"),
//                         GestureDetector(
//                           onTap: () {
//                              // Share functionality placeholder
//                           },
//                           child: Container(
//                             margin: const EdgeInsets.only(right: 20),
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 16,
//                               vertical: 8,
//                             ),
//                             decoration: BoxDecoration(
//                               border: Border.all(color: Colors.grey.shade300),
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Icon(
//                                   Icons.share,
//                                   size: 18,
//                                   color: Colors.blue.shade800,
//                                 ),
//                                 const SizedBox(width: 6),
//                                 Text(
//                                   "Share profile",
//                                   style: TextStyle(
//                                     color: Colors.blue.shade800,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),

//               const Divider(),

//               Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 20),
//                 child: Text(
//                   resume.aboutUs ?? "No description provided",
//                   style: const TextStyle(color: Colors.grey),
//                 ),
//               ),

//               const SizedBox(height: 28),

//               /// ================= SKILLS =================
//               if (resume.skills != null &&
//                   resume.skills!.isNotEmpty) ...[
//                 _sectionTitle("Skills"),
//                 const SizedBox(height: 14),
//                 Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 20),
//                   child: Wrap(
//                     spacing: 12,
//                     runSpacing: 12,
//                     children: resume.skills!
//                         .map((e) => _skillChip(e))
//                         .toList(),
//                   ),
//                 ),
//               ],

//               const SizedBox(height: 32),

//               /// ================= EXPERIENCE =================
//               if (data.experiences != null &&
//                   data.experiences!.isNotEmpty) ...[
//                 _divider(),
//                 _sectionTitle("Experience"),
//                 const SizedBox(height: 16),
//                 ...data.experiences!
//                     .map((e) => _experienceItem(e))
//                     .toList(),
//               ] else ...[
//                  _divider(),
//                 _sectionTitle("Experience"),
//                 // Placeholder experience matching image
//                  _experienceItem(Experience(
//                     company: "sdfg · sdfg",
//                     position: "Jan 2026 - Present",
//                     startDate: DateTime(2026, 1),
//                     country: "Bangladesh",
//                     // city: "",
//                  )),
//                   _experienceItem(Experience(
//                     company: "N/A",
//                     position: "N/A - Present",
//                     country: "Bangladesh",
//                  )),
//                   _experienceItem(Experience(
//                     company: "N/A",
//                     position: "N/A - Present",
//                     country: "Bangladesh",
//                  )),
//                   _experienceItem(Experience(
//                     company: "N/A",
//                     position: "N/A - Present",
//                     country: "Bangladesh",
//                  )),
//                   _experienceItem(Experience(
//                     company: "N/A",
//                     position: "N/A - Present",
//                     country: "Bangladesh",
//                  )),
//               ],

//               const SizedBox(height: 32),

//               /// ================= EDUCATION =================
//               if (data.education != null &&
//                   data.education!.isNotEmpty) ...[
//                 _divider(),
//                 _sectionTitle("Education"),
//                 const SizedBox(height: 16),
//                 ...data.education!
//                     .map((e) => _educationItem(e))
//                     .toList(),
//               ] else ...[
//                  _divider(),
//                 _sectionTitle("Education"),
//                 // Placeholder education matching image
//                 _educationItem(Education(
//                   degree: "Bachelor's Degree",
//                   fieldOfStudy: "asf",
//                   startDate: DateTime(2026, 1),
//                   city: "Dhaka",
//                   country: "Bangladesh",
//                 )),
//                  _educationItem(Education(
//                   degree: "Bachelor's Degree",
//                   fieldOfStudy: "asf",
//                   city: "Dhaka",
//                   country: "Bangladesh",
//                 )),
//                  _educationItem(Education(
//                   degree: "Bachelor's Degree",
//                   fieldOfStudy: "asf",
//                   city: "Dhaka",
//                   country: "Bangladesh",
//                 )),
//                  _educationItem(Education(
//                   degree: "Bachelor's Degree",
//                   fieldOfStudy: "asf",
//                   city: "Dhaka",
//                   country: "Bangladesh",
//                 )),
//                  _educationItem(Education(
//                   degree: "Bachelor's Degree",
//                   fieldOfStudy: "asf",
//                   city: "Dhaka",
//                   country: "Bangladesh",
//                 )),
//               ],

//               const SizedBox(height: 40),
//             ],
//           ),
//         ),
//     );
//   }

//   /// ================= WIDGETS =================

//   Widget _sectionTitle(String title) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Text(title,
//           style:
//               const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//     );
//   }

//   Widget _divider() {
//     return const Padding(
//       padding: EdgeInsets.symmetric(horizontal: 20),
//       child: Divider(),
//     );
//   }

//   Widget _skillChip(String title) {
//     return Container(
//       padding:
//           const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//       decoration: BoxDecoration(
//         color: const Color(0xFFE7EDFF),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Text(title,
//           style: const TextStyle(
//               color: Color(0xFF3F51B5),
//               fontWeight: FontWeight.w600)),
//     );
//   }

//   Widget _experienceItem(Experience e) {
//     String dateRange = "";
//     if (e.startDate != null) {
//        dateRange = "${_formatDate(e.startDate)} - ${e.endDate != null ? _formatDate(e.endDate) : "Present"}";
//     } else {
//        dateRange = e.position ?? ""; // Using position as date placeholder if needed or just N/A
//     }

//     // Override logic to match image exactly if needed, but standard logic is safer
//     // The image shows "Jan 2026 - Present" as subtitle, likely mapped from date or just text

//     return _infoItem(
//       icon: Icons.work_outline,
//       title: "${e.company ?? ""}", // Title is Company Name e.g. "sdfg . sdfg"
//       subTitle: "${e.position ?? ""}", // Subtitle is date range e.g. "Jan 2026 - Present" based on image
//        // The user code mapped: title -> position . company
//        // Image shows: Bold text "sdfg . sdfg", Subtext "Jan 2026 - Present", Subtext "Bangladesh"
//        // Let's stick closer to the user's code structure but adapt data
//       date: dateRange,
//       location: e.country ?? "",
//     );
//   }

//   Widget _educationItem(Education e) {
//     String dateRange = "N/A - N/A";
//     if (e.startDate != null) {
//          dateRange = "${_formatDate(e.startDate)} - ${e.graduationDate != null ? _formatDate(e.graduationDate) : "N/A"}";
//     }

//     return _infoItem(
//       icon: Icons.school_outlined,
//       title:
//           "${e.degree ?? ""}, ${e.fieldOfStudy ?? ""}",
//       subTitle: dateRange,
//       date: dateRange,
//       location: "${e.city ?? ""}${e.city!=null && e.city!.isNotEmpty ? ", " : ""}${e.country ?? ""}",
//     );
//   }

//   Widget _infoItem({
//     required IconData icon,
//     required String title,
//     String? subTitle,
//     required String date,
//     required String location,
//   }) {
//     return Padding(
//       padding:
//           const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             height: 55,
//             width: 55,
//             decoration: BoxDecoration(
//               color: const Color(0xFFE4ECF7), // Light blue background
//               borderRadius: BorderRadius.circular(14),
//             ),
//             child: Icon(icon,
//                 color: const Color(0xFF2D5BD0), size: 28), // Blue icon
//           ),
//           const SizedBox(width: 14),
//           Expanded(
//             child: Column(
//               crossAxisAlignment:
//                   CrossAxisAlignment.start,
//               children: [
//                 Text(title,
//                     style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold)), // Bold
//                 const SizedBox(height: 4),
//                  // Modify logic to match image:
//                  // Experience:
//                  // Title (Bold)
//                  // Date Range (if passed as separate arg or reuse date)
//                  // Location

//                 if (subTitle != null)
//                  Container(
//                   width: double.infinity,
//                   padding:
//                       const EdgeInsets.symmetric(
//                           horizontal: 12, vertical: 6),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFF1F2F4), // Light grey bg for date
//                     borderRadius:
//                         BorderRadius.circular(20),
//                   ),
//                   child: Text(subTitle,
//                       style: const TextStyle(
//                           color: Colors.black87,
//                           fontSize: 13)),
//                 ) else
//                 Container(
//                   width: double.infinity,
//                   padding:
//                       const EdgeInsets.symmetric(
//                           horizontal: 12, vertical: 6),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFF1F2F4),
//                     borderRadius:
//                         BorderRadius.circular(20),
//                   ),
//                   child: Text(date,
//                       style: const TextStyle(
//                           color: Colors.black87,
//                           fontSize: 13)),
//                 ),

//                 const SizedBox(height: 8),
//                 Row(
//                    children: [
//                       const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
//                       const SizedBox(width: 4),
//                       Text(location,
//                     style: const TextStyle(
//                         color: Colors.grey)),
//                    ]
//                 )

//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   String _formatDate(DateTime? date) {
//     if (date == null) return "N/A";
//     // Format: Jan 2026
//     const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
//     return "${months[date.month - 1]} ${date.year}";
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/network/constants/api_constants.dart';
import '../../company/presentation/controller/company_details_controller.dart';
import '../models/get_resume_public_view_response_model.dart';
import '../widgets/public_profile_action_row.dart';

class PublicViewCandidateScreen extends StatefulWidget {
  final String slug;
  const PublicViewCandidateScreen({super.key, required this.slug});

  @override
  State<PublicViewCandidateScreen> createState() =>
      _PublicViewCandidateScreenState();
}

class _PublicViewCandidateScreenState extends State<PublicViewCandidateScreen> {
  final controller = Get.find<CompanyDetailsController>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getCandidatePublicView(widget.slug);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Public view',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2B7FD0),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Obx(() {
          /// ================= LOADING =================
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          /// ================= ERROR =================
          if (controller.errorMessage.value.isNotEmpty) {
            return Center(child: Text(controller.errorMessage.value));
          }

          final data = controller.candidateView.value;

          if (data == null || data.resume == null) {
            return const Center(child: Text("No Data Found"));
          }

          final resume = data.resume!;

          return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ================= HEADER =================
              Stack(
                clipBehavior: Clip.none,
                children: [
                  /// Banner
                  Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey.shade200,
                    child: resume.banner != null && resume.banner!.isNotEmpty
                        ? Image.network(resume.banner!, fit: BoxFit.cover)
                        : null,
                  ),

                  /// Profile Image
                  Positioned(
                    bottom: -48,
                    left: 16,
                    child: Container(
                      width: 96,
                      height: 96,
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.15),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: resume.photo != null && resume.photo!.isNotEmpty
                            ? Image.network(
                                resume.photo!,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                color: Colors.grey.shade300,
                                child: const Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                              ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -45,
                    left: 128,
                    right: 16,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Obx(
                        () => PublicProfileActionRow(
                          isFollowing: controller.isFollowing.value,
                          onFollow: controller.toggleFollow,
                          onShare: _shareProfile,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 58),

              /// ====== SOCIAL + FOLLOW + SHARE (after profile image) ======
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _candidateSocialLinks(resume),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// ================= NAME =================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${resume.firstName ?? ""} ${resume.lastName ?? ""}",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "${resume.country ?? ""}${resume.city != null && resume.city!.isNotEmpty ? ", ${resume.city}" : ""}",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    if (resume.immediatelyAvailable == true)
                      const Row(
                        children: [
                          Icon(Icons.circle, size: 10, color: Colors.green),
                          SizedBox(width: 6),
                          Text(
                            "Immediately Available",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              /// ================= ABOUT =================
              _sectionTitle("About"),
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  resume.aboutUs ?? "No description provided",
                  style: const TextStyle(color: Colors.grey),
                ),
              ),

              const SizedBox(height: 30),

              /// ================= SKILLS =================
              if (resume.skills != null && resume.skills!.isNotEmpty) ...[
                _sectionTitle("Skills"),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: resume.skills!.map((e) => _skillChip(e)).toList(),
                  ),
                ),
              ],

              const SizedBox(height: 30),

              /// ================= EXPERIENCE =================
              _divider(),
              _sectionTitle("Experience"),
              const SizedBox(height: 10),

              if (data.experiences != null && data.experiences!.isNotEmpty)
                ...data.experiences!.map((e) => _experienceItem(e)).toList()
              else
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Text("No Experience Added"),
                ),

              const SizedBox(height: 30),

              /// ================= EDUCATION =================
              _divider(),
              _sectionTitle("Education"),
              const SizedBox(height: 10),

              if (data.education != null && data.education!.isNotEmpty)
                ...data.education!.map((e) => _educationItem(e)).toList()
              else
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Text("No Education Added"),
                ),

              const SizedBox(height: 40),
            ],
          ),
          );
        }),
      ),
    );
  }

  /// ================= UI HELPERS =================

  /// Opens the OS share sheet with this candidate's public profile link.
  Future<void> _shareProfile() async {
    final resume = controller.candidateView.value?.resume;
    final name = resume != null
        ? "${resume.firstName ?? ''} ${resume.lastName ?? ''}".trim()
        : '';
    final url = "${ApiConstants.webBaseUrl}/cp/${widget.slug}";
    final text = name.isNotEmpty
        ? "Check out $name on EVPitch:\n$url"
        : "Check out this profile on EVPitch:\n$url";
    await Share.share(text, subject: 'EVPitch profile');
  }

  /// Candidate social links (URLs only — rendered as generic link icons).
  Widget _candidateSocialLinks(Resume resume) {
    final links = resume.sLink
        .where((l) => (l.url ?? '').trim().isNotEmpty)
        .toList();
    if (links.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: links.map((l) {
        return GestureDetector(
          onTap: () async {
            final uri = Uri.parse(l.url!.trim());
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            } else {
              Get.snackbar('Error', 'Could not open ${l.url}');
            }
          },
          child: Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F8FF),
              borderRadius: BorderRadius.circular(7),
              border: Border.all(color: const Color(0xFF8ABAF0), width: 1),
            ),
            child: const Icon(Icons.link, color: Color(0xFF2B7FD0), size: 18),
          ),
        );
      }).toList(),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _divider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Divider(),
    );
  }

  Widget _skillChip(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFE7EDFF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF3F51B5),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _experienceItem(Experience e) {
    return ListTile(
      leading: const Icon(Icons.work_outline),
      title: Text(e.company ?? ""),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${_formatDate(e.startDate)} - ${e.endDate != null ? _formatDate(e.endDate) : "Present"}",
          ),
          Text(e.country ?? ""),
        ],
      ),
    );
  }

  Widget _educationItem(Education e) {
    return ListTile(
      leading: const Icon(Icons.school_outlined),
      title: Text("${e.degree ?? ""}, ${e.fieldOfStudy ?? ""}"),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${_formatDate(e.startDate)} - ${e.graduationDate != null ? _formatDate(e.graduationDate) : "N/A"}",
          ),
          Text("${e.city ?? ""}, ${e.country ?? ""}"),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "N/A";
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return "${months[date.month - 1]} ${date.year}";
  }
}
