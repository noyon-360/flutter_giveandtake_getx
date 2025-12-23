import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/common/widgets/app_scaffold.dart';
import 'package:karlfive/core/theme/app_colors.dart';
import 'package:karlfive/features/Home/presentation/controllers/candidate_dashboard_controller.dart';
import 'package:karlfive/features/Home/presentation/widgets/app_drawer.dart';
import 'package:karlfive/features/company/presentation/widget/elevator-pitch_company_widget.dart';
import 'package:karlfive/features/elevator/presentation/screens/elevator_resume_screen.dart';
import 'package:karlfive/features/recruiter_account/presentation/screens/video_upload_screen.dart';

class CandidateDashboardScreen extends StatefulWidget {
  const CandidateDashboardScreen({super.key});

  @override
  State<CandidateDashboardScreen> createState() => _CandidateDashboardScreenState();
}

class _CandidateDashboardScreenState extends State<CandidateDashboardScreen> {
  final CandidateDashboardController controller = Get.put(CandidateDashboardController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text(
          "Candidate Dashboard",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF2B7FD0),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoadingResume.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final resumeData = controller.resumeData.value;
          final resume = resumeData?.resume;
          final elevatorPitches = resumeData?.elevatorPitch ?? [];
          final hasElevatorPitch =
              elevatorPitches.isNotEmpty &&
              elevatorPitches.first.video?.hlsUrl != null;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ==================== BANNER & PROFILE PHOTO ====================
                SizedBox(
                  height: 230,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Banner Image
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        height: 150,
                        child: resume?.banner != null && resume!.banner!.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: resume.banner!,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: Colors.grey.shade300,
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: Colors.grey.shade300,
                                ),
                              )
                            : Container(
                                color: Colors.grey.shade300,
                              ),
                      ),
                      
                      // Profile Photo (overlapping banner)
                      Positioned(
                        left: 16,
                        bottom: 50,
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.white, width: 3),
                            color: Colors.grey.shade300,
                            image: (resume?.photo != null && resume!.photo!.isNotEmpty)
                                ? DecorationImage(
                                    image: CachedNetworkImageProvider(resume.photo!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: (resume?.photo == null || resume!.photo!.isEmpty)
                              ? const Icon(Icons.person, size: 50, color: Colors.grey)
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),

                // Name below the banner/profile section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "${resume?.firstName ?? ''} ${resume?.lastName ?? ''}".trim().isEmpty
                        ? "Candidate Name"
                        : "${resume?.firstName ?? ''} ${resume?.lastName ?? ''}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ==================== CONTACT INFO SECTION ====================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Contact Info",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          // Navigate to elevator resume screen
                          Get.to(() => const ElevatorResumeScreen());
                        },
                        icon: const Icon(Icons.edit, size: 16, color: Colors.white),
                        label: const Text(
                          "Edit",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Location
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: _buildInfoRow("Location", "${resume?.city ?? ''}, ${resume?.country ?? ''}".trim()),
                ),
                
                const SizedBox(height: 12),

                // Email
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: _buildInfoRow("Email", resume?.email ?? "test@gmail.com"),
                ),

                const SizedBox(height: 32),

                // ==================== ELEVATOR VIDEO PITCH ====================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      const Text(
                        "Elevator Video Pitch",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.info_outline, size: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "Upload or view a short video introducing yourself.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF666666),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Video Upload/Display Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: hasElevatorPitch
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
                            borderRadius: BorderRadius.circular(12),
                            color: const Color(0xFF191919),
                          ),
                          height: 200,
                          width: double.infinity,
                          child: ElevatorPitchCompanySection(
                            videoUrl: elevatorPitches.first.video!.hlsUrl!,
                            httpHeaders: {
                              'Accept': '*/*',
                              'Accept-Encoding': 'identity',
                              if (elevatorPitches.first.video!.encryptionKeyUrl != null)
                                "Authorization":
                                    "Bearer ${elevatorPitches.first.video!.encryptionKeyUrl}",
                            },
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          // Navigate to video upload screen
                          Get.to(() => const VideoUploadScreen());
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
                          height: 200,
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
                                  'assets/icons/gallery.png',
                                  height: 32,
                                  width: 32,
                                  color: Colors.white70,
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'Upload your elevator pitch',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Upload or view a short video',
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
                ),

                const SizedBox(height: 32),

                // ==================== ABOUT SECTION ====================
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "About",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                if (resume?.aboutUs != null && resume!.aboutUs!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Html(
                    data: resume.aboutUs!,
                    style: {
                      "body": Style(
                        fontSize: FontSize(14),
                        color: const Color(0xFF4A5568),
                        lineHeight: const LineHeight(1.5),
                        margin: Margins.zero,
                        padding: HtmlPaddings.zero,
                      ),
                      "p": Style(
                        margin: Margins.zero,
                        padding: HtmlPaddings.zero,
                      ),
                    },
                  ),
                )
                else
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "No about information available",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ),

                const SizedBox(height: 32),

                // ==================== SKILLS SECTION ====================
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "Skills",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                if (resume?.skills != null && resume!.skills.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: resume.skills.map((skill) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCEDFF),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          skill,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1E40AF),
                          ),
                        ),
                      );
                    }).toList(),
                    ),
                  )
                else
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "No skills added yet",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ),

                const SizedBox(height: 40),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF4A5568),
          ),
        ),
      ],
    );
  }
}
