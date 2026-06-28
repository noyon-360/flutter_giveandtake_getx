import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutx_core/flutx_core.dart';
import 'package:get/get.dart';
import 'package:giveandtake/core/network/constants/api_constants.dart';
import 'package:giveandtake/core/network/services/auth_storage_service.dart';
import 'package:giveandtake/core/theme/app_colors.dart';
import 'package:giveandtake/features/Home/presentation/controllers/candidate_dashboard_controller.dart';
import 'package:giveandtake/features/Home/presentation/screen/home_screen.dart';
import 'package:giveandtake/features/recruiter_account/presentation/screens/video_upload_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../recruiter_account/presentation/widgets/elevator_pitch.dart';
import '../../../recruiter_account/presentation/widgets/social_media.dart';
import 'edit_candidate_profile_screen.dart';

class CandidateDashboardScreen extends StatefulWidget {
  const CandidateDashboardScreen({super.key});

  @override
  State<CandidateDashboardScreen> createState() =>
      _CandidateDashboardScreenState();
}

class _CandidateDashboardScreenState extends State<CandidateDashboardScreen> {
  final CandidateDashboardController controller = Get.put(
    CandidateDashboardController(),
  );

  String? _accessToken;

  @override
  void initState() {
    super.initState();
    print('🚀 [CandidateDashboardScreen] Screen initialized');
    _initializeData();
  }

  Future<void> _initializeData() async {
    final token = await Get.find<AuthStorageService>().getAccessToken();
    if (mounted) {
      setState(() {
        _accessToken = token;
      });
    }
    print('🔄 [CandidateDashboardScreen] Fetching dashboard data...');
    controller.fetchDashboardData();
  }

