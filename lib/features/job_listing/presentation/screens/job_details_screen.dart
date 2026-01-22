import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:giveandtake/core/theme/app_colors.dart';
import 'package:giveandtake/features/job_listing/presentation/screens/bookmark_jobs_screen.dart';

import '../controllers/bookmark_controller.dart';
import '../controllers/job_details_controller.dart';

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Back to Job',
          style: TextStyle(
            color: AppColors.textBlack,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ================== TOP BANNER ==================
            Container(
              height: 250,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/allJobs.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                color: Colors.black.withOpacity(0.6), // Dark overlay
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 40,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    const Text(
                      'Browse Jobs',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Browse our curated job openings across industries and locations. Use smart filters to find roles that match your skills, experience, and career goals—your next opportunity starts here.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        height: 1,
                      ),
                    ),
                    // Breadcrumbs
                  ],
                ),
              ),
            ),

            // ================== MAIN CONTENT ==================
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 24.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back Button

                  // Job Header (Logo + Title + Info)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  30,
                                ), // Circular logo
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: logoUrl != null && logoUrl.isNotEmpty
                                    ? Image.network(
                                        logoUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder: (c, e, s) => const Icon(
                                          Icons.business,
                                          color: AppColors.primaryBlue,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.business,
                                        color: AppColors.primaryBlue,
                                      ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title ?? 'Unknown Title',
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                        company ?? 'Unknown Company',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      if (location != null &&
                                          location.isNotEmpty) ...[
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0,
                                          ),
                                          child: Icon(
                                            Icons.location_on,
                                            size: 14,
                                            color: Colors.blue.shade700,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            location,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey.shade600,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Tags (Full Time etc)
                        Wrap(
                          spacing: 8,
                          children: [
                            if (employmentType != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFFE0E7FF,
                                  ), // Light blue bg
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  employmentType,
                                  style: const TextStyle(
                                    color: Color(0xFF3730A3), // Dark blue text
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Job Description
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Job Description',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Html(
                          data: description ?? '',
                          style: {
                            "body": Style(
                              fontSize: FontSize(14),
                              color: Colors.grey.shade800,
                              lineHeight: LineHeight(1.6),
                              margin: Margins.zero,
                              padding: HtmlPaddings.zero,
                            ),
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Buttons
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: OutlinedButton(
                            onPressed: () async {
                              final bookmarkCtl =
                                  Get.isRegistered<BookmarkController>()
                                  ? Get.find<BookmarkController>()
                                  : Get.put(
                                      BookmarkController(),
                                      permanent: true,
                                    );

                              Get.dialog(
                                const Center(
                                  child: CircularProgressIndicator(),
                                ),
                                barrierDismissible: false,
                              );
                              final success = await bookmarkCtl.addJob(jobData);
                              Get.back();

                              if (success) {
                                Get.snackbar(
                                  'Saved',
                                  'Job bookmarked successfully',
                                );
                                Get.to(() => BookmarkJobsScreen());
                              } else {
                                Get.snackbar('Failed', 'Could not save job');
                              }
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.grey.shade300),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Save Job',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              // Initialize controller
                              final controller = Get.put(
                                JobDetailsController(),
                              );

                              // Prepare data for JobApplicationScreen which expects specific keys
                              final jobId =
                                  raw['_id'] ??
                                  jobData['_id'] ??
                                  jobData['id'] ??
                                  '';
                              final applicationData = {
                                '_id': jobId, // Use _id as the primary key
                                'id':
                                    jobId, // Also include id for backward compatibility
                                'jobTitle': title,
                                'companyName': company,
                                'location': location,
                                'customQuestion':
                                    raw['customQuestion'] ??
                                    [], // Include custom questions
                                'raw':
                                    raw, // Include raw data for complete job info
                                ...jobData, // Include original data as fallback
                              };

                              controller.checkResumeAndApply(applicationData);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(
                                0xFF2563EB,
                              ), // Primary Blue
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Apply Now',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Job Overview
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Job Overview',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildOverviewRow('Experience', experience),
                        _buildOverviewRow('Positions', positions),
                        _buildOverviewRow('Application Published', posted),
                        _buildOverviewRow(
                          'Location Type',
                          raw['location_Type'] as String?,
                        ), // Assuming field exists or generic
                        _buildOverviewRow('Status', status, isStatus: true),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Application Requirements
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Application Requirements',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (applicationRequirements.isEmpty)
                          const Text(
                            "No specific requirements.",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ...applicationRequirements.map(
                          (req) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(top: 6.0),
                                  child: Icon(
                                    Icons.circle,
                                    size: 6,
                                    color: Colors.red,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    req['requirement'] ?? req.toString(),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade700,
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

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewRow(
    String label,
    String? value, {
    bool isStatus = false,
  }) {
    // If value is null, use placeholder or skip? Screenshot shows labels always.
    final displayValue = value ?? '-';

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (isStatus)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                displayValue,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          else
            Text(
              displayValue,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }
}
