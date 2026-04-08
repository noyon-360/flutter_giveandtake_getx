// lib/features/recruiter_account/presentation/controller/job_form_controller.dart

import 'package:get/get.dart';
import 'package:giveandtake/features/recruiter_account/data/models/get_single_job_response_model.dart';
import 'package:giveandtake/features/recruiter_account/data/models/get_currency_response_model.dart';

import '../../../create_job/data/model/category_model.dart';

class JobFormController extends GetxController {
  // All reactive form fields
  final RxString title = ''.obs;
  final RxString department = ''.obs;
  final RxString vacancy = '1'.obs;
  final RxString compensation = ''.obs;
  final RxString companyWebsite = ''.obs;
  final RxString jobDescriptionHtml = ''.obs;

  final RxString selectedCategory = ''.obs;
  final RxString selectedCategoryId = ''.obs;
  final RxString selectedRole = ''.obs;

  final RxString selectedEmploymentType = ''.obs;
  final RxString selectedExperienceLevel = ''.obs;
  final RxString selectedLocationType = ''.obs;
  final RxString selectedCareerStage = ''.obs;

  final RxString selectedCity = ''.obs;
  final RxString selectedCountry = ''.obs;

  final RxBool publishNow = true.obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final Rx<DateTime?> finalDeadlineDate = Rxn<DateTime>();

  final RxList<String> customQuestion = <String>[].obs;

  final RxBool resumeVisible = false.obs;
  final RxBool visaVisible = false.obs;
  final RxString resumeStatus = 'optional'.obs;
  final RxString visaStatus = 'optional'.obs;

  final Rxn<GetCurrencyResponseModel> selectedCurrency =
      Rxn<GetCurrencyResponseModel>();

  // List of categories & roles (shared from RecruiterController or fetched here)
  final categories = <Category>[].obs;
  final roles = <String>[].obs;

  /// Call this when user wants to EDIT an existing job
  void populateForEdit(GetSingleJobResponseModel job) {
    title.value = job.title ?? '';
    department.value = job.department ?? '';
    vacancy.value = job.vacancy?.toString() ?? '1';
    compensation.value = job.compensation ?? '';
    // companyWebsite.value = job.companyWebsite ?? '';
    jobDescriptionHtml.value = job.description ?? '';

    selectedCategory.value = job.name ?? '';
    selectedRole.value = job.role ?? '';
    selectedCategoryId.value = job.jobCategoryId ?? '';

    // Location
    if (job.location != null && job.location!.isNotEmpty) {
      final parts = job.location!.split(',');
      selectedCity.value = parts.length > 0 ? parts[0].trim() : '';
      selectedCountry.value = parts.length > 1 ? parts[1].trim() : '';
    }

    selectedEmploymentType.value = job.employementType ?? '';
    selectedExperienceLevel.value = job.experience ?? '';
    selectedLocationType.value = job.locationType ?? '';
    selectedCareerStage.value = job.careerStage ?? '';

    // Publish date logic
    final now = DateTime.now();
    final publishDate = job.publishDate;
    publishNow.value =
        publishDate == null ||
        publishDate.isBefore(now.add(const Duration(days: 1)));

    if (!publishNow.value && publishDate != null) {
      selectedDate.value = publishDate;
    }

    finalDeadlineDate.value = job.expiryDate;

    // Custom Questions
    customQuestion.clear();
    customQuestion.addAll(
      job.customQuestion
              ?.map((q) => q.question ?? '')
              .where((q) => q.isNotEmpty) ??
          [],
    );

    // Application Requirements
    final reqs = job.applicationRequirement ?? [];
    resumeVisible.value = reqs.any((r) => r.requirement == 'Resume');
    visaVisible.value = reqs.any(
      (r) => r.requirement == 'Have you got a valid visa for this location?',
    );

    resumeStatus.value =
        reqs.firstWhereOrNull((r) => r.requirement == 'Resume')?.status ??
        'optional';
    visaStatus.value =
        reqs
            .firstWhereOrNull(
              (r) => r.requirement == 'Have you got a valid visa for this location?',
            )
            ?.status ??
        'optional';

    print("JobFormController: populateForEdit completed for ${job.title}");
  }

  /// Clear all fields (for Create New Job)
  void clearForm() {
    title.value = '';
    department.value = '';
    vacancy.value = '1';
    compensation.value = '';
    companyWebsite.value = '';
    jobDescriptionHtml.value = '';
    selectedCategory.value = '';
    selectedRole.value = '';
    selectedCategoryId.value = '';
    selectedEmploymentType.value = '';
    selectedExperienceLevel.value = '';
    selectedLocationType.value = '';
    selectedCareerStage.value = '';
    selectedCity.value = '';
    selectedCountry.value = '';
    publishNow.value = true;
    selectedDate.value = DateTime.now();
    finalDeadlineDate.value = null;
    customQuestion.clear();
    resumeVisible.value = false;
    visaVisible.value = false;
    selectedCurrency.value = null;
  }
}
