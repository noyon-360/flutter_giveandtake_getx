import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/services/get_user_profile_service.dart';
import 'package:karlfive/core/theme/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../job_listing/presentation/screens/job_listing_screen.dart';
import '../controllers/home_controller.dart';
import '../widgets/app_drawer.dart';
import '../widgets/custom_searchbox.dart';
import '../widgets/home_main_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GetUserProfileService _profileService = Get.find();
  final HomeController _homeController = Get.find();

  @override
  void initState() {
    super.initState();
    // User profile is already fetched during login and stored in GetUserProfileService
    // No need to call API again here
  }

  // Helper method to launch email
  Future<void> _launchEmail(String email) async {
    // Prefer opening Gmail web compose (works on devices without native mail client)
    final String encodedTo = Uri.encodeComponent(email);
    final Uri gmailWeb = Uri.parse(
      'https://mail.google.com/mail/?view=cm&fs=1&to=$encodedTo',
    );
    final Uri mailUri = Uri.parse('mailto:$email');

    try {
      // 1) Try Gmail web compose in external browser
      if (await canLaunchUrl(gmailWeb)) {
        await launchUrl(gmailWeb, mode: LaunchMode.externalApplication);
        return;
      }

      // 2) Fallback to native mail client via mailto
      if (await canLaunchUrl(mailUri)) {
        await launchUrl(mailUri, mode: LaunchMode.externalApplication);
        return;
      }

      // 3) Final fallback: copy email to clipboard and notify user
      await Clipboard.setData(ClipboardData(text: email));
      Get.snackbar(
        'Email copied',
        'Email address copied to clipboard: $email',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      // On any exception, copy to clipboard and notify
      await Clipboard.setData(ClipboardData(text: email));
      Get.snackbar(
        'Email copied',
        'Email address copied to clipboard: $email',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Helper method to launch phone dialer
  Future<void> _launchPhone(String phoneNumber) async {
    final Uri phoneUri = Uri.parse('tel:$phoneNumber');
    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          'Error',
          'Could not open phone dialer',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not open phone dialer: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: Color(0xffF5F6FF),
        iconTheme: IconThemeData(color: AppColors.textBlack),
        centerTitle: true,
        title: Image.asset(
          "assets/images/logo_transparent.png",
          height: 40,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Reactive greeting using profile service
                    Obx(() {
                      final user = _profileService.userInfoRx.value;
                      final displayName = (user != null && user.name.isNotEmpty)
                          ? user.name
                          : 'Guest';

                      return Text(
                        "Hello $displayName",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textBlack,
                          fontWeight: FontWeight.w400,
                        ),
                      );
                    }),
                    Text(
                      "Find your Dream Job",
                      style: TextStyle(
                        fontSize: 20,
                        color: AppColors.textBlack,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: CustomSearchBox(
                              hintText:
                                  "Search by job title, keywords, company or country",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                // height: MediaQuery.of(context).size.height * 0.02,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "How It Works",
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.textBlack,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Obx(() {
                      final candidate = _homeController.candidateContent.value;
                      return HomeMainCard(
                        iconPath: "assets/icons/add-user_home.png",
                        title: candidate?.title ?? "Candidates",
                        subtitle: candidate?.description,
                        isHtml: candidate != null,
                        onTap: () {
                          //TODO: Navigate to create account screen
                        },
                      );
                    }),
                    const SizedBox(height: 16),

                    Obx(() {
                      final recruiter = _homeController.recruiterContent.value;
                      return HomeMainCard(
                        iconPath: "assets/icons/home_job_find.png",
                        title: recruiter?.title ?? "Recruiters",
                        subtitle: recruiter?.description,
                        isHtml: recruiter != null,
                        onTap: () {
                          Get.to(() => const JobListingScreen());
                        },
                      );
                    }),
                    const SizedBox(height: 16),
                    Obx(() {
                      final company = _homeController.companyContent.value;
                      return HomeMainCard(
                        iconPath: "assets/icons/get_job.png",
                        title: company?.title ?? "Companies",
                        subtitle: company?.description ,
                        isHtml: company != null,
                        onTap: () {
                          //TODO: Navigate to get a job screen
                        },
                      );
                    }),

                    const SizedBox(height: 10),

                    SizedBox(height: 1, width: double.infinity),

                    // Footer Container
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2B7BC9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Logo and Title
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Image.asset(
                                  'assets/images/app_logo_blue.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'EVP',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                  Text(
                                    'ELEVATOR\nVIDEO PITCH',
                                    style: TextStyle(
                                      fontSize: 8,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      height: 1.2,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Tagline
                          Text(
                            'Connecting talent with opportunities and businesses\nwith clients all in one pitch!',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white,
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),

                          // Address
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '124 City Road, London EC1V 2NX',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Email (Clickable)
                          InkWell(
                            onTap: () => _launchEmail('info@evpitch.com'),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.email,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'info@evpitch.com',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.white,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Phone (Clickable)
                          InkWell(
                            onTap: () => _launchPhone('+442039542530'),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.phone,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '+44 0203 954 2530',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.white,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            )
            ],
          ),
        ),
      ),
    );
  }
}
