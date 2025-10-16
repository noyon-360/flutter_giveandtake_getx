import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/theme/app_colors.dart';
import '../controller/job_listing_controller.dart';
import '../widgets/job_card.dart';
import 'job_application_screen.dart';

class JobListingScreen extends StatelessWidget {
  const JobListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final JobListingController controller =
        Get.isRegistered<JobListingController>()
        ? Get.find<JobListingController>()
        : Get.put(JobListingController(getJobsUseCase: Get.find()));

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Color(0xffF5F6FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textBlack),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'All Jobs',
          style: TextStyle(
            color: AppColors.textBlack,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Search bar (single field)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xffF5F6FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                // Search TextField
                TextField(
                  onChanged: controller.updateSearchQuery,
                  decoration: InputDecoration(
                    hintText:
                        'Search by job title, keywords, company or country',
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textGrey,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.textGrey,
                    ),
                    filled: true,
                    fillColor: AppColors.primaryWhite,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: AppColors.primaryLightBlue.withValues(
                          alpha: 0.3,
                        ),
                        width: 0.5,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Job list
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primaryBlue,
                    ),
                  ),
                );
              }

              final jobs = controller.filteredJobs;
              if (jobs.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.work_off, size: 64, color: AppColors.textGrey),
                      SizedBox(height: 16),
                      Text(
                        'No jobs found',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textGrey,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Try adjusting your search criteria',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textGrey,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.only(top: 8, bottom: 20),
                itemCount: jobs.length,
                itemBuilder: (context, index) {
                  final job = jobs[index];
                  return JobCard(
                    title: job['title'] ?? 'Unknown Title',
                    company: job['company'] ?? 'Unknown Company',
                    location: job['location'] ?? 'Unknown Location',
                    duration: job['duration'] ?? 'Unknown Duration',
                    salary: job['salary'] ?? 'Salary not specified',
                    timePosted: job['timePosted'] ?? 'Unknown',
                    logoUrl: job['logoUrl'] as String?,
                    onTap: () => controller.onJobTap(job),
                    onEasyApply: () =>
                        Get.to(() => JobApplicationScreen(jobData: job)),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
