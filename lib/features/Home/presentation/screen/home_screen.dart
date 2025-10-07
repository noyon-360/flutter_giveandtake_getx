import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/theme/app_colors.dart';
import '../../../job_listing/presentation/screens/job_listing_screen.dart';
import '../widgets/app_drawer.dart';
import '../widgets/custom_searchbox.dart';
import '../widgets/home_main_card.dart';
import '../widgets/search_filter_iconcard.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                    Text(
                      "Hello Mr. Saifullah",
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textBlack,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
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
                            child: CustomSearchBox(hintText: "Search your job"),
                          ),
                        ),
                        const SizedBox(width: 10),
                        SearchFilterIconCard(
                          iconPath: "assets/icons/home_search_location.png",
                          onTap: () {},
                        ),
                        const SizedBox(width: 8),
                        SearchFilterIconCard(
                          iconPath: "assets/icons/home_filter_search.png",
                          onTap: () {},
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
