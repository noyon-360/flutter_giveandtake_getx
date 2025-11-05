import 'package:get/get.dart';
import 'package:karlfive/features/recruiter_account/data/models/get_category_response_model.dart';
import 'package:karlfive/features/recruiter_account/data/models/get_currency_response_model.dart';
import 'package:karlfive/features/recruiter_account/presentation/controller/recruiter_controller.dart';

class JobPostingController extends GetxController {
  final recruiterController = Get.find<RecruiterController>();

  // Reactive step tracker
  RxInt currentStep = 1.obs;

  // Selection state
  RxList<String> roles = <String>[].obs;
  RxString selectedCategory = ''.obs;
  RxString selectedRole = ''.obs;

  // Data sources
  List<Category> get categories => recruiterController.category;

  // Currency
  var currencies = <GetCurrencyResponseModel>[].obs;
  var selectedCurrency = Rxn<GetCurrencyResponseModel>();

  @override
  void onInit() {
    super.onInit();

    // ✅ Keep JobPostingController currencies in sync with RecruiterController
    ever(recruiterController.currency, (_) {
      currencies.assignAll(recruiterController.currency);
    });

    // ✅ Populate immediately if already fetched
    if (recruiterController.currency.isNotEmpty) {
      currencies.assignAll(recruiterController.currency);
    }

    loadCurrenciesIfEmpty();
  }

  // Step navigation
  void nextStep() {
    if (currentStep.value < 5) currentStep.value++;
  }

  void previousStep() {
    if (currentStep.value > 1) currentStep.value--;
  }

  // Roles based on category
  void updateRoles(String categoryName) {
    selectedCategory.value = categoryName;
    final category = categories.firstWhereOrNull((c) => c.name == categoryName);
    roles.value = category?.role ?? [];
    selectedRole.value = '';
  }

  Future<void> loadCurrenciesIfEmpty() async {
    if (currencies.isEmpty) {
      await recruiterController.fetchCurrency();
      currencies.assignAll(recruiterController.currency);
    }
  }

}