  Future<void> _refreshData() async {
    print('🔄 [CandidateDashboardScreen] Manual refresh triggered');
    await controller.fetchDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.to(() => const HomeScreen()),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
        ),
        title: const Text(
          "Candidate Dashboard",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF2B7FD0),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.refresh, color: Colors.white),
        //     onPressed: _refreshData,
        //     tooltip: 'Refresh',
        //   ),
        // ],
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoadingResume.value) {
            print('⏳ [CandidateDashboardScreen] Loading resume data...');
            return const Center(child: CircularProgressIndicator());
          }

          final resumeData = controller.resumeData.value;
          final resume = resumeData?.resume;
          final elevatorPitches = resumeData?.elevatorPitch ?? [];
          final firstPitch = elevatorPitches.isNotEmpty
              ? elevatorPitches.first
              : null;
          final hasElevatorPitch =
              firstPitch != null &&
              ((firstPitch.id?.isNotEmpty ?? false) ||
                  (firstPitch.video?.hlsUrl?.isNotEmpty ?? false));

          // Log what's being displayed
          if (resumeData == null) {
            print('⚠️ [CandidateDashboardScreen] Resume data is NULL');
          } else {
            print('📱 [CandidateDashboardScreen] Displaying data:');
            print('   - Name: ${resume?.firstName} ${resume?.lastName}');
            print('   - Has Photo: ${resume?.photo != null}');
            print('   - Has Banner: ${resume?.banner != null}');
            print('   - Has Elevator Pitch: $hasElevatorPitch');
            print('   - Skills count: ${resume?.skills.length ?? 0}');
          }

          return RefreshIndicator(
            onRefresh: _refreshData,
            child: SingleChildScrollView(
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
                          child:
                              resume?.banner != null &&
                                  resume!.banner!.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: resume.banner!,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      Container(color: Colors.grey.shade300),
                                  errorWidget: (context, url, error) =>
                                      Container(color: Colors.grey.shade300),
                                )
                              : Container(color: Colors.grey.shade300),
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
                              image:
                                  (resume?.photo != null &&
                                      resume!.photo!.isNotEmpty)
                                  ? DecorationImage(
                                      image: CachedNetworkImageProvider(
                                        resume.photo!,
                                      ),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child:
                                (resume?.photo == null ||
                                    resume!.photo!.isEmpty)
                                ? const Icon(
                                    Icons.person,
                                    size: 50,
                                    color: Colors.grey,
                                  )
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
                      "${resume?.firstName ?? ''} ${resume?.lastName ?? ''}"
                              .trim()
                              .isEmpty
                          ? "Candidate Name"
                          : "${resume?.firstName ?? ''} ${resume?.lastName ?? ''}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ==================== SOCIAL MEDIA SECTION ====================
                  if (resume?.sLink != null && resume!.sLink.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: resume.sLink
                            .where((link) => link.url.trim().isNotEmpty)
                            .map((link) {
                              return GestureDetector(
                                onTap: () async {
                                  final uri = Uri.parse(link.url.trim());
                                  if (await canLaunchUrl(uri)) {
                                    await launchUrl(
                                      uri,
                                      mode: LaunchMode.externalApplication,
                                    );
                                  } else {
                                    Get.snackbar(
                                      "Error",
                                      "Could not open ${link.label}",
                                      snackPosition: SnackPosition.BOTTOM,
                                    );
                                  }
                                },
                                child: Tooltip(
                                  message: link.label,
                                  child: SocialMedia(
                                    image: _getSocialIcon(link.label),
                                  ),
                                ),
                              );
                            })
                            .toList(),
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
                          onPressed: () async {
                            // Navigate to edit candidate profile screen
                            await Get.to(
                              () => const EditCandidateProfileScreen(),
                              arguments: controller.resumeData.value,
                            );
                            // Refresh data when returning from edit screen
                            print(
                              '🔄 [CandidateDashboardScreen] Returned from edit screen, refreshing...',
                            );
                            await controller.fetchDashboardData();
                          },
                          icon: const Icon(
                            Icons.edit,
                            size: 16,
                            color: Colors.white,
                          ),
                          label: const Text(
                            "Edit",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: AppColors.primaryBlue,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
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
                    child: _buildInfoRow(
                      "Location",
                      "${resume?.city ?? ''}, ${resume?.country ?? ''}".trim(),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Email
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: _buildInfoRow(
                      "Email",
                      resume?.email ?? "test@gmail.com",
                    ),
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.info_outline,
                            size: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Upload or view a short video introducing yourself.",
                      style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Video Upload/Display Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: hasElevatorPitch
                        ? Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: const Color(0xFF999999),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),

                                //fetch elevated pitch e
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: const Color(0xFF191919),
                                  ),
                                  height: 280,
                                  width: double.infinity,
                                  child: Builder(
                                    builder: (context) {
                                      DPrint.log(
                                        "DEBUG: VIDEO INFO CLEAN TEST",
                                      );
                                      DPrint.log(
                                        "Video URL: ${ApiConstants.baseUrl}/elevator-pitch/stream/${firstPitch.id ?? ''}",
                                      );

                                      return ElevatorPitchSection(
                                        key: ValueKey(_accessToken),
                                        videoUrl:
                                            "${ApiConstants.baseUrl}/elevator-pitch/stream/${firstPitch.id ?? ''}",
                                        // "https://test.evpitch.com/api/v1/elevator-pitch/stream/69674f57f7f512dd8539b9a2",
                                        // httpHeaders: {
                                        //   "Custom-Header": "value",
                                        //   if (_accessToken != null) ...{
                                        //     "Authorization": "Bearer $_accessToken",
                                        //   },
                                        // },
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Obx(
                                  () => Material(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.circular(18),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(18),
                                      onTap: controller.isDeletingVideo.value
                                          ? null
                                          : () async {
                                              final shouldDelete =
                                                  await Get.dialog<bool>(
                                                    AlertDialog(
                                                      title: const Text(
                                                        'Delete Video',
                                                      ),
                                                      content: const Text(
                                                        'Are you sure you want to delete your elevator video?',
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () =>
                                                              Get.back(
                                                                result: false,
                                                              ),
                                                          child: const Text(
                                                            'Cancel',
                                                          ),
                                                        ),
                                                        TextButton(
                                                          onPressed: () =>
                                                              Get.back(
                                                                result: true,
                                                              ),
                                                          child: const Text(
                                                            'Delete',
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );

                                              if (shouldDelete == true) {
                                                await controller
                                                    .deleteElevatorVideo();
                                              }
                                            },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: controller.isDeletingVideo.value
                                            ? const SizedBox(
                                                width: 18,
                                                height: 18,
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      color: Colors.white,
                                                    ),
                                              )
                                            : const Icon(
                                                Icons.delete_outline,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
                                    const Icon(
                                      Icons.image_outlined,
                                      color: Colors.white,
                                      size: 24,
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

                  const SizedBox(height: 32),

                  // ==================== CERTIFICATIONS SECTION ====================
                  if (resume?.certifications != null &&
                      resume!.certifications.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            "Certifications",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: resume.certifications.map((cert) {
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
                                  cert,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF1E40AF),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),

                  // ==================== LANGUAGES SECTION ====================
                  if (resume?.languages != null && resume!.languages.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            "Languages",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: resume.languages.map((lang) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8F0FE),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  lang,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF1E40AF),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),

                  // ==================== EXPERIENCE SECTION ====================
                  if (resumeData?.experiences != null &&
                      resumeData!.experiences.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            "Experience",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...resumeData.experiences.map((exp) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  exp.position,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  exp.company,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF666666),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                // Text(
                                //   '${_formatDate(exp.startDate)} - ${exp.endDate != null ? _formatDate(exp.endDate) : "Present"}',
                                //   style: const TextStyle(
                                //     fontSize: 12,
                                //     color: Color(0xFF999999),
                                //   ),
                                // ),
                                if (exp.city.isNotEmpty ||
                                    exp.country.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      '${exp.city.isNotEmpty ? exp.city : ""}, ${exp.country.isNotEmpty ? exp.country : ""}'
                                          .trim(),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF999999),
                                      ),
                                    ),
                                  ),
                                if (exp.jobDescription.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Html(
                                      data: exp.jobDescription,
                                      style: {
                                        "body": Style(
                                          fontSize: FontSize(13),
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
                                  ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          );
                        }).toList(),
                        const SizedBox(height: 16),
                      ],
                    ),

                  // ==================== EDUCATION SECTION ====================
                  if (resumeData?.education != null &&
                      resumeData!.education.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            "Education",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...resumeData.education.map((edu) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  edu.degree,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  edu.instituteName,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF666666),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                if (edu.fieldOfStudy.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: Text(
                                      'Field of Study: ${edu.fieldOfStudy}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF999999),
                                      ),
                                    ),
                                  ),
                                Text(
                                  '${_formatDate(edu.startDate)} - ${edu.graduationDate != null ? _formatDate(edu.graduationDate) : "Present"}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF999999),
                                  ),
                                ),
                                if (edu.city.isNotEmpty ||
                                    edu.country.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      '${edu.city.isNotEmpty ? edu.city : ""}, ${edu.country.isNotEmpty ? edu.country : ""}'
                                          .trim(),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF999999),
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  String _getSocialIcon(String label) {
    switch (label.toLowerCase()) {
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
        return 'assets/icons/Fiverr.png';
      default:
        return 'assets/icons/world.png';
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.month}/${date.year}';
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
          style: const TextStyle(fontSize: 14, color: Color(0xFF4A5568)),
        ),
      ],
    );
  }
}
