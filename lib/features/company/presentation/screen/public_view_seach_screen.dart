import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:karlfive/features/job_listing/presentation/controllers/job_details_controller.dart';
import 'package:karlfive/features/job_listing/presentation/screens/job_details_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/network/constants/api_constants.dart';
import '../../../recruiter_account/presentation/widgets/social_media.dart';
import '../../data/model/public_view_search_response_model.dart';
import '../controller/company_details_controller.dart';
import '../widget/elevator-pitch_company_widget.dart';
import '../widget/search_job_card.dart';

class PublicViewSeachScreen extends StatefulWidget {
  final String slug;
  const PublicViewSeachScreen({super.key, required this.slug});

  @override
  State<PublicViewSeachScreen> createState() => _PublicViewSeachScreenState();
}

class _PublicViewSeachScreenState extends State<PublicViewSeachScreen> {
  final CompanyDetailsController controller =
      Get.find<CompanyDetailsController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.getpublicView(widget.slug);

      // fetch company jobs after getting company info
      if (controller.publicView.value != null &&
          controller.publicView.value!.companies.isNotEmpty) {
        final companyId = controller.publicView.value!.companies.first.id;
        await controller.fetchPublicJobs(companyId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
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
                        color: Colors.grey.shade300,
                        alignment: Alignment.center,
                        child: const Icon(Icons.image_not_supported, size: 40),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -40,
                    left: 16,
                    child: Container(
                      width: 80,
                      height: 80,
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
                            color: Colors.grey.shade300,
                            alignment: Alignment.center,
                            child: const Icon(Icons.business, size: 32),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 50),

              // ---------------- COMPANY INFO ----------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    buildSocialLinks(company),

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Obx(
                          () => GestureDetector(
                            onTap: controller.toggleFollow,
                            child: Container(
                              height: 40,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              decoration: BoxDecoration(
                                color: controller.isFollowing.value
                                    ? Colors.transparent
                                    : const Color(0xFFE6F0FF), // light sky blue
                                border: Border.all(
                                  color: Colors.blue.shade800,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(
                                  8,
                                ), // square feel
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                controller.isFollowing.value
                                    ? 'Following'
                                    : 'Follow',
                                style: TextStyle(
                                  color: Colors.blue.shade800,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "About",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _showShareOptions(context, company),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.share,
                                  size: 18,
                                  color: Colors.blue.shade800,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "Share profile",
                                  style: TextStyle(
                                    color: Colors.blue.shade800,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    const SizedBox(height: 8),
                    Text(company.aboutUs),
                    const SizedBox(height: 34),
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
                    const SizedBox(height: 34),
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
    );
  }

  void _showShareOptions(BuildContext context, Company company) {
    // Generate the profile URL - adjust this to your actual URL structure
    final String profileUrl = "https://yourapp.com/company/${widget.slug}";
    final String shareText = "Check out ${company.cname} on our platform!";

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Share profile",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ShareButton(
                    imagePath: 'assets/icons/facebook.png',
                    label: "Facebook",
                    onTap: () async {
                      final url = Uri.parse(
                        "https://www.facebook.com/sharer/sharer.php?u=$profileUrl",
                      );
                      if (await canLaunchUrl(url)) {
                        await launchUrl(
                          url,
                          mode: LaunchMode.externalApplication,
                        );
                      }
                      Navigator.pop(context);
                    },
                  ),
                  _ShareButton(
                    imagePath: 'assets/icons/twitter.png',
                    label: "Twitter",
                    onTap: () async {
                      final url = Uri.parse(
                        "https://twitter.com/intent/tweet?text=$shareText&url=$profileUrl",
                      );
                      if (await canLaunchUrl(url)) {
                        await launchUrl(
                          url,
                          mode: LaunchMode.externalApplication,
                        );
                      }
                      Navigator.pop(context);
                    },
                  ),
                  _ShareButton(
                    imagePath: 'assets/icons/linkedin.png',
                    label: "LinkedIn",
                    onTap: () async {
                      final url = Uri.parse(
                        "https://www.linkedin.com/sharing/share-offsite/?url=$profileUrl",
                      );
                      if (await canLaunchUrl(url)) {
                        await launchUrl(
                          url,
                          mode: LaunchMode.externalApplication,
                        );
                      }
                      Navigator.pop(context);
                    },
                  ),
                  _ShareButton(
                    imagePath: 'assets/icons/telegram.png',
                    label: "Telegram",
                    onTap: () async {
                      final url = Uri.parse(
                        "https://t.me/share/url?url=$profileUrl&text=$shareText",
                      );
                      if (await canLaunchUrl(url)) {
                        await launchUrl(
                          url,
                          mode: LaunchMode.externalApplication,
                        );
                      }
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: profileUrl));
                  Get.snackbar(
                    "Copied!",
                    "Profile link copied to clipboard",
                    snackPosition: SnackPosition.BOTTOM,
                    duration: const Duration(seconds: 2),
                  );
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.copy),
                label: const Text("Copy link"),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}

// Share button widget
class _ShareButton extends StatelessWidget {
  final String imagePath;
  final String label;
  final VoidCallback onTap;

  const _ShareButton({
    required this.imagePath,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 66,
            height: 66,
            // decoration: BoxDecoration(
            //   color: Colors.white,
            //   shape: BoxShape.circle,
            //   border: Border.all(color: Colors.grey.shade300, width: 1),
            // ),
            padding: const EdgeInsets.all(12),
            child: ClipOval(
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.share, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
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
