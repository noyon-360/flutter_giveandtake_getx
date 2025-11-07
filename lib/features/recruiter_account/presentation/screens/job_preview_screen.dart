import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/features/recruiter_account/presentation/controller/country_city_controller.dart';
import 'package:karlfive/features/recruiter_account/presentation/controller/job_controller/career_stage_controller.dart';

import 'package:karlfive/features/recruiter_account/presentation/controller/job_controller/employment_type_controller.dart';
import 'package:karlfive/features/recruiter_account/presentation/controller/job_controller/experience_level_controller.dart';
import 'package:karlfive/features/recruiter_account/presentation/controller/job_controller/location_type_controller.dart';
import '../controller/job_posting_controller.dart';

class JobPreviewScreen extends StatelessWidget {
  final controller = Get.find<JobPostingController>();
  final LocationController locationController = Get.find<LocationController>();
  final EmploymentTypeController employmentTypeController = Get.find<EmploymentTypeController>();
  final ExperienceLevelController experienceController = Get.find<ExperienceLevelController>();
  final LocationTypeController locationTypeController = Get.find<LocationTypeController>();
  final CareerStageController careerStageController = Get.find<CareerStageController>();

  JobPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Job Preview',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _previewRow("Category", controller.selectedCategory.value),
              _previewRow("Role", controller.selectedRole.value),
              //access it from job details step screen
              _previewRow("Job Title", controller.jobTitle.value),
              //access it from job details step screen
              _previewRow("Department", controller.department.value),

              _previewRow("Country", locationController.selectedCountry.toString()),
              _previewRow("City", locationController.selectedCity.toString()),

              _previewRow("Number of Vacancies", controller.vacancies.value),
              _previewRow("Employment Type", employmentTypeController.selectedEmploymentType.value),
              _previewRow("Experience Level", experienceController.selectedExperienceLevel.value),
              _previewRow("Location Type", locationTypeController.selectedLocationType.value),
              _previewRow("Career Stage", careerStageController.selectedCareerStage.value),
              //_previewRow("Currency", controller.selectedCurrency.value!.currencyName.toString()),
              _previewRow(
                "Job Description",
                controller.jobDescriptionPlain.value,
                maxLines: 5,
              ),
              const Divider(),
              _previewRow(
                "Resume Required",
                controller.resumeRequired.value ? "Yes" : "No",
              ),
              _previewRow(
                "Valid Visa Required",
                controller.validVisaRequired.value ? "Yes" : "No",
              ),
              const Divider(),
              _previewRow(
                "Publish Type",
                controller.publishNow.value ? "Publish Now" : "Schedule",
              ),
              if (!controller.publishNow.value)
                _previewRow(
                  "Scheduled Date",
                  controller.selectedDate.value.toString(),
                ),
              const SizedBox(height: 30),

              // Publish Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    Get.snackbar(
                      "Post Published",
                      "Your job post has been successfully published!",
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2B7FD0),
                    minimumSize: const Size(180, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Publish Job",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          );
        }),
      ),
    );
  }

  Widget _previewRow(String label, String value, {int maxLines = 2}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value.isEmpty ? '—' : value,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
