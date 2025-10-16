import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/theme/app_colors.dart';
import 'package:karlfive/features/job_listing/presentation/screens/job_application_screen.dart';
import 'package:karlfive/features/job_listing/presentation/screens/bookmark_jobs_screen.dart';
import '../controllers/bookmark_controller.dart';

class JobDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> jobData;

  const JobDetailsScreen({super.key, required this.jobData});

  @override
  Widget build(BuildContext context) {
    final raw = jobData['raw'] ?? {};

    // Check if job is from company or recruiter
    final bool isCompanyJob = raw['companyId'] != null;
    final bool isRecruiterJob = raw['recruiterId'] != null;

    // Get company name or recruiter name
    final String? company = isCompanyJob
        ? raw['companyId']['cname'] as String?
        : isRecruiterJob
        ? '${raw['recruiterId']['firstName'] ?? ''} ${raw['recruiterId']['sureName'] ?? ''}'
              .trim()
        : jobData['company'] as String?;

    // Get logo URL - clogo for company, photo for recruiter
    final String? logoUrl = isCompanyJob
        ? raw['companyId']['clogo'] as String?
        : isRecruiterJob
        ? raw['recruiterId']['photo'] as String?
        : null;

    final String? location =
        raw['location'] as String? ?? jobData['location'] as String?;
    final String? title =
        raw['title'] as String? ?? jobData['title'] as String?;
    final String? posted = jobData['timePosted'] as String?;
    final String? description = raw['description'] as String?;
    final String? experience = raw['experience'] as String?;
    final String? employmentType = raw['employement_Type'] as String?;
    final String? positions = raw['vacancy']?.toString();
    final String? compensation =
        (raw['compensation'] as String?) ??
        (raw['salaryRange'] as String?) ??
        jobData['salary'] as String?;
    final String? deadline = raw['deadline']?.toString().split('T').first;
    final String? status = raw['status'] as String?;
    final List<dynamic> applicationRequirements =
        (raw['applicationRequirement'] as List<dynamic>?) ?? [];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textBlack),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Job Details',
          style: TextStyle(color: AppColors.textBlack),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: logoUrl != null && logoUrl.isNotEmpty
                    ? Image.network(
                        logoUrl,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => const Icon(
                          Icons.business,
                          color: AppColors.primaryBlue,
                        ),
                      )
                    : const Icon(Icons.business, color: AppColors.primaryBlue),
              ),
            ),
            const SizedBox(width: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  " - For ",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  company ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // meta row: address and posted time share width, applicants at end
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    location ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppColors.textGrey),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: Text(
                    posted ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppColors.textGrey),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.primaryLightBlue),
                color: AppColors.primaryWhite,
              ),
              child: Text(
                employmentType ?? '',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textBlack,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to Job Application screen with the current job data
                      Get.to(() => JobApplicationScreen(jobData: jobData));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Easy Apply',
                      style: TextStyle(
                        color: AppColors.primaryWhite,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      final bookmarkCtl = Get.isRegistered<BookmarkController>()
                          ? Get.find<BookmarkController>()
                          : Get.put(BookmarkController(), permanent: true);
                      bookmarkCtl.addJob(jobData);
                      // Navigate to Bookmark Jobs screen
                      Get.to(() => BookmarkJobsScreen());
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primaryBlue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        color: AppColors.primaryBlue,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Text(
              'About The Job',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 15),
            const Text(
              'Job Description',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Html(
              data: description ?? '',
              style: {
                "body": Style(
                  color: AppColors.textBlack,
                  fontSize: FontSize(14),
                  margin: Margins.zero,
                  padding: HtmlPaddings.zero,
                ),
                "p": Style(margin: Margins.only(bottom: 8)),
              },
            ),

            const SizedBox(height: 20),

            // Job Overview card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.textGrey),
                color: AppColors.primaryWhite,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Job Overview',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Experience'),
                      Text(experience ?? ''),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [const Text('Positions'), Text(positions ?? '')],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Compensation'),
                      Text(compensation ?? ''),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Application Deadline'),
                      Text(deadline ?? ''),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [const Text('Status'), Text(status ?? '')],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              'Application Requirements',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            ...applicationRequirements.map(
              (req) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(req['requirement'] ?? req.toString()),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
