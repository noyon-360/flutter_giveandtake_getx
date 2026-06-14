import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giveandtake/core/network/api_client.dart';
import 'package:giveandtake/core/theme/app_colors.dart';
import 'package:giveandtake/features/company/presentation/screen/public_view_seach_screen.dart';

import '../../../Home/presentation/screen/home_screen.dart';
import '../../data/repo/job_listing_repository_impl.dart';
import '../../domain/repo/job_listing_repository.dart';
import '../../domain/usecases/get_jobs_usecase.dart';
import '../controller/all_jobs_controller.dart';
import '../controllers/job_details_controller.dart';
import '../../../recruiter_account/presentation/screens/recruiter_public_view.dart';
import '../widgets/job_card.dart';
import 'job_details_screen.dart';

class AllJobsScreen extends GetView<AllJobsController> {
  const AllJobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dependency Injection
    if (!Get.isRegistered<AllJobsController>()) {
      if (!Get.isRegistered<JobListingRepository>()) {
        try {
          final apiClient = Get.find<ApiClient>();
          Get.put<JobListingRepository>(
            JobListingRepositoryImpl(apiClient: apiClient),
          );
        } catch (e) {
          // Fallback strategy if needed
        }
      }

      if (Get.isRegistered<JobListingRepository>() &&
          !Get.isRegistered<GetJobsUseCase>()) {
        Get.put(GetJobsUseCase(Get.find<JobListingRepository>()));
      }

      if (Get.isRegistered<GetJobsUseCase>()) {
        Get.put(AllJobsController(Get.find<GetJobsUseCase>()));
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: Color(0xFF2B7FD0),
        title: const Text(
          'Back to Drawer',
          style: TextStyle(
            color: AppColors.primaryWhite,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels >=
                  scrollInfo.metrics.maxScrollExtent -
                      200 && // Trigger slightly before bottom
              !controller.isMoreLoading.value &&
              !controller.isLoading.value) {
            controller.loadMore();
          }
          return false;
        },
        child: RefreshIndicator(
          onRefresh: () async {
            await controller.fetchJobs(isRefresh: true);
          },
          child: CustomScrollView(
            slivers: [
              // Header Sliver
              SliverToBoxAdapter(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/allJobs.jpeg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Browse Jobs",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Browse our curated job openings across industries and locations. Use smart filters to find roles that match your skills, experience, and career goals—your next opportunity starts here.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Breadcrumb
                      Row(
                        children: const [
                          Text(
                            "Home",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                            color: Colors.white70,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Browse Jobs",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Search Sliver
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F2F9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        TextField(
                          controller: controller.searchController,
                          onChanged: (val) => controller.searchText.value = val,
                          decoration: InputDecoration(
                            hintText: "Title, Skill, Category, Location...",
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 0,
                              horizontal: 16,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              controller.fetchJobs(isRefresh: true);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2E86DE),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              "Search",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Title Sliver
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: const Text(
                    "Recent jobs",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 10)),

              // Job List Sliver
              Obx(() {
                if (controller.isLoading.value) {
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                }

                if (controller.jobList.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Text(
                          controller.searchText.value.isNotEmpty
                              ? "No item available for this search"
                              : "No jobs found",
                        ),
                      ),
                    ),
                  );
                }

                final canApply = controller.canApply;
                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final job = controller.jobList[index];
                    final jobData = job.toDisplayMap();
                    return JobCard(
                      canApply: canApply,
                      title: job.title,
                      company:
                          jobData['company']?.toString() ?? "Unknown Company",
                      location: job.location,
                      duration: job.employementType,
                      salary: job.salaryRange,
                      timePosted: job.timePostedFormatted,
                      logoUrl: jobData['logoUrl'] as String?,
                      onCompanyTap: () {
                        final slug =
                            (jobData['postedBySlug'] ?? '').toString();
                        final type =
                            (jobData['postedByType'] ?? '').toString();

                        if (slug.isEmpty) {
                          Get.snackbar(
                            'Unavailable',
                            'This public profile is not available.',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                          return;
                        }

                        if (type == 'company') {
                          Get.to(() => PublicViewSeachScreen(slug: slug));
                          return;
                        }

                        Get.to(() => RecruiterPublicViewScreen(slug: slug));
                      },
                      onTap: () {
                        Get.to(
                          () => JobDetailsScreen(jobData: jobData),
                        );
                      },
                      onEasyApply: () {
                        // Initialize JobDetailsController
                        final jobDetailsController = Get.put(
                          JobDetailsController(),
                        );

                        // Prepare complete job data for JobApplicationScreen
                        final jobId = job.id;
                        final companyName =
                            job.companyId?.cname ??
                            job.recruiterId?.fullName ??
                            "Unknown Company";

                        final applicationData = {
                          '_id': jobId,
                          'id': jobId,
                          'jobTitle': job.title,
                          'companyName': companyName,
                          'location': job.location,
                          'customQuestion': job.customQuestion
                              .map((e) => e.toJson())
                              .toList(),
                          'raw': job.toJson(),
                        };

                        // Call the same method used by Job Details screen
                        jobDetailsController.checkResumeAndApply(
                          applicationData,
                        );
                      },
                    );
                  }, childCount: controller.jobList.length),
                );
              }),

              // Load More Indicator Sliver
              Obx(() {
                if (controller.isMoreLoading.value) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  );
                }
                return const SliverToBoxAdapter(child: SizedBox(height: 20));
              }),
            ],
          ),
        ),
      ),
    );
  }
}
