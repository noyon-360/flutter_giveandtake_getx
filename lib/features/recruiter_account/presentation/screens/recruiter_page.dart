import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/common/widgets/app_scaffold.dart';
import 'package:karlfive/features/recruiter_account/presentation/controller/recruiter_controller.dart';
import 'package:karlfive/features/recruiter_account/presentation/screens/applicants_list_screen.dart';
import 'package:karlfive/features/recruiter_account/presentation/screens/archieve_job_view.dart';
import 'package:karlfive/features/recruiter_account/presentation/screens/archive_job.dart';
import 'package:karlfive/features/recruiter_account/presentation/screens/edit_profile_page.dart';
import 'package:karlfive/features/recruiter_account/presentation/screens/post_job_screen.dart';
import 'package:karlfive/features/recruiter_account/presentation/screens/public_view_screen.dart';
import 'package:karlfive/features/recruiter_account/presentation/widgets/connect_with_company_dialog.dart';
import 'package:karlfive/features/recruiter_account/presentation/widgets/elevator_pitch.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../create_job/presentation/screen/create_job_screen.dart';
import '../widgets/social_media.dart';

class RecruiterPageScreen extends StatefulWidget {
  const RecruiterPageScreen({super.key});

  @override
  State<RecruiterPageScreen> createState() => _RecruiterPageScreenState();
}

class _RecruiterPageScreenState extends State<RecruiterPageScreen> {
  final RecruiterController recruiterController = Get.find<RecruiterController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await recruiterController.fetchProfile();
      await recruiterController.getJob();   // <-- ADD THIS LINE
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
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
                SizedBox(
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

                      // Edit Button
                      Positioned(
                        right: 10,
                        bottom: 30,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2B7FD0),
                          ),
                          onPressed: () {
                            Get.to(() => EditProfilePage(recruiterResponseModel: user,));
                          },
                          icon: const Icon(Icons.edit, size: 15, color: Colors.white),
                          label: const Text(
                            'Edit Profile',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

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
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
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
                      user.bio,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF898989),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ----- Social Media -----
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: (user.sLink)
                      .map((link) => GestureDetector(
                    onTap: () async {
                      final Uri url = Uri.parse(link.url ?? '');
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url, mode: LaunchMode.externalApplication);
                      } else {
                        Get.snackbar('Error', 'Could not open ${link.url}');
                      }
                    },
                    child: SocialMedia(image: _getSocialIcon(link.label)),
                  ))
                      .toList(),
                ),

                const SizedBox(height: 20),

                // ----- Buttons -----
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Try It Free — Post Your First Job at No Cost!',
                      style: TextStyle(fontSize: 17),
                    ),
                    const SizedBox(height: 20),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Get.dialog(ConnectCompanyDialog());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2B7FD0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Connect with a Company',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          const SizedBox(width: 20),

                          ElevatedButton(
                            onPressed: () {
                              Get.to(PublicViewScreen());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2B7FD0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Public View',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: () {
                              Get.to(() => CreateJobScreen());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2B7FD0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Post A Job',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),

                Divider(color: Color(0xFF999999),),

                SizedBox(height: 20,),
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
                    height: 160,
                    width: double.infinity,
                    child: ElevatorPitchSection(
                      videoUrl: user.elevatorPitch?.video.hlsUrl,
                      httpHeaders: {
                        'Accept': '*/*',
                        'Accept-Encoding': 'identity',

                        "Authorization": "Bearer ${user.elevatorPitch?.video.encryptionKeyUrl}",
                        "Custom-Header": "value",
                      },
                    ),
                  ),
                ),

                // here make me your job list that fetched from backend and will show like listview
                // Inside your Column in RecruiterPageScreen, after ElevatorPitchSection
                const SizedBox(height: 20),

                Obx(() {
                  if (recruiterController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final jobs = recruiterController.yourJobList;

                  if (jobs.isEmpty) {
                    return const Center(child: Text("No jobs posted yet."));
                  }

                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF999999), width: 1),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        // Header Row
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                          ),
                          child: Row(
                            children: const [
                              Expanded(flex: 2, child: Text("Job Title", style: TextStyle(fontWeight: FontWeight.bold))),
                              Expanded(flex: 1, child: Text("Status", style: TextStyle(fontWeight: FontWeight.bold))),
                              Expanded(flex: 1, child: Text("Ordered", style: TextStyle(fontWeight: FontWeight.bold))),
                              Expanded(flex: 1, child: Text("Published", style: TextStyle(fontWeight: FontWeight.bold))),
                              Expanded(flex: 1, child: Text("Expiry", style: TextStyle(fontWeight: FontWeight.bold))),
                              Expanded(flex: 1, child: Text("Applicants", style: TextStyle(fontWeight: FontWeight.bold))),
                              Expanded(flex: 1, child: Text("Actions", style: TextStyle(fontWeight: FontWeight.bold))),
                            ],
                          ),
                        ),
                        const Divider(height: 1, color: Colors.grey),

                        // Job Rows
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: jobs.length,
                          separatorBuilder: (_, __) => const Divider(height: 1, color: Colors.grey),
                            itemBuilder: (context, index) {
                              final job = jobs[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                child: SingleChildScrollView(   // <-- Make row scrollable
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 150,  // optional fixed width for Job Title
                                        child: Text(job.title.toString()),
                                      ),
                                      SizedBox(
                                        width: 80,
                                        child: Text(job.status ?? ""),
                                      ),
                                      SizedBox(
                                        width: 100,
                                        child: Text(job.createdAt.toString()),
                                      ),
                                      SizedBox(
                                        width: 100,
                                        child: Text(job.publishDate.toString()),
                                      ),
                                      SizedBox(
                                        width: 100,
                                        child: Text(job.deadline.toString()),
                                      ),
                                      SizedBox(
                                        width: 100,
                                        child: GestureDetector(
                                          onTap: () {
                                            Get.to(() => ApplicantsListScreen(jobId: job.id));
                                          },
                                          child: Text(
                                            "View (${job.applicantCount})",
                                            style: const TextStyle(color: Colors.blue),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 140,
                                        child: Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.remove_red_eye, color: Colors.black),
                                              onPressed: () {
                                                Get.to(() => ArchieveJobView(jobId: job.id));
                                              },
                                            ),
                                            const SizedBox(width: 8),
                                            ElevatedButton(
                                              onPressed: () {
                                                job.arcrivedJob; // Implement archive logic
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.green.shade100,
                                                foregroundColor: Colors.green.shade800,
                                                minimumSize: const Size(60, 30),
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                                              ),
                                              child: const Text("Archive", style: TextStyle(fontSize: 12)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                        ),
                      ],
                    ),
                  );
                }),
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
