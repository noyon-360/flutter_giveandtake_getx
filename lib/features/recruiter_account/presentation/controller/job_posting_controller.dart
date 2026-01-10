import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/features/recruiter_account/data/models/get_category_response_model.dart';
import 'package:karlfive/features/recruiter_account/data/models/get_currency_response_model.dart';
import 'package:karlfive/features/recruiter_account/presentation/controller/recruiter_controller.dart';
import 'package:karlfive/features/recruiter_account/data/models/job_create_request_model.dart';

import 'country_city_controller.dart';
import 'job_controller/career_stage_controller.dart';
import 'job_controller/employment_type_controller.dart';
import 'job_controller/experience_level_controller.dart';
import 'job_controller/job_posting_expiration_controller.dart';
import 'job_controller/location_type_controller.dart';

class JobPostingController extends GetxController {
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
  Get.put(JobPostingExpirationController());


  final recruiterController = Get.find<RecruiterController>();

  // Reactive step tracker
  RxInt currentStep = 1.obs;

  // Category and Role selection
  RxList<String> roles = <String>[].obs;
  RxString selectedCategory = ''.obs;
  RxString selectedRole = ''.obs;

  RxString jobTitle = ''.obs;
  RxString department = ''.obs;

  RxString vacancies = ''.obs;
  late int vacanciesInt = int.tryParse(vacancies.value) ?? 0;

  // Add these setter methods for cleaner updates (optional)
  void setJobTitle(String value) => jobTitle.value = value;

  void setDepartment(String value) => department.value = value;

  // Data sources
  List<Category> get categories => recruiterController.category;

  // Currency management
  var currencies = <GetCurrencyResponseModel>[].obs;
  var selectedCurrency = Rxn<GetCurrencyResponseModel>();
  RxString compensation = ''.obs;

  // add these near the other application requirements state variables
  RxString resumeStatus = ''.obs;
  String resume = 'Resume';
  RxBool resumeVisible = true.obs; // <-- controls whether the row is shown

  RxString visaStatus = ''.obs;
  String visa = 'Valid visa for this job location?';
  RxBool visaVisible = true.obs; // <-- controls whether the row is shown

  // Job Description (HTML) & Publish

  /// We keep HTML here (from the HTML editor). If you also want plain text,
  /// we compute it from the HTML when updating.
  RxString jobDescriptionHtml = ''.obs;
  RxString jobDescriptionPlain = ''.obs;

  // counts
  RxInt characterCount = 0.obs;
  RxInt wordCount = 0.obs;

  // Publish settings
  RxBool publishNow = true.obs;
  Rx<DateTime> selectedDate = DateTime.now().obs;

  RxString companyWebsite = ''.obs;

  RxList<String> customQuestion = <String>[].obs;

  // -----------------------------
  // Single Job Fetching
  // -----------------------------
  RxBool isLoading = false.obs;
  RxString error = ''.obs;

  void populateFieldsFromSingleJob() {
    final job = recruiterController.singleJob.value;

    if (job == null) return;

    // Basic fields
    jobTitle.value = job.title ?? '';
    // department.value = job.department ?? ''; // Uncomment if you have department
    vacancies.value = job.vacancy?.toString() ?? '';
    compensation.value = job.compensation ?? '';

    // Category & Role
    selectedCategory.value = job.jobCategoryId ?? '';
    updateRoles(selectedCategory.value); // populate roles
    selectedRole.value = job.role ?? '';

    // Description
    jobDescriptionHtml.value = job.description ?? '';
    updateJobDescriptionHtml(job.description ?? '');

    // Publish Date & Flag
    publishNow.value =
        job.publishDate == null || job.publishDate!.isBefore(DateTime.now());
    selectedDate.value = job.publishDate ?? DateTime.now();

    // --- Application Requirements ---
    if (job.applicationRequirement != null) {
      for (var requirement in job.applicationRequirement!) {
        if (requirement.requirement?.toLowerCase() == 'resume') {
          resume = requirement.requirement ?? '';
          resumeStatus.value = requirement.status ?? 'Required';
        } else if (requirement.requirement?.toLowerCase() == 'visa') {
          visa = requirement.requirement ?? '';
          visaStatus.value = requirement.status ?? 'Required';
        }
      }
    }

    // --- Custom Questions ---
    if (job.customQuestion != null) {
      customQuestion.value = job.customQuestion!
          .map((q) => q.question ?? '')
          .toList();
    }
  }

