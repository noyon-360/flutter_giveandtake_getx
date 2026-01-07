import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/common/widgets/app_scaffold.dart';
import 'package:karlfive/features/recruiter_account/presentation/controller/recruiter_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../create_job/presentation/screen/create_job_screen.dart';
import '../widgets/social_media.dart';

class PublicViewScreen extends StatefulWidget {
  const PublicViewScreen({super.key});

  @override
  State<PublicViewScreen> createState() => _PublicViewScreenState();
}

class _PublicViewScreenState extends State<PublicViewScreen> {
  final RecruiterController recruiterController = Get.find<RecruiterController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      recruiterController.fetchProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: Text('Public view', style: TextStyle(color: Colors.white),),
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

                SizedBox(height: 20,),
                
                ElevatedButton(onPressed: (){}, style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2B7FD0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ), child: Text('Follow', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),

                const SizedBox(height: 20),
                
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
