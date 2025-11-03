import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../data/models/about_model.dart';
import '../../data/repositories/content_repository.dart';
import '../../data/repositories/content_repository_impl.dart';

class AboutController extends GetxController {
  final ContentRepository _repo;

  AboutController({ContentRepository? repository})
    : _repo = repository ?? ContentRepositoryImpl(client: http.Client());

  final RxBool isLoading = false.obs;
  final RxnString error = RxnString();
  final Rxn<AboutModel> aboutContent = Rxn<AboutModel>();

  @override
  void onInit() {
    super.onInit();
    fetchAboutContent();
  }

  Future<void> fetchAboutContent({bool forceRefresh = false}) async {
    // If already have content and not forceRefresh, do nothing
    if (!forceRefresh && aboutContent.value != null) return;

    try {
      isLoading.value = true;
      error.value = null;
      final about = await _repo.fetchAbout();
      aboutContent.value = about;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