  bool validateCurrentStep() {
    switch (currentStep.value) {
      case 1: // Job Details
        if (jobTitle.value.trim().isEmpty) return false;
        if (selectedCategory.value.isEmpty) return false;
        if (selectedRole.value.isEmpty) return false;

        final vac = vacancies.value.trim();
        if (vac.isEmpty) return false;
        final vacInt = int.tryParse(vac);
        if (vacInt == null || vacInt <= 0) return false;

        return true;

      case 2: // Job Description
        // Require at least some meaningful description
        final plain = jobDescriptionPlain.value.trim();
        if (plain.isEmpty || plain.length < 50) return false;
        return true;

      case 3: // Application Requirements
        // Optional step – always valid
        return true;

      case 4: // Custom Questions
        // Optional step – always valid
        return true;

      case 5: // Finish
        return true;

      default:
        return false;
    }
  }

  /// Show a friendly error message when validation fails
  void _showValidationError(String message) {
    Get.snackbar(
      'Incomplete Information',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade700,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.all(12),
    );
  }

  // -----------------------------
  // Step Navigation (with validation)
  // -----------------------------

  void nextStep() {
    if (validateCurrentStep()) {
      if (currentStep.value < 5) {
        currentStep.value++;
      }
    } else {
      // Specific messages per step
      switch (currentStep.value) {
        case 1:
          _showValidationError(
            'Please enter at least 20 words in the job description.',
          );
          break;
        case 2:
          _showValidationError(
            'Job description exceeds 2000 characters. Please shorten it.',
          );
          break;
        default:
          _showValidationError('Please complete all required fields.');
      }
    }
  }

  void previousStep() {
    if (currentStep.value > 1) {
      currentStep.value--;
    }
  }

  /// Optional: Allow going back to previous steps by tapping, but never forward to unvalidated steps
  void goToStep(int step) {
    if (step < currentStep.value || step == currentStep.value) {
      // Allow going back or staying on current
      currentStep.value = step;
    }
    // Going forward is blocked unless validation passes (handled by nextStep())
  }

  // -----------------------------
  // Lifecycle
  // -----------------------------
  @override
  void onInit() {
    super.onInit();

    // Keep currencies in sync with RecruiterController
    ever(recruiterController.currency, (_) {
      currencies.assignAll(recruiterController.currency);
    });

    // Populate immediately if already fetched
    if (recruiterController.currency.isNotEmpty) {
      currencies.assignAll(recruiterController.currency);
    }

    loadCurrenciesIfEmpty();
  }

  // add a remove method
  void removeRequirement(String key) {
    switch (key) {
      case 'resume':
        resumeVisible.value = false;
        resumeStatus.value = '';
        break;
      case 'visa':
        visaVisible.value = false;
        visaStatus.value = '';
        break;
    }
  }

  List<ApplicationRequirement> get applicationRequirement => [
    ApplicationRequirement(requirement: resume, status: resumeStatus.value),
    ApplicationRequirement(requirement: visa, status: visaStatus.value),
  ];

  List<CustomQuestion> get customQuestions =>
      customQuestion.map((q) => CustomQuestion(question: q)).toList();

  // -----------------------------
  // Step Navigation
  // -----------------------------
  // void nextStep() {
  //   if (currentStep.value < 5) currentStep.value++;
  //
  // }
  //
  // void previousStep() {
  //   if (currentStep.value > 1) currentStep.value--;
  // }

  // -----------------------------
  // Role update based on category
  // -----------------------------
  void updateRoles(String categoryName) {
    selectedCategory.value = categoryName;

    final category = categories.firstWhereOrNull((c) => c.name == categoryName);

    // VERY IMPORTANT: Create a NEW list (copy)
    roles.value = List<String>.from(category?.role ?? []);
    // or if role is List<Role> model:
    // roles.value = [...?category?.role?.map((r) => r.name)];

    selectedRole.value = '';
  }

