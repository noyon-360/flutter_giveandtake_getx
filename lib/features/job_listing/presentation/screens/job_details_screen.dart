import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/theme/app_colors.dart';

class JobDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> jobData;

  const JobDetailsScreen({super.key, required this.jobData});

  @override
  Widget build(BuildContext context) {
    final raw = jobData['raw'] ?? {};
    final String? company = raw['companyId'] != null
        ? raw['companyId']['cname'] as String?
        : jobData['company'] as String?;
    final String? location =
        raw['location'] as String? ?? jobData['location'] as String?;
    final String? title =
        raw['title'] as String? ?? jobData['title'] as String?;
    final String applicants =
        raw['applicantsCount']?.toString() ?? 'Over 130 Applicants';
    final String? posted = jobData['timePosted'] as String?;
    final String? description = raw['description'] as String?;
    final String? experience = raw['experience'] as String?;
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
            // company logo and title
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primaryLightBlue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.business, color: AppColors.primaryBlue),
            ),
            const SizedBox(width: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
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
                        '$company',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // meta row
            Row(
              children: [
                Text(
                  location ?? '',
                  style: const TextStyle(color: AppColors.textGrey),
                ),
                // const SizedBox(width: 8),
                // const Text('•', style: TextStyle(color: AppColors.textGrey)),
                const SizedBox(width: 11),
                Text(
                  posted ?? '',
                  style: const TextStyle(color: AppColors.textGrey),
                ),
                const SizedBox(width: 11),
                Text(
                  applicants ?? '',
                  style: const TextStyle(color: AppColors.textGrey),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Easy Apply'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primaryBlue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(color: AppColors.primaryBlue),
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
            const SizedBox(height: 8),
            const Text(
              'Job Description',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              // description may contain HTML; for now render raw text
              description.toString().replaceAll(RegExp(r'<[^>]*>|\n'), '\n'),
              style: const TextStyle(color: AppColors.textBlack),
            ),

            const SizedBox(height: 20),

            // Job Overview card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
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
