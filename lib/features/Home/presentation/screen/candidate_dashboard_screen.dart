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

import '../../../recruiter_account/presentation/widgets/elevator_pitch.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final token = await Get.find<AuthStorageService>().getAccessToken();
      if (mounted) {
        setState(() {
          _accessToken = token;
        });
      }
      print('🔄 [CandidateDashboardScreen] Fetching dashboard data...');
      controller.fetchDashboardData();
    });
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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _refreshData,
            tooltip: 'Refresh',
          ),
        ],
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
                        child:
                            resume?.banner != null && resume!.banner!.isNotEmpty
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
                              (resume?.photo == null || resume!.photo!.isEmpty)
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
                          // Navigate to edit candidate profile screen
                          Get.to(() => const EditCandidateProfileScreen(), 
                            arguments: controller.resumeData.value);
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
                                    DPrint.log("DEBUG: VIDEO INFO CLEAN TEST");
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
                                            final shouldDelete = await Get.dialog<bool>(
                                              AlertDialog(
                                                title: const Text('Delete Video'),
                                                content: const Text(
                                                  'Are you sure you want to delete your elevator video?',
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () => Get.back(result: false),
                                                    child: const Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () => Get.back(result: true),
                                                    child: const Text('Delete'),
                                                  ),
                                                ],
                                              ),
                                            );

                                            if (shouldDelete == true) {
                                              await controller.deleteElevatorVideo();
                                            }
                                          },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: controller.isDeletingVideo.value
                                          ? const SizedBox(
                                              width: 18,
                                              height: 18,
                                              child: CircularProgressIndicator(
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
                      style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
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
                      style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
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
          style: const TextStyle(fontSize: 14, color: Color(0xFF4A5568)),
        ),
      ],
    );
  }
}
