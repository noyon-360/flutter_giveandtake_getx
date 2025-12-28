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
  final CompanyDetailsController controller =
      Get.find<CompanyDetailsController>();

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

        final candidateData = controller.candidate.value;

        if (candidateData == null || candidateData.resume == null) {
          return const Center(child: Text("No candidate data available"));
        }

        final resume = candidateData.resume!;
        final elevatorPitches = candidateData.elevatorPitch;
        final hasElevatorPitch =
            elevatorPitches.isNotEmpty &&
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
                            backgroundImage:
                                resume.photo != null && resume.photo!.isNotEmpty
                                ? CachedNetworkImageProvider(resume.photo!)
                                : null,
                            child: resume.photo == null || resume.photo!.isEmpty
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
                                  "${resume.firstName ?? ''} ${resume.lastName ?? ''}"
                                      .trim(),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                if (resume.title != null &&
                                    resume.title!.isNotEmpty)
                                  Text(
                                    resume.title!,
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
                                        "${resume.city ?? ''}${resume.city != null ? ', ' : ''}${resume.country ?? ''}",
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
                            // TODO: Open or download resume
                          },
                          icon: const Icon(Icons.download, color: Colors.white),
                          label: const Text("Resume"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ==================== ABOUT ====================
              if (resume.aboutUs != null && resume.aboutUs!.isNotEmpty) ...[
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
                    resume.aboutUs!,
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
                          elevatorPitches.first.video!.encryptionKeyUrl != null
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
                const Text(
                  "Social Links",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 16,
                  children: resume.sLink.map((link) {
                    IconData icon = FontAwesomeIcons.globe;
                    if (link.toLowerCase().contains("linkedin"))
                      icon = FontAwesomeIcons.linkedin;
                    if (link.toLowerCase().contains("twitter") ||
                        link.toLowerCase().contains("x.com")) {
                      icon = FontAwesomeIcons.twitter;
                    }
                    if (link.toLowerCase().contains("github"))
                      icon = FontAwesomeIcons.github;
                    if (link.toLowerCase().contains("facebook"))
                      icon = FontAwesomeIcons.facebook;

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
