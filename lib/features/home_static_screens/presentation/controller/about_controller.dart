import 'package:get/get.dart';
import '../../data/models/about_content_model.dart';
import '../../data/repositories/about_repo_impl.dart';

class AboutController extends GetxController {
  final _repo = AboutRepositoryImpl();

  final _isLoading = false.obs;
  final _error = RxnString();
  final _aboutContent = Rxn<AboutContentModel>();
  bool _hasFetchedOnce = false;

  bool get isLoading => _isLoading.value;
  String? get error => _error.value;
  AboutContentModel? get aboutContent => _aboutContent.value;

  @override
  void onInit() {
    super.onInit();
    fetchAboutContent();
  }

  Future<void> fetchAboutContent({bool forceRefresh = false}) async {
    if (_hasFetchedOnce && !forceRefresh) return;
    try {
      _isLoading.value = true;
      _error.value = null;

      final result = await _repo.getAboutContent();
      result.fold(
            (fail) => _error.value = fail.message,
            (data) {
          _aboutContent.value = data as AboutContentModel?;
          _hasFetchedOnce = true;
        },
      );
    } catch (e) {
      _error.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }
}
