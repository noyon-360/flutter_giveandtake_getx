import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../data/models/about_model.dart';
import '../../data/repositories/content_repository.dart';
import '../../data/repositories/content_repository_impl.dart';

class PrivacyController extends GetxController {
  final ContentRepository _repo;

  PrivacyController({ContentRepository? repository})
    : _repo = repository ?? ContentRepositoryImpl(client: http.Client());

  final RxBool isLoading = false.obs;
  final RxnString error = RxnString();
  final Rxn<AboutModel> privacyContent = Rxn<AboutModel>();

  @override
  void onInit() {
    super.onInit();
    fetchPrivacyContent();
  }

  Future<void> fetchPrivacyContent({bool forceRefresh = false}) async {
    if (!forceRefresh && privacyContent.value != null) return;

    try {
      isLoading.value = true;
      error.value = null;
      final content = await _repo.fetchPrivacy();
      privacyContent.value = content;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
