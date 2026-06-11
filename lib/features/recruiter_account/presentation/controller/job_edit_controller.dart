// features/recruiter_account/presentation/controller/job_edit_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:giveandtake/core/contracts/web/job_contract.dart';
import 'package:giveandtake/features/recruiter_account/data/models/get_single_job_response_model.dart'
    hide ApplicationRequirement, CustomQuestion;
import 'package:giveandtake/features/recruiter_account/data/models/job_update_request_model.dart';
import 'package:giveandtake/features/recruiter_account/presentation/controller/recruiter_controller.dart';
import 'package:giveandtake/features/recruiter_account/presentation/controller/country_city_controller.dart';
import '../../data/models/get_currency_response_model.dart';
import 'job_controller/career_stage_controller.dart';
import 'job_controller/employment_type_controller.dart';
import 'job_controller/experience_level_controller.dart';
import 'job_controller/location_type_controller.dart';

class JobEditController extends GetxController {
  final RecruiterController recruiterController = Get.find();

  // ADD THESE LINES:
  late final EmploymentTypeController employeeController;
  late final ExperienceLevelController experienceLevelController;
  late final LocationTypeController locationTypeController;
  late final CareerStageController careerStageController;

  // ------------------- Reactive State -------------------
  var isLoading = true.obs;
  var isEditMode = false.obs;

  // Core job data
  Rxn<GetSingleJobResponseModel> job = Rxn<GetSingleJobResponseModel>();

  // Form fields (NO selectedCountry/selectedCity here anymore!)
  var jobTitle = ''.obs;
  var department = ''.obs;
  var selectedCategory = ''.obs;
  var selectedRole = ''.obs;
  var vacancies = '1'.obs;
  var compensation = ''.obs;
  var companyWebsite = ''.obs;
  // var selectedEmploymentType = ''.obs;
  // var selectedExperienceLevel = ''.obs;
  // var selectedLocationType = ''.obs;
  // var selectedCareerStage = ''.obs;
  var selectedCurrency = Rxn<GetCurrencyResponseModel>();
  var jobDescriptionHtml = ''.obs;

  /// Plain-text job description field (stores plain text now, not HTML).
  final TextEditingController jobDescriptionController = TextEditingController();

  @override
  void onClose() {
    jobDescriptionController.dispose();
    super.onClose();
  }

  var publishNow = true.obs;
  Rx<DateTime?> selectedPublishDate = Rx<DateTime?>(null);

  // Roles list based on selected category
  var roles = <String>[].obs;

  // Application Requirements
  String resume = 'Resume';
  RxString resumeStatus = 'Required'.obs;
  RxBool resumeVisible = true.obs;

  String visa = JobPayloadBuilder.validVisaLabel;
  RxString visaStatus = 'Required'.obs;
  RxBool visaVisible = true.obs;

  // Custom Questions
  RxList<String> customQuestions = <String>[].obs;

  // Getters
  List<ApplicationRequirement> get applicationRequirement => [
    if (resumeVisible.value)
      ApplicationRequirement(requirement: resume, status: resumeStatus.value),
    if (visaVisible.value)
      ApplicationRequirement(requirement: visa, status: visaStatus.value),
  ];

  List<CustomQuestion> get customQuestionsList => customQuestions
      .where((q) => q.trim().isNotEmpty)
      .map((q) => CustomQuestion(question: q))
      .toList();

  @override
  void onInit() {
    super.onInit();

    // Initialize the shared controllers
    employeeController = Get.find<EmploymentTypeController>();
    experienceLevelController = Get.find<ExperienceLevelController>();
    locationTypeController = Get.find<LocationTypeController>();
    careerStageController = Get.find<CareerStageController>();

    ever(recruiterController.singleJob, (_) => _populateFromJob());
  }

  Future<void> fetchJob(String jobId) async {
    isLoading(true);
    await recruiterController.getSingleJob(jobId);
    isLoading(false);
  }

