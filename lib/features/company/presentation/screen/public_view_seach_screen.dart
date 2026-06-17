import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../../../core/network/constants/api_constants.dart';
import '../../../job_listing/presentation/controllers/job_details_controller.dart';
import '../../../job_listing/presentation/screens/job_details_screen.dart';
import '../../../public_view/services/public_profile_follow_service.dart';
import '../../../public_view/widgets/public_profile_action_row.dart';
import '../../../recruiter_account/presentation/widgets/social_media.dart';
import '../../data/model/public_view_search_response_model.dart';
import '../controller/company_details_controller.dart';
import '../widget/elevator-pitch_company_widget.dart';
import '../widget/search_job_card.dart';

const Color _mediaPlaceholderBg = Color(0xFFDBEAFE);
const Color _mediaPlaceholderText = Color(0xFF1E3A8A);

class PublicViewSeachScreen extends StatefulWidget {
  final String slug;
  const PublicViewSeachScreen({super.key, required this.slug});

  @override
  State<PublicViewSeachScreen> createState() => _PublicViewSeachScreenState();
}

class _PublicViewSeachScreenState extends State<PublicViewSeachScreen> {
  final CompanyDetailsController controller =
      Get.find<CompanyDetailsController>();
  final PublicProfileFollowService _followService =
      PublicProfileFollowService();

  bool _isFollowing = false;
  bool _isFollowBusy = false;
  bool _isOwnProfile = false;
  int _followerCount = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.getpublicView(widget.slug);

