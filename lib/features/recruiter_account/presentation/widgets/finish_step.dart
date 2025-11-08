import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/features/recruiter_account/presentation/controller/country_city_controller.dart';
import '../controller/job_controller/career_stage_controller.dart';
import '../controller/job_controller/employment_type_controller.dart';
import '../controller/job_controller/experience_level_controller.dart';
import '../controller/job_controller/job_posting_expiration_controller.dart';
import '../controller/job_controller/location_type_controller.dart';
import '../controller/job_posting_controller.dart';
import '../controller/recruiter_controller.dart';
import '../screens/job_preview_screen.dart';

class FinishStep extends StatelessWidget {
  const FinishStep({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<JobPostingController>();
    final locationController = Get.find<LocationController>();
    final RecruiterController recruiterController = Get.find<
        RecruiterController>();

    final EmploymentTypeController employmentTypeController =
    Get.find<EmploymentTypeController>();
    final ExperienceLevelController experienceController =
    Get.find<ExperienceLevelController>();
    final LocationTypeController locationTypeController =
    Get.find<LocationTypeController>();
    final CareerStageController careerStageController =
    Get.find<CareerStageController>();
    final JobPostingExpirationController jobPostingExpirationController =
    Get.find<JobPostingExpirationController>();

    _submit() {
      recruiterController.createJobPost(
          controller.jobTitle.value,
          controller.jobDescriptionPlain.value,
          locationController.selectedCountry.toString(),
          controller.vacanciesInt,
          experienceController.selectedExperienceLevel.value,
          //here i have to send two thing that is job publish date and the job expiration date
          jobPostingExpirationController.selectedJobPostingExpiration.value,
          //here have to pass country and city together
          '${locationController.selectedCity.value ?? ''}, ${locationController.selectedCountry.value ?? ''}',
          controller.selectedCategory.value,
          controller.selectedRole.value,
          controller.compensation.value,
          //here add this two field
          controller.applicationRequirement,
          controller.customQuestions,
          employmentTypeController.getBackendValue(
            employmentTypeController.selectedEmploymentType.value,
          ),
          controller.companyWebsite.value,
          controller.selectedDate.value.toString(),
          careerStageController.selectedCareerStage.value,
          locationTypeController.getBackendValue(locationTypeController.selectedLocationType.value),
          );}

      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Your job posting is ready!",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Buttons Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Preview Button
                OutlinedButton(
                  onPressed: () {
                    Get.to(() => JobPreviewScreen());
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                        color: Color(0xFF2B7FD0), width: 1.5),
                    minimumSize: const Size(160, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Preview Your Post",
                    style: TextStyle(
                      color: Color(0xFF2B7FD0),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Publish Button
                ElevatedButton(
                  onPressed: () {
                    _submit();
                    Get.snackbar(
                      "Success",
                      "Job post published successfully!",
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2B7FD0),
                    minimumSize: const Size(160, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Publish Your Post",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30,)
          ],
        ),
      );
    }
  }
