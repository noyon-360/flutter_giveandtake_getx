import 'dart:developer' as DPrint;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giveandtake/core/common/widgets/app_scaffold.dart';
import 'package:giveandtake/features/recruiter_account/presentation/controller/recruiter_controller.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/services/auth_storage_service.dart';
import '../widgets/elevator_pitch.dart';
import '../widgets/social_media.dart';

class PublicViewScreen extends StatefulWidget {
  const PublicViewScreen({super.key});

  @override
  State<PublicViewScreen> createState() => _PublicViewScreenState();
}

class _PublicViewScreenState extends State<PublicViewScreen> {
  final RecruiterController recruiterController =
      Get.find<RecruiterController>();

  String _parseHtmlString(String htmlString) {
    final document = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(document, '');
  }

  String? _accessToken;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      recruiterController.fetchProfile();
      final token = await Get.find<AuthStorageService>().getAccessToken();
      if (mounted) {
        setState(() {
          _accessToken = token;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: Text('Public view', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF2B7FD0),
        elevation: 0,
      ),
      body: SafeArea(
        child: Obx(() {
          if (recruiterController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (recruiterController.userInfo.value == null) {
            return const Center(child: Text("No recruiter data found."));
          }

          final user = recruiterController.userInfo.value!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner + Photo + Edit Button
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: SizedBox(
                    height: 300,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Banner
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          height: 200,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.grey.shade300,
                              image: user.banner.isNotEmpty
                                  ? DecorationImage(
                                      image: NetworkImage(user.banner),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                          ),
                        ),

                        // Avatar
                        Positioned(
                          left: 20,
                          bottom: 30,
                          child: Container(
                            height: 130,
                            width: 130,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.white, width: 2),
                              color: Colors.grey.shade300,
                              image: user.photo.isNotEmpty
                                  ? DecorationImage(
                                      image: NetworkImage(user.photo),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ----- Social Media (moved to top) -----
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: (user.sLink)
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
                          child: SocialMedia(image: _getSocialIcon(link.label)),
                        ),
                      )
                      .toList(),
                ),

                const SizedBox(height: 16),

                // ----- Follow + Share (after profile image) -----
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2B7FD0),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Follow',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    InkWell(
                      onTap: _shareProfile,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        height: 42,
                        width: 46,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF2B7FD0)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.share,
                          color: Color(0xFF2B7FD0),
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // ----- Basic Info -----
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${user.firstName} ${user.sureName}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      user.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "${user.city}, ${user.country}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF898989),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _parseHtmlString(user.bio),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF898989),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Divider(color: Color(0xFF999999)),

                SizedBox(height: 20),
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
                          "Video URL: ${ApiConstants.baseUrl}/elevator-pitch/stream/${user.elevatorPitch?.id ?? ''}",
                        );

                        return ElevatorPitchSection(
                          videoUrl:
                          "${ApiConstants.baseUrl}/elevator-pitch/stream/${user.elevatorPitch?.id ?? ''}",
                          httpHeaders: {
                            "Custom-Header": "value",
                            if (_accessToken != null) ...{
                              "Authorization": "Bearer $_accessToken",
                            },
                          },
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          );
        }),
      ),
    );
  }

  /// Opens the OS share sheet with this recruiter's public profile link.
  Future<void> _shareProfile() async {
    final user = recruiterController.userInfo.value;
    final name = user != null
        ? "${user.firstName} ${user.sureName}".trim()
        : '';
    final slug = user?.slug ?? '';
    final url = "${ApiConstants.webBaseUrl}/rp/$slug";
    final text = name.isNotEmpty
        ? "Check out $name on EVPitch:\n$url"
        : "Check out this profile on EVPitch:\n$url";
    await Share.share(text, subject: 'EVPitch profile');
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
      default:
        return 'assets/icons/link.png';
    }
  }
}