  void _populateFromJob() async {
    final j = recruiterController.singleJob.value;
    if (j == null) return;

    job.value = j;

    // Basic fields
    jobTitle.value = j.title ?? '';
    department.value = j.department ?? '';
    vacancies.value = j.vacancy?.toString() ?? '1';
    compensation.value = j.compensation ?? '';
    // Strip any legacy HTML so the field shows (and saves) clean plain text.
    final plainDescription = (j.description ?? '')
        .replaceAll(RegExp(r'<[^>]*>'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    jobDescriptionHtml.value = plainDescription;
    jobDescriptionController.text = plainDescription;
    companyWebsite.value = j.website_Url ?? '';

    // === LOCATION: Use LocationController as source of truth ===
    final locationController = Get.find<LocationController>();

    // Ensure countries are loaded
    if (locationController.countries.isEmpty) {
      await locationController.fetchCountriesWithCities();
    }

    if (j.location != null && j.location!.trim().isNotEmpty) {
      final parts = j.location!.split(',').map((e) => e.trim()).toList();

      String? city;
      String? country;

      if (parts.length >= 2) {
        city = parts[0];
        country = parts
            .sublist(1)
            .join(', ')
            .trim(); // handles "New York, NY, USA"
      } else if (parts.length == 1) {
        country = parts[0];
      }

      if (country != null && locationController.countries.contains(country)) {
        locationController.selectedCountry.value = country;
        locationController.onCountrySelected(country); // loads cities

        if (city != null && locationController.cities.contains(city)) {
          locationController.selectedCity.value = city;
        } else {
          locationController.selectedCity.value = null;
        }
      } else {
        locationController.selectedCountry.value = null;
        locationController.selectedCity.value = null;
        locationController.cities.clear();
      }
    } else {
      locationController.selectedCountry.value = null;
      locationController.selectedCity.value = null;
      locationController.cities.clear();
    }

    // Category & Role
    selectedCategory.value = j.name ?? '';
    _updateRolesForCategory(j.name ?? '');
    selectedRole.value = j.role ?? '';

    // Other dropdowns - convert backend values to display names
    employeeController.selectedEmploymentType.value = employeeController
        .getDisplayName(j.employementType ?? '');

    locationTypeController.selectedLocationType.value = locationTypeController
        .getDisplayName(j.locationType ?? '');

    experienceLevelController.selectedExperienceLevel.value =
        experienceLevelController.getDisplayName(j.experience ?? '');

    careerStageController.selectedCareerStage.value = careerStageController
        .getDisplayName(j.careerStage ?? '');

    // Publish settings
    publishNow.value =
        j.publishDate == null || j.publishDate!.isBefore(DateTime.now());
    selectedPublishDate.value = j.publishDate;

    // Requirements
    resumeVisible.value = false;
    visaVisible.value = false;
    for (var req in j.applicationRequirement ?? []) {
      if (req.requirement?.toLowerCase() == 'resume') {
        resumeVisible.value = true;
        resumeStatus.value = req.status ?? 'Required';
      } else if (req.requirement?.toLowerCase().contains('visa') == true) {
        visaVisible.value = true;
        visaStatus.value = req.status ?? 'Required';
      }
    }

    // Custom questions
    customQuestions.value = (j.customQuestion ?? [])
        .map((q) => q.question ?? '')
        .where((q) => q.isNotEmpty)
        .toList();
  }

  void _updateRolesForCategory(String categoryName) {
    final cat = recruiterController.category.firstWhereOrNull(
      (c) => c.name == categoryName,
    );
    roles.assignAll(cat?.role ?? []);
  }

  void toggleEditMode() => isEditMode(!isEditMode.value);

  void removeRequirement(String key) {
    if (key == 'resume') {
      resumeVisible.value = false;
    } else if (key == 'visa') {
      visaVisible.value = false;
    }
  }

  void togglePublishNow(bool value) {
    publishNow.value = value;
    if (!value && selectedPublishDate.value == null) {
      selectedPublishDate.value = DateTime.now().add(const Duration(days: 1));
    }
  }

  void updateSelectedPublishDate(DateTime date) {
    selectedPublishDate.value = date;
  }

  DateTime get safeInitialDate {
    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    final selected = selectedPublishDate.value;
    if (selected == null) return today.add(const Duration(days: 1));
    final sel = DateTime(selected.year, selected.month, selected.day);
    return sel.isBefore(today) ? today.add(const Duration(days: 1)) : sel;
  }

  void updateRoles(String category) {
    selectedCategory.value = category;
    _updateRolesForCategory(category);
    selectedRole.value = '';
  }

  Future<void> saveJob() async {
    if (job.value == null) return;

    final loc = Get.find<LocationController>();

    final updatedJob = UpdateJobRequest(
      id: job.value!.id!,
      userId: job.value?.user?.id,
      title: jobTitle.value.trim(),
      description: jobDescriptionHtml.value,
      department: department.value,
      website_Url: companyWebsite.value.trim(),
      vacancy: int.tryParse(vacancies.value) ?? 1,
      compensation: compensation.value,
      location: [
        loc.selectedCity.value,
        loc.selectedCountry.value,
      ].where((e) => e?.trim().isNotEmpty ?? false).join(', '),

      // 🔥 FIX: Use backend values instead of display names
      employementType: employeeController.getBackendValue(
        employeeController.selectedEmploymentType.value,
      ),
      locationType: locationTypeController.getBackendValue(
        locationTypeController.selectedLocationType.value,
      ),
      experience: experienceLevelController.getBackendValue(
        experienceLevelController.selectedExperienceLevel.value,
      ),
      careerStage: careerStageController.getBackendValue(
        careerStageController.selectedCareerStage.value,
      ),

      name: selectedCategory.value,
      role: selectedRole.value,
      publishDate: publishNow.value
          ? (job.value!.publishDate?.toIso8601String() ??
                DateTime.now().toUtc().toIso8601String())
          : selectedPublishDate.value != null
          ? DateFormat('yyyy-MM-dd').format(selectedPublishDate.value!)
          : null,
      applicationRequirement: applicationRequirement,
      customQuestion: customQuestionsList,
      createdAt: job.value!.createdAt?.toIso8601String(),
      expiryDate: job.value!.expiryDate?.toIso8601String(),
      deadline: job.value!.deadline?.toIso8601String(),
      salaryRange: job.value!.salaryRange ?? '',
    );

    await recruiterController.updateSingleJob(
      request: updatedJob,
      jobId: job.value!.id!,
    );

    isEditMode.value = false;
  }
}





// // features/recruiter_account/presentation/controller/job_edit_controller.dart
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:giveandtake/features/recruiter_account/data/models/get_single_job_response_model.dart'
//     hide ApplicationRequirement, CustomQuestion;
// import 'package:giveandtake/features/recruiter_account/data/models/job_update_request_model.dart';
// import 'package:giveandtake/features/recruiter_account/presentation/controller/recruiter_controller.dart';
// import 'package:giveandtake/features/recruiter_account/presentation/controller/country_city_controller.dart';
// import '../../data/models/get_currency_response_model.dart';
//
// class JobEditController extends GetxController {
//   final RecruiterController recruiterController = Get.find();
//
//   // ------------------- Reactive State -------------------
//   var isLoading = true.obs;
//   var isEditMode = false.obs;
//
//   // Core job data
//   Rxn<GetSingleJobResponseModel> job = Rxn<GetSingleJobResponseModel>();
//
//   // Form fields (NO selectedCountry/selectedCity here anymore!)
//   var jobTitle = ''.obs;
//   var department = ''.obs;
//   var selectedCategory = ''.obs;
//   var selectedRole = ''.obs;
//   var vacancies = '1'.obs;
//   var compensation = ''.obs;
//   var companyWebsite = ''.obs;
//   var selectedEmploymentType = ''.obs;
//   var selectedExperienceLevel = ''.obs;
//   var selectedLocationType = ''.obs;
//   var selectedCareerStage = ''.obs;
//   var selectedCurrency = Rxn<GetCurrencyResponseModel>();
//   var jobDescriptionHtml = ''.obs;
//   var publishNow = true.obs;
//   Rx<DateTime?> selectedPublishDate = Rx<DateTime?>(null);
//
//   // Roles list based on selected category
//   var roles = <String>[].obs;
//
//   // Application Requirements
//   String resume = 'Resume';
//   RxString resumeStatus = 'Required'.obs;
//   RxBool resumeVisible = true.obs;
//
//   String visa = 'Valid visa for this job location?';
//   RxString visaStatus = 'Required'.obs;
//   RxBool visaVisible = true.obs;
//
//   // Custom Questions
//   RxList<String> customQuestions = <String>[].obs;
//
//   // Getters
//   List<ApplicationRequirement> get applicationRequirement => [
//     if (resumeVisible.value)
//       ApplicationRequirement(requirement: resume, status: resumeStatus.value),
//     if (visaVisible.value) ApplicationRequirement(requirement: visa, status: visaStatus.value),
//   ];
//
//   List<CustomQuestion> get customQuestionsList => customQuestions
//       .where((q) => q.trim().isNotEmpty)
//       .map((q) => CustomQuestion(question: q))
//       .toList();
//
//   @override
//   void onInit() {
//     super.onInit();
//     ever(recruiterController.singleJob, (_) => _populateFromJob());
//   }
//
//   Future<void> fetchJob(String jobId) async {
//     isLoading(true);
//     await recruiterController.getSingleJob(jobId);
//     isLoading(false);
//   }
//
//   void _populateFromJob() async {
//     final j = recruiterController.singleJob.value;
//     if (j == null) return;
//
//     job.value = j;
//
//     // Basic fields
//     jobTitle.value = j.title ?? '';
//     department.value = j.department ?? '';
//     vacancies.value = j.vacancy?.toString() ?? '1';
//     compensation.value = j.compensation ?? '';
//     jobDescriptionHtml.value = j.description ?? '';
//     companyWebsite.value = j.website_Url ?? '';
//
//     // === LOCATION: Use LocationController as source of truth ===
//     final locationController = Get.find<LocationController>();
//
//     // Ensure countries are loaded
//     if (locationController.countries.isEmpty) {
//       await locationController.fetchCountriesWithCities();
//     }
//
//     if (j.location != null && j.location!.trim().isNotEmpty) {
//       final parts = j.location!.split(',').map((e) => e.trim()).toList();
//
//       String? city;
//       String? country;
//
//       if (parts.length >= 2) {
//         city = parts[0];
//         country = parts.sublist(1).join(', ').trim(); // handles "New York, NY, USA"
//       } else if (parts.length == 1) {
//         country = parts[0];
//       }
//
//       if (country != null && locationController.countries.contains(country)) {
//         locationController.selectedCountry.value = country;
//         locationController.onCountrySelected(country); // loads cities
//
//         if (city != null && locationController.cities.contains(city)) {
//           locationController.selectedCity.value = city;
//         } else {
//           locationController.selectedCity.value = null;
//         }
//       } else {
//         locationController.selectedCountry.value = null;
//         locationController.selectedCity.value = null;
//         locationController.cities.clear();
//       }
//     } else {
//       locationController.selectedCountry.value = null;
//       locationController.selectedCity.value = null;
//       locationController.cities.clear();
//     }
//
//     // Category & Role
//     selectedCategory.value = j.name ?? '';
//     _updateRolesForCategory(j.name ?? '');
//     selectedRole.value = j.role ?? '';
//
//     // Other dropdowns
//     selectedEmploymentType.value = j.employementType ?? '';
//     selectedExperienceLevel.value = j.experience ?? '';
//     selectedLocationType.value = j.locationType ?? '';
//     selectedCareerStage.value = j.careerStage ?? '';
//
//     // Publish settings
//     publishNow.value = j.publishDate == null || j.publishDate!.isBefore(DateTime.now());
//     selectedPublishDate.value = j.publishDate;
//
//     // Requirements
//     resumeVisible.value = false;
//     visaVisible.value = false;
//     for (var req in j.applicationRequirement ?? []) {
//       if (req.requirement?.toLowerCase() == 'resume') {
//         resumeVisible.value = true;
//         resumeStatus.value = req.status ?? 'Required';
//       } else if (req.requirement?.toLowerCase().contains('visa') == true) {
//         visaVisible.value = true;
//         visaStatus.value = req.status ?? 'Required';
//       }
//     }
//
//     // Custom questions
//     customQuestions.value = (j.customQuestion ?? [])
//         .map((q) => q.question ?? '')
//         .where((q) => q.isNotEmpty)
//         .toList();
//   }
//
//   void _updateRolesForCategory(String categoryName) {
//     final cat = recruiterController.category
//         .firstWhereOrNull((c) => c.name == categoryName);
//     roles.assignAll(cat?.role ?? []);
//   }
//
//   void toggleEditMode() => isEditMode(!isEditMode.value);
//
//   void removeRequirement(String key) {
//     if (key == 'resume') {
//       resumeVisible.value = false;
//     } else if (key == 'visa') {
//       visaVisible.value = false;
//     }
//   }
//
//   void togglePublishNow(bool value) {
//     publishNow.value = value;
//     if (!value && selectedPublishDate.value == null) {
//       selectedPublishDate.value = DateTime.now().add(const Duration(days: 1));
//     }
//   }
//
//   void updateSelectedPublishDate(DateTime date) {
//     selectedPublishDate.value = date;
//   }
//
//   DateTime get safeInitialDate {
//     final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
//     final selected = selectedPublishDate.value;
//     if (selected == null) return today.add(const Duration(days: 1));
//     final sel = DateTime(selected.year, selected.month, selected.day);
//     return sel.isBefore(today) ? today.add(const Duration(days: 1)) : sel;
//   }
//
//   void updateRoles(String category) {
//     selectedCategory.value = category;
//     _updateRolesForCategory(category);
//     selectedRole.value = '';
//   }
//
//   Future<void> saveJob() async {
//     if (job.value == null) return;
//
//     final loc = Get.find<LocationController>();
//
//     final updatedJob = UpdateJobRequest(
//       id: job.value!.id!,
//       userId: job.value?.user?.id,
//       title: jobTitle.value.trim(),
//       description: jobDescriptionHtml.value,
//       department: department.value,
//       website_Url: companyWebsite.value.trim(),
//       vacancy: int.tryParse(vacancies.value) ?? 1,
//       compensation: compensation.value,
//       location: [
//         loc.selectedCity.value,
//         loc.selectedCountry.value,
//       ].where((e) => e?.trim().isNotEmpty ?? false).join(', '),
//       employementType: selectedEmploymentType.value,
//       experience: selectedExperienceLevel.value,
//       locationType: selectedLocationType.value,
//       careerStage: selectedCareerStage.value,
//       name: selectedCategory.value,
//       role: selectedRole.value,
//       publishDate: publishNow.value
//           ? null
//           : selectedPublishDate.value != null
//           ? DateFormat('yyyy-MM-dd').format(selectedPublishDate.value!)
//           : null,
//       applicationRequirement: applicationRequirement,
//       customQuestion: customQuestionsList,
//       createdAt: job.value!.createdAt?.toIso8601String(),
//       expiryDate: job.value!.expiryDate?.toIso8601String(),
//       deadline: job.value!.deadline?.toIso8601String(),
//       salaryRange: job.value!.salaryRange ?? '',
//     );
//
//     await recruiterController.updateSingleJob(
//       request: updatedJob,
//       jobId: job.value!.id!,
//     );
//
//     isEditMode.value = false;
//   }
// }
