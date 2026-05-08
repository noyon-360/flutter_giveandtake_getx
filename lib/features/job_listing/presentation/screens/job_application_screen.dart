import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giveandtake/core/theme/app_colors.dart';
import 'package:giveandtake/features/job_listing/presentation/controller/job_application_controller.dart';
import 'package:giveandtake/features/job_listing/presentation/widgets/custom_question_field.dart';
import 'package:giveandtake/features/job_listing/presentation/widgets/resume_upload_section.dart';
import 'package:giveandtake/features/job_listing/presentation/widgets/user_profile_header.dart';

class JobApplicationScreen extends StatelessWidget {
  final Map<String, dynamic> jobData;

  const JobApplicationScreen({super.key, required this.jobData});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      JobApplicationController(
        getUserProfileUseCase: Get.find(),
        submitJobApplicationUseCase: Get.find(),
        getJobDetailsUseCase: Get.find(),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('========== JOB APPLICATION SCREEN DATA ==========');
      print('JobData: $jobData');
      print('JobData _id: ${jobData['_id']}');
      print('JobData id: ${jobData['id']}');
      print('================================================');

      // Store jobData in controller for use after successful submission
      controller.jobData.value = jobData;

      // Always fetch fresh job details to get latest custom questions
      final jobId =
          jobData['_id']?.toString() ?? jobData['id']?.toString() ?? '';
      if (jobId.isNotEmpty) {
        controller.fetchJobDetails(jobId);
      }

      // Fallback to passed data if available immediately (optional, but good for UI responsiveness before API returns)
      final questions = jobData['customQuestion'] as List<dynamic>? ?? [];
      if (controller.customQuestions.isEmpty && questions.isNotEmpty) {
        controller.initQuestions(questions);
      }
    });

    return Scaffold(
      appBar: AppBar(
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
            Obx(
              () => UserProfileHeader(
                userProfile: controller.userProfile.value,
                isLoading: controller.isLoadingProfile.value,
              ),
            ),

            const SizedBox(height: 16),

            // Custom Questions Section
            Obx(() {
              if (controller.customQuestions.isEmpty) {
                return const SizedBox.shrink();
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Custom Questions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textBlack,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...controller.customQuestions.map((q) {
                    final id = q['_id'] ?? q['id'] ?? q['question'] ?? '';
                    final questionText = q['question'] ?? 'Question';
                    final textCtrl =
                        controller.answerControllers[id.toString()];

                    if (textCtrl == null) return const SizedBox.shrink();

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: CustomQuestionField(
                        label: '$questionText *',
                        hintText: 'Enter your answer here',
                        controller: textCtrl,
                      ),
                    );
                  }).toList(),
                  const Divider(),
                  const SizedBox(height: 16),
                ],
              );
            }),
            const SizedBox(height: 16),

            Obx(() {
              if (!controller.shouldAskVisa) {
                return const SizedBox.shrink();
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.isVisaRequired
                        ? 'Have you got a valid visa for this location? *'
                        : 'Have you got a valid visa for this location?',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  RadioListTile<String>(
                    value: 'Yes',
                    groupValue: controller.visaOption.value,
                    title: const Text('Yes'),
                    contentPadding: EdgeInsets.zero,
                    onChanged: (value) =>
                        controller.visaOption.value = value ?? '',
                  ),
                  RadioListTile<String>(
                    value: 'No',
                    groupValue: controller.visaOption.value,
                    title: const Text('No'),
                    contentPadding: EdgeInsets.zero,
                    onChanged: (value) =>
                        controller.visaOption.value = value ?? '',
                  ),
                  const Divider(),
                  const SizedBox(height: 16),
                ],
              );
            }),

            // Resume Upload Section
            Obx(
              () => ResumeUploadSection(
                selectedResume: controller.selectedResume.value,
                existingResumeId: controller.existingResumeId,
                onUpload: controller.pickResume,
                onRemove: controller.removeResume,
                onDownload: controller.downloadFile,
                isLoading: controller.isPickingResume.value,
              ),
            ),
            const SizedBox(height: 16),

            // Agreement Checkbox
            Obx(
              () => CheckboxListTile(
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
              ),
            ),
            const SizedBox(height: 24),

            // Submit Button
            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: controller.isSubmittingApplication.value
                      ? null
                      : () {
                          final jobId =
                              jobData['_id']?.toString() ??
                              jobData['id']?.toString() ??
                              '';
                          final resumeId = jobData['resumeId']?.toString();
                          controller.submitApplication(
                            jobId,
                            resumeId: resumeId,
                          );
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
              ),
            ),
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
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            jobData['companyName'] ?? 'Company Name',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                jobData['location'] ?? 'Location',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
