import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/theme/app_colors.dart';
import 'package:karlfive/features/job_listing/presentation/controller/job_application_controller.dart';
import 'package:karlfive/features/job_listing/presentation/widgets/custom_question_field.dart';
import 'package:karlfive/features/job_listing/presentation/widgets/resume_upload_section.dart';
import 'package:karlfive/features/job_listing/presentation/widgets/user_profile_header.dart';

class JobApplicationScreen extends StatelessWidget {
  final Map<String, dynamic> jobData;

  const JobApplicationScreen({super.key, required this.jobData});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(JobApplicationController(
      getUserProfileUseCase: Get.find(),
      submitJobApplicationUseCase: Get.find(),
    ));

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.textBlack),
        title: const Text(
          'Job Application',
          style: TextStyle(
            color: AppColors.textBlack,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Header
            Obx(() => UserProfileHeader(
                  userProfile: controller.userProfile.value,
                  isLoading: controller.isLoadingProfile.value,
                )),
            const SizedBox(height: 24),

            // Custom Questions
            CustomQuestionField(
              label: 'What is your expected salary?',
              hintText: 'Enter your answer here.',
              controller: controller.pitchController,
            ),
            const SizedBox(height: 16),

            // Resume Upload Section
            Obx(() => ResumeUploadSection(
                  selectedResume: controller.selectedResume.value,
                  onUpload: controller.pickResume,
                  onRemove: controller.removeResume,
                  onDownload: controller.downloadFile,
                )),
            const SizedBox(height: 16),

            // Agreement Checkbox
            Obx(() => CheckboxListTile(
                  title: const Text(
                    'I agree with my video pitch being shared with the recruiter',
                    style: TextStyle(fontSize: 14),
                  ),
                  value: controller.agreeToShareCV.value,
                  onChanged: (value) {
                    controller.agreeToShareCV.value = value ?? true;
                  },
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                )),
            const SizedBox(height: 24),

            // Submit Button
            Obx(() => SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: controller.isSubmittingApplication.value
                        ? null
                        : () {
                            final jobId = jobData['id']?.toString() ?? '';
                            controller.submitApplication(jobId);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: controller.isSubmittingApplication.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Submit Application',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildJobInfoSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            jobData['jobTitle'] ?? 'Job Title',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            jobData['companyName'] ?? 'Company Name',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                jobData['location'] ?? 'Location',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
