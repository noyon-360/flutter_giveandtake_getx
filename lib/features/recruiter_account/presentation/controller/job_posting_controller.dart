import 'package:get/get.dart';
import 'package:karlfive/features/recruiter_account/data/models/get_category_response_model.dart';
import 'package:karlfive/features/recruiter_account/data/models/get_currency_response_model.dart';
import 'package:karlfive/features/recruiter_account/presentation/controller/recruiter_controller.dart';
import 'package:karlfive/features/recruiter_account/data/models/job_create_request_model.dart';


class JobPostingController extends GetxController {
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
  String visa = 'Visa';
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

  RxString companyWebsite= ''.obs;

  RxList<String> customQuestion= <String>[].obs;


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
  void nextStep() {
    if (currentStep.value < 5) currentStep.value++;

  }

  void previousStep() {
    if (currentStep.value > 1) currentStep.value--;
  }

  // -----------------------------
  // Role update based on category
  // -----------------------------
  void updateRoles(String categoryName) {
    selectedCategory.value = categoryName;
    final category = categories.firstWhereOrNull((c) => c.name == categoryName);
    roles.value = category?.role ?? [];
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
}