      // fetch company jobs after getting company info
      if (controller.publicView.value != null &&
          controller.publicView.value!.companies.isNotEmpty) {
        final company = controller.publicView.value!.companies.first;
        final companyId = company.id;
        await controller.fetchPublicJobs(companyId);
        await _loadCompanyFollowStatus(company);
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
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = controller.publicView.value;
          if (data == null || data.companies.isEmpty) {
            return const Center(child: Text("No company data found"));
          }

          final company = data.companies.first;
          final honors = data.honors;
          final jobs = controller
              .pubJobs; // this should be RxList<PublicViewJobsResponseModel>

          return SingleChildScrollView(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------------- COVER IMAGE ----------------
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomLeft,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 200,
                    child: Image.network(
                      company.banner,
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
                        child: Image.network(
                          company.clogo,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: _mediaPlaceholderBg,
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.business,
                              color: _mediaPlaceholderText,
                              size: 32,
                            ),
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
                        isFollowing: _isFollowing,
                        isBusy: _isFollowBusy,
                        showFollow: !_isOwnProfile,
                        followerCount: _followerCount,
                        onFollow: () => _handleCompanyFollow(company),
                        onShare: () => _shareProfile(company),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 58),

              // ---------------- COMPANY INFO ----------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ----- Social links + Follow + Share (after profile image) -----
                    buildSocialLinks(company),
                    const SizedBox(height: 12),
                    Text(
                      company.cname,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 16),
                        const SizedBox(width: 4),
                        Text("${company.city}, ${company.country}"),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.business, size: 16),
                        const SizedBox(width: 4),
                        Text(company.industry),
                      ],
                    ),
                    const SizedBox(height: 16),

                    sectionTitle("Elevator Pitch"),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: const Color(0xFF191919),
                      ),
                      height: 160,
                      width: double.infinity,
                      child: ElevatorPitchCompanySection(
                        videoUrl:
                            "${ApiConstants.baseUrl}/elevator-pitch/stream/${company.elevatorPitch?.id ?? ""}",
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
                    Text(company.aboutUs),
                    const SizedBox(height: 20),
                    sectionTitle("Company Jobs"),
                    const SizedBox(height: 12),

                    // ---------------- JOB LIST ----------------
                    Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (jobs.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text("No jobs available for this company."),
                        );
                      }
                      return Column(
                        children: jobs.map((job) {
                          final formattedDate = DateFormat(
                            'd MMMM, yyyy',
                          ).format(job.publishDate);

                          return CompanyJobCard(
                            jobTitle: job.title,
                            companyName: company.cname,
                            description: job.description,
                            location: job.location,
                            location_Type: job.locationType,
                            employement_Type: job.employementType,
                            applicants: job.counter,
                            postedDate: formattedDate,
                            companyLogo: company.clogo,
                            onTap: () {
                              Get.to(
                                () => JobDetailsScreen(
                                  jobData: {
                                    'id': job.id,
                                    'jobTitle': job.title,
                                    'company': job.company.cname,
                                    'location': job.location,
                                    'salary': job.salaryRange,
                                    'timePosted': DateFormat(
                                      'd MMMM, yyyy',
                                    ).format(job.publishDate),

                                    // 🔥 THIS IS THE KEY
                                    'raw': job.toJson(),
                                  },
                                ),
                              );
                            },
                            onEasyApply: () {
                              final jobDetailsController = Get.put(
                                JobDetailsController(),
                              );

                              final applicationData = {
                                '_id': job.id,
                                'jobId': job.id,
                                'jobTitle': job.title,
                                'companyId': job.company.id,
                                'companyName': job.company.cname,
                                'companyLogo': job.company.clogo,
                                'location': job.location,
                                'employmentType': job.employementType,
                                'locationType': job.locationType,
                                'customQuestion': job.customQuestion
                                    .map((e) => e.toJson())
                                    .toList(),

                                // Send full job JSON for backend safety
                                'raw': job.toJson(),
                              };

                              jobDetailsController.checkResumeAndApply(
                                applicationData,
                              );
                            },
                          );
                        }).toList(),
                      );
                    }),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Awards and Honors",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),
              honors.isNotEmpty
                  ? Column(
                      children: honors.map((honor) {
                        return SizedBox(
                          width: double.infinity,
                          height: 150, // 👈 match JobCard height
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade300),
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  honor.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  honor.programeName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  _formatDate(honor.programeDate),
                                  style: const TextStyle(color: Colors.black54),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  honor.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    )
                  : const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text("No honors awarded yet."),
                    ),
              const SizedBox(height: 24),
            ],
            ),
          );
        }),
      ),
    );
  }

  Future<void> _loadCompanyFollowStatus(Company company) async {
    if (company.userId.isEmpty) return;

    final results = await Future.wait([
      _followService.isOwnProfile(company.userId),
      _followService.isFollowing(company.userId),
      _followService.followerCount(company.userId),
    ]);

    if (mounted) {
      setState(() {
        _isOwnProfile = results[0] as bool;
        _isFollowing = results[1] as bool;
        _followerCount = results[2] as int;
      });
    }
  }

  Future<void> _handleCompanyFollow(Company company) async {
    if (_isFollowBusy) return;

    setState(() => _isFollowBusy = true);
    try {
      final nextState = await _followService.toggleCompany(
        targetUserId: company.userId,
        companyObjectId: company.id,
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
            ? 'You are now following this company.'
            : 'You have unfollowed this company.',
      );
    } on PublicProfileFollowException catch (e) {
      Get.snackbar('Follow unavailable', e.message);
    } finally {
      if (mounted) {
        setState(() => _isFollowBusy = false);
      }
    }
  }

  Future<void> _shareProfile(Company company) async {
    final url = "${ApiConstants.webBaseUrl}/cmp/${widget.slug}";
    await Share.share(
      "Check out ${company.cname} on EVPitch:\n$url",
      subject: 'EVPitch profile',
    );
  }
}

Widget buildSocialLinks(Company company) {
  final validSocialLinks = company.sLink
      .where((link) => link.url.trim().isNotEmpty)
      .toList();

  if (validSocialLinks.isEmpty) {
    return const Text(
      "No social links available",
      style: TextStyle(color: Colors.black54, fontSize: 12),
    );
  }

  return Wrap(
    spacing: 8,
    runSpacing: 8,
    children: validSocialLinks.map((link) {
      return GestureDetector(
        onTap: () async {
          final Uri url = Uri.parse(link.url);

          if (await canLaunchUrl(url)) {
            await launchUrl(url, mode: LaunchMode.externalApplication);
          } else {
            Get.snackbar(
              "Error",
              "Could not open ${link.label}",
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        },
        child: SocialMedia(image: _getSocialIcon(link.label)),
      );
    }).toList(),
  );
}

Widget sectionTitle(String title) => Text(
  title,
  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
);

String _formatDate(String isoDateString) {
  try {
    final date = DateTime.parse(isoDateString);
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  } catch (_) {
    return "Invalid Date";
  }
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
    case 'website':
      return 'assets/icons/webIcon.png';
    default:
      return 'assets/icons/link.png';
  }
}
