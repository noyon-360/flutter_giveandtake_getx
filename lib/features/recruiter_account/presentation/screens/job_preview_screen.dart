import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:giveandtake/features/recruiter_account/presentation/controller/country_city_controller.dart';
import 'package:giveandtake/features/recruiter_account/presentation/controller/job_controller/career_stage_controller.dart';
import 'package:giveandtake/features/recruiter_account/presentation/controller/job_controller/employment_type_controller.dart';
import 'package:giveandtake/features/recruiter_account/presentation/controller/job_controller/experience_level_controller.dart';
import 'package:giveandtake/features/recruiter_account/presentation/controller/job_controller/job_posting_expiration_controller.dart';
import 'package:giveandtake/features/recruiter_account/presentation/controller/job_controller/location_type_controller.dart';
import 'package:table_calendar/table_calendar.dart';
import '../controller/job_posting_controller.dart';
import '../controller/recruiter_controller.dart';

class JobPreviewScreen extends StatelessWidget {
  final controller = Get.find<JobPostingController>();
  final LocationController locationController = Get.find<LocationController>();
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

  final RecruiterController recruiterController =
      Get.find<RecruiterController>();

  late int vacanciesInt = int.tryParse(controller.vacancies.value) ?? 0;

  // Find category by name
  late final selectedCategoryModel = recruiterController.category
      .firstWhereOrNull((c) => c.name == controller.selectedCategory.value);

  // Extract category ID (or empty if null)
  late final categoryId = selectedCategoryModel?.id ?? '';

  Future<void> _submit() async {
    recruiterController.createJobPost(
      controller.jobTitle.value,
      controller.jobDescriptionPlain.value,
        '${locationController.selectedCity.value ?? ''}, ${locationController.selectedCountry.value ?? ''}',
        controller.vacanciesInt,
        experienceController.selectedExperienceLevel.value,
      jobPostingExpirationController.selectedJobPostingExpiration.value,
      categoryId,
      controller.selectedCategory.value,
      controller.selectedRole.value,
      controller.compensation.value,
      controller.applicationRequirement,
      controller.customQuestions,
      employmentTypeController.getBackendValue(
        employmentTypeController.selectedEmploymentType.value,
      ),
      controller.companyWebsite.value,
      controller.selectedDate.value.toString(),
      careerStageController.selectedCareerStage.value,
      locationTypeController.getBackendValue(
        locationTypeController.selectedLocationType.value,
      ),
      controller.companyWebsite.value,
    );
  }

  JobPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Preview Job Posting',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.close_rounded, color: Colors.black),
          ),
        ],
      ),
      body: Obx(() {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------- JOB DETAILS ----------
              const Text(
                "Job Details",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              _previewBox("Job Category", controller.selectedCategory.value),
              _previewBox("Role", controller.selectedRole.value),
              _previewBox("Job Title", controller.jobTitle.value),
              _previewBox(
                "Country",
                locationController.selectedCountry.toString(),
              ),
              _previewBox("City", locationController.selectedCity.toString()),
              _previewBox('Number of Vacancies', controller.vacancies.value),
              _previewBox(
                "Employment Type",
                employmentTypeController.selectedEmploymentType.value,
              ),
              _previewBox(
                "Experience Level",
                experienceController.selectedExperienceLevel.value,
              ),
              _previewBox(
                "Location Type",
                locationTypeController.selectedLocationType.value,
              ),
              _previewBox(
                "Career Stage",
                careerStageController.selectedCareerStage.value,
              ),
              _previewBox(
                'Currency',
                "${controller.selectedCurrency.value?.currencyName ?? '—'} "
                    "(${controller.selectedCurrency.value?.symbol ?? ''})",
              ),

              _previewBox(
                "Compensation",
                "${controller.selectedCurrency.value?.symbol ?? ''} ${controller.compensation.value}",
              ),
              _previewBox(
                "Job Posting Expiration Date",
                jobPostingExpirationController
                    .selectedJobPostingExpiration
                    .value,
              ),
              _previewBox("Company Website", controller.companyWebsite.value),

              const SizedBox(height: 20),

              // ---------- JOB DESCRIPTION ----------
              const Text(
                "Job Description",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _descriptionBox(controller.jobDescriptionPlain.value),

              const SizedBox(height: 20),

              // Publish-now toggle removed from preview (per UX feedback); the
              // scheduled date is still shown when the post is not immediate.
              !controller.publishNow.value
                  ? _calendarSection(controller.selectedDate.value.toString())
                  : const SizedBox.shrink(),

              const SizedBox(height: 30),

              // ---------- CUSTOM QUESTIONS ----------
              const Text(
                "Application Requirements",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _previewBox('Resume', controller.resumeStatus.value),
              _previewBox(controller.visa, controller.visaStatus.value),

              const SizedBox(height: 20),

              // ---------- CUSTOM QUESTIONS ----------
              const Text(
                "Custom Questions",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _questionList(controller.customQuestion),

              const SizedBox(height: 40),

              // ---------- PUBLISH BUTTON ----------
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await _submit();
                    controller.clearAllFieldsPreview();
                    // Get.back();
                    Get.snackbar(
                      "Post Published",
                      "Your job post has been successfully published!",
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2B7FD0),
                    minimumSize: const Size(200, 50),
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
              ),
              const SizedBox(height: 60),
            ],
          ),
        );
      }),
    );
  }

  // ---------- Widget Builders ----------

  Widget _previewBox(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
              color: Colors.white,
            ),
            child: Text(
              value.isEmpty ? '—' : value,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _descriptionBox(String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        value.isNotEmpty ? value : "No job description added.",
        style: const TextStyle(
          fontSize: 15,
          color: Colors.black87,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _publishSwitch(bool publishNow) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Publish Now",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Switch(
            value: publishNow,
            onChanged: (_) {},
            activeColor: const Color(0xFF2B7FD0),
          ),
        ],
      ),
    );
  }

  Widget _calendarSection(String dateStr) {
    DateTime? selected;
    try {
      selected = DateTime.tryParse(dateStr);
    } catch (_) {}

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 20, color: Colors.black54),
              const SizedBox(width: 8),
              Text(
                selected != null
                    ? "Selected Date: ${selected.day}/${selected.month}/${selected.year}"
                    : "No date selected",
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ✅ Read-only calendar view
          AbsorbPointer(
            // disables all touch interactions
            child: TableCalendar(
              focusedDay: selected ?? DateTime.now(),
              firstDay: DateTime(2000),
              lastDay: DateTime(2100),
              selectedDayPredicate: (day) =>
                  selected != null && isSameDay(day, selected),
              availableGestures: AvailableGestures.none,
              // disable swipe
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                leftChevronVisible: false,
                // disable navigation arrows
                rightChevronVisible: false,
                titleTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              calendarStyle: CalendarStyle(
                selectedDecoration: const BoxDecoration(
                  color: Color(0xFF2B7FD0),
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Color(0xFF2B7FD0).withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                weekendTextStyle: const TextStyle(color: Colors.redAccent),
                defaultTextStyle: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _questionList(List<String> questions) {
    if (questions.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
          color: Colors.white,
        ),
        child: const Text(
          "No custom questions added.",
          style: TextStyle(fontSize: 15, color: Colors.black54),
        ),
      );
    }

    return Column(
      children: questions
          .map(
            (q) => Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
                color: Colors.white,
              ),
              child: Text(
                q,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                  height: 1.4,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
