import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giveandtake/core/common/widgets/app_scaffold.dart';
import 'package:giveandtake/features/company/presentation/controller/company_details_controller.dart';
import 'package:giveandtake/features/company/presentation/widget/elevator-pitch_company_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/model/company_applicant_list_response_model.dart';
import '../widget/pdf_download_widget.dart';

class CandidateDetailsScreen extends StatefulWidget {
  /// The applicant whose details should be displayed.
  final ApplicantListResponseModel applicant;

  const CandidateDetailsScreen({super.key, required this.applicant});

  @override
  State<CandidateDetailsScreen> createState() => _CandidateDetailsScreenState();
}

class _CandidateDetailsScreenState extends State<CandidateDetailsScreen> {
  final CompanyDetailsController controller =
      Get.find<CompanyDetailsController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadCandidateData();
    });
  }

  Future<void> _loadCandidateData() async {
    final user = widget.applicant.user;

    // Fetch the resume (PDF) for THIS applicant.
    if (user.id.isNotEmpty) {
      await controller.fetchResume(user.id);
    }

    // Fetch the elevator pitch / public profile for THIS applicant by slug.
    if (user.slug.isNotEmpty) {
      await controller.getCandidatePublicView(user.slug);
    }
  }

  Future<void> _onRefresh() async {
    debugPrint("REFRESH TRIGGERED");
    await _loadCandidateData();
  }

  @override
  Widget build(BuildContext context) {
    final applicant = widget.applicant;
    final resume = applicant.resume;
    final user = applicant.user;

    return AppScaffold(
      removePadding: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Back to Applicants",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Resume PDF list for THIS applicant.
        final resumeData = controller.resume;

        // The applicant-list endpoint does NOT embed the full resume, so
        // `applicant.resume` is usually null and the header rendered blank.
        // Prefer the public candidate view fetched by slug (which DOES carry
        // the profile fields), falling back to the embedded resume.
        final profile = controller.candidateView.value?.resume;
        final photo = profile?.photo ?? resume?.photo ?? '';
        final fullName = [
          profile?.firstName ?? resume?.firstName ?? '',
          profile?.lastName ?? resume?.lastName ?? '',
        ].where((e) => e.trim().isNotEmpty).join(' ').trim();
        final displayName = fullName.isNotEmpty ? fullName : user.name;
        final title = profile?.title ?? resume?.title ?? '';
        final city = profile?.city ?? resume?.city ?? '';
        final country = profile?.country ?? resume?.country ?? '';
        final aboutUs = profile?.aboutUs ?? resume?.aboutUs ?? '';
        final skills = (profile != null && profile.skills.isNotEmpty)
            ? profile.skills
            : (resume?.skills ?? const <String>[]);

        // Elevator pitch comes from the public candidate view (fetched by slug).
        final candidatePublic = controller.candidateView.value;
        final elevatorPitches = candidatePublic?.elevatorPitch ?? const [];
        final hasElevatorPitch =
            elevatorPitches.isNotEmpty &&
            elevatorPitches.first.video?.hlsUrl != null;

        return RefreshIndicator(
          onRefresh: _onRefresh,
          color: Colors.blue,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),

            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                // ==================== HEADER ====================
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Profile Photo
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.grey.shade200,
                              backgroundImage: photo.isNotEmpty
                                  ? CachedNetworkImageProvider(photo)
                                  : null,
                              child: photo.isEmpty
                                  ? const Icon(
                                      Icons.person,
                                      size: 40,
                                      color: Colors.grey,
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 16),

                            // Name + Title + Location
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    displayName,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  if (title.isNotEmpty)
                                    Text(
                                      title,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        size: 16,
                                        color: Colors.grey[600],
                                      ),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          "$city${city.isNotEmpty && country.isNotEmpty ? ', ' : ''}$country",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Resume Button - Bottom Right Corner
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              if (resumeData.isNotEmpty &&
                                  resumeData.first.file.isNotEmpty &&
                                  resumeData.first.file.first.url.isNotEmpty) {
                                final fileUrl = resumeData.first.file.first.url;

                                downloadAndOpenPdf(
                                  fileUrl,
                                  resumeData.first.file.first.filename,
                                );
                              } else {
                                Get.snackbar(
                                  "Unavailable",
                                  "Resume not found",
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                              }
                            },

                            icon: const Icon(
                              Icons.download,
                              color: Colors.white,
                            ),
                            label: const Text("Resume"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ==================== ABOUT ====================
                if (aboutUs.isNotEmpty) ...[
                  const Text(
                    "About",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
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
                      aboutUs,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.6,
                        color: Colors.black87,
                      ),
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
                        httpHeaders:
                            elevatorPitches.first.video!.encryptionKeyUrl !=
                                null
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
                if (skills.isNotEmpty) ...[
                  const Text(
                    "Skills",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
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
                      children: skills.map((skill) {
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
                if (resume != null && resume.sLink.isNotEmpty) ...[
                  const Text(
                    "Social Links",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 16,
                    children: resume.sLink.map((link) {
                      final map = link is Map ? link : <String, dynamic>{};
                      final label = (map['label'] ?? '').toString().toLowerCase();
                      final url = (map['url'] ?? '').toString();
                      IconData icon = FontAwesomeIcons.globe;
                      if (label.contains("linkedin") ||
                          url.toLowerCase().contains("linkedin"))
                        icon = FontAwesomeIcons.linkedin;
                      if (label.contains("twitter") ||
                          url.toLowerCase().contains("x.com")) {
                        icon = FontAwesomeIcons.twitter;
                      }
                      if (label.contains("github"))
                        icon = FontAwesomeIcons.github;
                      if (label.contains("facebook"))
                        icon = FontAwesomeIcons.facebook;

                      return InkWell(
                        onTap: url.isEmpty
                            ? null
                            : () => launchUrl(Uri.parse(url)),
                        child: FaIcon(icon, size: 28, color: Colors.blue),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                ],
              ],
            ),
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
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          if (canDelete) const Icon(Icons.delete_outline, color: Colors.red),
        ],
      ),
    );
  }
}
