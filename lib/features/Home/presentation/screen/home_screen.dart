import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/theme/app_colors.dart';
import 'package:karlfive/core/services/get_user_profile_service.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../job_listing/presentation/screens/job_listing_screen.dart';
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

  @override
  void initState() {
    super.initState();
    // Fetch user profile when home screen initializes
    _profileService.getUserProfile();
  }

  // Helper method to launch email
  Future<void> _launchEmail(String email) async {
    final Uri emailUri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      Get.snackbar(
        'Error',
        'Could not open email client',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Helper method to launch phone dialer
  Future<void> _launchPhone(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      Get.snackbar(
        'Error',
        'Could not open phone dialer',
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
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.notifications_active_outlined,
              color: AppColors.primaryWhite,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: AppColors.homeHeadBackground,
              height: MediaQuery.of(context).size.height * 0.16,
              width: double.infinity,
              child: Padding(
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
                        "How It Works in three simple steps",
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textBlack,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "1. Record or upload your video elevator pitch (60 seconds free or upgrade!)\n2. Add a link to your video elevator pitch in your CV/resume\n3. Search and apply for jobs on our site",
                      style: TextStyle(
                        fontSize: 9,
                        color: AppColors.textBlack,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    const SizedBox(height: 24),
                    HomeMainCard(
                      iconPath: "assets/icons/add-user_home.png",
                      title: "Create account",
                      subtitle:
                          "Build your profile, upload your CV and get\naccess to thousands of jobs",
                      onTap: () {
                        //TODO: Navigate to create account screen
                      },
                    ),
                    const SizedBox(height: 16),

                    HomeMainCard(
                      iconPath: "assets/icons/home_job_find.png",
                      title: "Explore our Jobs",
                      subtitle: "Explore thousands of our job listings.",
                      onTap: () {
                        Get.to(() => const JobListingScreen());
                      },
                    ),
                    const SizedBox(height: 16),
                    HomeMainCard(
                      iconPath: "assets/icons/get_job.png",
                      title: "Get a Job",
                      subtitle:
                          "Apply with ease, follow recruiters, and land your next opportunity.",
                      onTap: () {
                        //TODO: Navigate to get a job screen
                      },
                    ),

                    const SizedBox(height: 24),

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
                          const SizedBox(height: 16),

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
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