  // -----------------------------
  // Currency Fetching
  // -----------------------------
  Future<void> loadCurrenciesIfEmpty() async {
    if (currencies.isEmpty) {
      await recruiterController.fetchCurrency();
      currencies.assignAll(recruiterController.currency);
    }
  }

  // -----------------------------
  // Publish Logic
  // -----------------------------
  void togglePublishNow(bool value) {
    publishNow.value = value;
  }

  void updateSelectedDate(DateTime date) {
    selectedDate.value = date;
  }

  // -----------------------------
  // Job description helpers
  // -----------------------------
  /// Call this when the HTML content changes.
  void updateJobDescriptionHtml(String html) {
    jobDescriptionHtml.value = html;
    final plain = _stripHtmlTags(jobDescriptionHtml.value).trim();
    jobDescriptionPlain.value = plain;
    characterCount.value = plain.length;
    wordCount.value = _countWords(plain);
  }

  String _stripHtmlTags(String html) {
    // quick & practical stripper — works for most simple HTML from the editor
    final withoutTags = html.replaceAll(RegExp(r'<[^>]*>|&nbsp;'), ' ');
    // collapse whitespace
    return withoutTags.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  int _countWords(String plain) {
    if (plain.isEmpty) return 0;
    final words = plain.split(RegExp(r'\s+')).where((w) => w.isNotEmpty);
    return words.length;
  }

  // -----------------------------
  // Clean-up
  // -----------------------------
  @override
  void onClose() {
    super.onClose();
  }

  void clearAllFields() {
    // Step tracker
    currentStep.value = 1;

    // Optionally reset other related controllers if needed
    // locationController.selectedCity.value = '';
    // locationController.selectedCountry.value = '';

    // Basic info
    jobTitle.value = '';
    department.value = '';
    vacancies.value = '';
    vacanciesInt = 0;

    // Category & Role
    selectedCategory.value = '';
    selectedRole.value = '';
    roles.clear();

    // Compensation
    compensation.value = '';
    selectedCurrency.value = null;

    // Job Description
    jobDescriptionHtml.value = '';
    jobDescriptionPlain.value = '';
    characterCount.value = 0;
    wordCount.value = 0;

    // Application Requirements
    resumeStatus.value = ''; // or 'Required' if default
    visaStatus.value = '';
    resumeVisible.value = true;
    visaVisible.value = true;
    resume = 'Resume'; // reset text if modified
    visa = 'Valid visa for this job location?';

    // Custom Questions
    customQuestion.clear();

    // Publish settings
    publishNow.value = true;
    selectedDate.value = DateTime.now();

    // Company website
    companyWebsite.value = '';

    // Loading/Error states
    isLoading.value = false;
    error.value = '';
  }


  void clearAllFieldsPreview() {
    // Step tracker
    currentStep.value = 1;

    // Optionally reset other related controllers if needed
    locationController.selectedCity.value = '';
    locationController.selectedCountry.value = '';

    employmentTypeController.selectedEmploymentType.value = '';
    experienceController.selectedExperienceLevel.value = '';
    locationTypeController.selectedLocationType.value = '';
    careerStageController.selectedCareerStage.value = '';
    jobPostingExpirationController.selectedJobPostingExpiration.value = '';

    // Basic info
    jobTitle.value = '';
    department.value = '';
    vacancies.value = '';
    vacanciesInt = 0;

    // Category & Role
    selectedCategory.value = '';
    selectedRole.value = '';
    roles.clear();

    // Compensation
    compensation.value = '';
    selectedCurrency.value = null;

    // Job Description
    jobDescriptionHtml.value = '';
    jobDescriptionPlain.value = '';
    characterCount.value = 0;
    wordCount.value = 0;

    // Application Requirements
    resumeStatus.value = ''; // or 'Required' if default
    visaStatus.value = '';
    resumeVisible.value = true;
    visaVisible.value = true;
    resume = 'Resume'; // reset text if modified
    visa = 'Valid visa for this job location?';

    // Custom Questions
    customQuestion.clear();

    // Publish settings
    publishNow.value = true;
    selectedDate.value = DateTime.now();

    // Company website
    companyWebsite.value = '';

    // Loading/Error states
    isLoading.value = false;
    error.value = '';
  }
}
