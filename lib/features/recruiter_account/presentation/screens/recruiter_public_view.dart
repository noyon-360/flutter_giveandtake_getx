import 'dart:developer' as DPrint;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giveandtake/core/network/constants/api_constants.dart';
import 'package:giveandtake/core/network/services/auth_storage_service.dart';
import 'package:giveandtake/features/public_view/services/public_profile_follow_service.dart';
import 'package:giveandtake/features/public_view/widgets/public_profile_action_row.dart';
import 'package:giveandtake/features/recruiter_account/presentation/controller/recruiter_controller.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/elevator_pitch.dart';
import '../widgets/social_media.dart';

const Color _mediaPlaceholderBg = Color(0xFFDBEAFE);
const Color _mediaPlaceholderText = Color(0xFF1E3A8A);

class RecruiterPublicViewScreen extends StatefulWidget {
  const RecruiterPublicViewScreen({super.key, required this.slug});

  final String slug;

  @override
  State<RecruiterPublicViewScreen> createState() =>
      _RecruiterPublicViewScreenState();
}

class _RecruiterPublicViewScreenState extends State<RecruiterPublicViewScreen> {
  final RecruiterController recruiterController =
      Get.find<RecruiterController>();
  final PublicProfileFollowService _followService =
      PublicProfileFollowService();

  String? _accessToken;
  bool _isFollowing = false;
  bool _isFollowBusy = false;
  bool _isOwnProfile = false;
  int _followerCount = 0;

  String _parseHtmlString(String htmlString) {
    final document = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(document, '');
  }

  Future<void> _shareProfile() async {
    final user = recruiterController.publicView.value;
    final name = user != null ? "${user.firstName} ${user.sureName}".trim() : '';
    final url = "${ApiConstants.webBaseUrl}/rp/${widget.slug}";
    final text = name.isNotEmpty
        ? "Check out $name on EVPitch:\n$url"
        : "Check out this profile on EVPitch:\n$url";
    await Share.share(text, subject: 'EVPitch profile');
  }

  Future<void> _openSocialLink(String value) async {
    final Uri url = Uri.parse(value);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
      return;
    }
    Get.snackbar('Error', 'Could not open $value');
  }

  Future<void> _handleFollow() async {
    final targetRecruiterId = recruiterController.publicView.value?.userId ?? '';
    if (_isFollowBusy) {
      return;
    }

    setState(() => _isFollowBusy = true);
    try {
      final nextState = await _followService.toggleRecruiter(
        targetUserId: targetRecruiterId,
        currentlyFollowing: _isFollowing,
      );

      if (!mounted) return;
      setState(() {
        _isFollowing = nextState;
        // Keep the visible follower count in sync with the action just taken.
        _followerCount = (_followerCount + (nextState ? 1 : -1))
            .clamp(0, 1 << 31);
      });
      Get.snackbar(
        nextState ? 'Followed' : 'Unfollowed',
        nextState
            ? 'You are now following this recruiter.'
            : 'You have unfollowed this recruiter.',
      );
    } on PublicProfileFollowException catch (e) {
      Get.snackbar('Follow unavailable', e.message);
    } finally {
      if (mounted) {
        setState(() => _isFollowBusy = false);
      }
    }
  }

  Future<void> _loadFollowStatus() async {
    final targetRecruiterId = recruiterController.publicView.value?.userId ?? '';
    if (targetRecruiterId.isEmpty) return;

    final results = await Future.wait([
      _followService.isOwnProfile(targetRecruiterId),
      _followService.isFollowing(targetRecruiterId),
      _followService.followerCount(targetRecruiterId),
    ]);

    if (mounted) {
      setState(() {
        _isOwnProfile = results[0] as bool;
        _isFollowing = results[1] as bool;
        _followerCount = results[2] as int;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await recruiterController.recruiterPublicView(widget.slug);
      await _loadFollowStatus();
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
    return Scaffold(
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
          if (recruiterController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (recruiterController.errorMessage.value.isNotEmpty) {
            return Center(child: Text(recruiterController.errorMessage.value));
          }

          if (recruiterController.publicView.value == null) {
            return const Center(child: Text("No recruiter data found."));
          }

          final user = recruiterController.publicView.value!;

          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.bottomLeft,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 200,
                      child: user.banner.isNotEmpty
                          ? Image.network(
                              user.banner,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: _mediaPlaceholderBg,
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.image_not_supported,
                                  color: _mediaPlaceholderText,
                                  size: 40,
                                ),
                              ),
                            )
                          : Container(
                              color: _mediaPlaceholderBg,
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.image_not_supported,
                                color: _mediaPlaceholderText,
                                size: 40,
                              ),
                            ),
                    ),
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
                          child: user.photo.isNotEmpty
                              ? Image.network(
                                  user.photo,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    color: _mediaPlaceholderBg,
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.person,
                                      color: _mediaPlaceholderText,
                                      size: 32,
                                    ),
                                  ),
                                )
                              : Container(
                                  color: _mediaPlaceholderBg,
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.person,
                                    color: _mediaPlaceholderText,
                                    size: 32,
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
                        child: PublicProfileActionRow(
                          onFollow: _handleFollow,
                          onShare: _shareProfile,
                          isFollowing: _isFollowing,
                          isBusy: _isFollowBusy,
                          showFollow: !_isOwnProfile,
                          followerCount: _followerCount,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 58),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: user.sLink
                            .map(
                              (link) => GestureDetector(
                                onTap: () => _openSocialLink(link.url ?? ''),
                                child: SocialMedia(
                                  image: _getSocialIcon(link.label),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "${user.firstName} ${user.sureName}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      if (user.title.isNotEmpty) ...[
                        Text(
                          user.title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                      ],
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 16),
                          const SizedBox(width: 4),
                          Text("${user.city}, ${user.country}"),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Elevator Pitch",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
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
                          height: 280,
                          width: double.infinity,
                          child: Builder(
                            builder: (context) {
                              DPrint.log("DEBUG: VIDEO INFO CLEAN TEST");
                              DPrint.log(
                                "Video URL: ${ApiConstants.baseUrl}/elevator-pitch/stream/${user.elevatorPitch?.id ?? ''}",
                              );

                              return ElevatorPitchSection(
                                videoUrl: user.elevatorPitch?.id != null
                                    ? "${ApiConstants.baseUrl}/elevator-pitch/stream/${user.elevatorPitch!.id}"
                                    : null,
                                httpHeaders: {
                                  "Custom-Header": "value",
                                  if (_accessToken != null)
                                    "Authorization": "Bearer $_accessToken",
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "About",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(),
                      const SizedBox(height: 8),
                      Text(
                        _parseHtmlString(user.bio),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
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
