import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/theme/app_colors.dart';
import '../controller/job_listing_controller.dart';
import '../widgets/job_card.dart';
import '../widgets/job_filter_chip.dart';

class JobListingScreen extends StatelessWidget {
  const JobListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final JobListingController controller = Get.put(JobListingController());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
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
          // Search bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Search TextField
                TextField(
                  onChanged: controller.updateSearchQuery,
                  decoration: InputDecoration(
                    hintText: 'Job Title, Keywords, or Company',
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textGrey,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.textGrey,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Location dropdown
                Obx(
                  () => Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: AppColors.textGrey,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: controller.selectedLocation.value,
                              isExpanded: true,
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: AppColors.textGrey,
                              ),
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textBlack,
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: 'United States',
                                  child: Text('United States'),
                                ),
                                DropdownMenuItem(
                                  value: 'Canada',
                                  child: Text('Canada'),
                                ),
                                DropdownMenuItem(
                                  value: 'United Kingdom',
                                  child: Text('United Kingdom'),
                                ),
                                DropdownMenuItem(
                                  value: 'All Locations',
                                  child: Text('All Locations'),
                                ),
                              ],
                              onChanged: (value) {
                                if (value != null) {
                                  controller.updateLocation(value);
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Filter chips
          Obx(
            () => JobFiltersRow(
              selectedFilters: controller.selectedFilters.toList(),
              onFilterToggle: controller.toggleFilter,
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
                    onTap: () => controller.onJobTap(job),
                    onEasyApply: () => controller.onEasyApply(job),
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
