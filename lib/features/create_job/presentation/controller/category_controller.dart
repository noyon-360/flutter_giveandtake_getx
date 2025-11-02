import 'package:get/get.dart';
import '../../../../core/base/base_controller.dart';
import '../../../../core/network/network_result.dart';
import '../../data/model/category_model.dart';
import '../../domain/category_repo.dart';

class CategoryController extends BaseController {
  final CategoryRepository _categoryRepository;

  CategoryController(this._categoryRepository);

  final RxBool isLoading = false.obs;
  final RxList<Category> categories = <Category>[].obs;
  final RxList<String> roles = <String>[].obs; // ✅ dynamic role list
  final RxString selectedCategory = ''.obs;
  final RxString selectedRole = ''.obs;

  // var selectedCategory = RxnString();
  // var selectedRole = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchJobCategories();
  }

  Future<void> fetchJobCategories() async {
    isLoading.value = true;
    final result = await _categoryRepository.jobCategory();

    result.fold(
      (failure) {
        isLoading.value = false;
        print("❌ Error fetching categories: ${failure.message}");
      },
      (success) {
        isLoading.value = false;
        categories.assignAll(success.data.categories);
      },
    );
  }

  void updateRoles(String categoryName) {
    selectedCategory.value = categoryName;

    final selected = categories.firstWhereOrNull((c) => c.name == categoryName);
    if (selected != null) {
      roles.assignAll(selected.role);
      // reset previous role safely
      selectedRole.value = '';
    } else {
      roles.clear();
      selectedRole.value = '';
    }
  }
}