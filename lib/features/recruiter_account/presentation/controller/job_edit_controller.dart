// features/recruiter_account/presentation/controller/job_edit_controller.dart
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:karlfive/features/recruiter_account/data/models/get_single_job_response_model.dart'
    hide ApplicationRequirement, CustomQuestion;
import 'package:karlfive/features/recruiter_account/data/models/job_update_request_model.dart';
import 'package:karlfive/features/recruiter_account/presentation/controller/recruiter_controller.dart';
import '../../data/models/get_currency_response_model.dart';

class JobEditController extends GetxController {
  final RecruiterController recruiterController = Get.find();

  // ------------------- Reactive State -------------------
  var isLoading = true.obs;
  var isEditMode = false.obs;

  // Core job data
  Rxn<GetSingleJobResponseModel> job = Rxn<GetSingleJobResponseModel>();

  // Form fields
  var jobTitle = ''.obs;
  var department = ''.obs;
  var selectedCategory = ''.obs;
  var selectedRole = ''.obs;
  var selectedCountry = ''.obs;
  var selectedCity = ''.obs;
  var vacancies = '1'.obs;
  var compensation = ''.obs;
  var companyWebsite = ''.obs;
  var selectedEmploymentType = ''.obs;
  var selectedExperienceLevel = ''.obs;
  var selectedLocationType = ''.obs;
  var selectedCareerStage = ''.obs;
  var selectedCurrency = Rxn<GetCurrencyResponseModel>();
  var jobDescriptionHtml = ''.obs;
  var publishNow = true.obs;
  var selectedPublishDate = DateTime.now().obs;

  // Roles list based on selected category
  var roles = <String>[].obs;

  // ------------------- Application Requirements (Same as JobPostingController) -------------------
  String resume = 'Resume';
  RxString resumeStatus = 'Required'.obs;
  RxBool resumeVisible = true.obs;

  String visa = 'Valid visa for this job location?';
  RxString visaStatus = 'Required'.obs;
  RxBool visaVisible = true.obs;

  // ------------------- Custom Questions -------------------
  RxList<String> customQuestions = <String>[].obs;

  // ------------------- Getters (Same as JobPostingController) -------------------
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
    ever(recruiterController.singleJob, (_) => _populateFromJob());
  }

  Future<void> fetchJob(String jobId) async {
    isLoading(true);
    await recruiterController.getSingleJob(jobId);
    isLoading(false);
  }

  void _populateFromJob() {
    final j = recruiterController.singleJob.value;
    if (j == null) return;

    job.value = j;

    // Basic
    jobTitle.value = j.title ?? '';
    department.value = j.department ?? '';
    vacancies.value = j.vacancy?.toString() ?? '1';
    compensation.value = j.compensation ?? '';
    jobDescriptionHtml.value = j.description ?? '';

    // Location
    if (j.location != null) {
      final parts = j.location!.split(',');
      selectedCity.value = parts.isNotEmpty ? parts[0].trim() : '';
      selectedCountry.value = parts.length > 1 ? parts[1].trim() : '';
    }

    // Category & Role
    selectedCategory.value = j.name ?? '';
    _updateRolesForCategory(j.name ?? '');
    selectedRole.value = j.role ?? '';

    // Dropdowns
    selectedEmploymentType.value = j.employementType ?? '';
    selectedExperienceLevel.value = j.experience ?? '';
    selectedLocationType.value = j.locationType ?? '';
    selectedCareerStage.value = j.careerStage ?? '';

    // Publish
    publishNow.value = j.publishDate == null || j.publishDate!.isBefore(DateTime.now());
    selectedPublishDate.value = j.publishDate ?? DateTime.now();

    // ------------------- Application Requirements -------------------
    resumeVisible.value = false;
    visaVisible.value = false;

    for (var req in j.applicationRequirement ?? []) {
      final requirement = req.requirement?.toLowerCase();
      if (requirement == 'resume') {
        resumeVisible.value = true;
        resumeStatus.value = req.status ?? 'Required';
      } else if (requirement == 'valid visa for this job location?' ||
          requirement == 'visa') {
        visaVisible.value = true;
        visaStatus.value = req.status ?? 'Required';
      }
    }

    // ------------------- Custom Questions -------------------
    customQuestions.value = (j.customQuestion ?? [])
        .map((q) => q.question ?? '')
        .where((q) => q.isNotEmpty)
        .toList();
  }

  void _updateRolesForCategory(String categoryName) {
    final cat = recruiterController.category
        .firstWhereOrNull((c) => c.name == categoryName);
    roles.value = cat?.role ?? [];
  }

  void toggleEditMode() => isEditMode(!isEditMode.value);

  // Remove requirement (same as JobPostingController)
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

  Future<void> saveJob() async {
    if (job.value == null) return;

    final updatedJob = UpdateJobRequest(
      id: job.value!.id!,
      title: jobTitle.value.trim(),
      description: jobDescriptionHtml.value,
      department: department.value,
      vacancy: int.tryParse(vacancies.value) ?? 1,
      compensation: compensation.value,
      location: [selectedCity.value, selectedCountry.value]
          .where((e) => e.trim().isNotEmpty)
          .join(', '),
      employementType: selectedEmploymentType.value,
      experience: selectedExperienceLevel.value,
      locationType: selectedLocationType.value,
      careerStage: selectedCareerStage.value,
      name: selectedCategory.value,
      role: selectedRole.value,
      publishDate: publishNow.value
          ? null
          : DateFormat('yyyy-MM-dd').format(selectedPublishDate.value),
      applicationRequirement: applicationRequirement,
      customQuestion: customQuestionsList,
      createdAt: job.value!.createdAt?.toIso8601String(),
      expiryDate: job.value!.expiryDate?.toIso8601String(),
      deadline: job.value!.deadline?.toIso8601String(),
      responsibilities: job.value!.responsibilities ?? [],
      salaryRange: job.value!.salaryRange ?? '',
    );

    await recruiterController.updateSingleJob(
      request: updatedJob,
      jobId: job.value!.id!,
    );

    isEditMode.value = false;
  }

  void updateRoles(String category) {
    selectedCategory.value = category;
    _updateRolesForCategory(category);
    selectedRole.value = '';
  }
}