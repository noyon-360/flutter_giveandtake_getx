import 'package:get/get.dart';
import '../../data/models/blog_model.dart';
import '../../data/repositories/blog_repository_impl.dart';
import '../../data/repositories/blog_repository.dart';

class BlogController extends GetxController {
  final BlogRepository repository;

  BlogController({BlogRepository? repository})
    : repository = repository ?? BlogRepositoryImpl();

  final blogs = <BlogModel>[].obs;
  final isLoading = false.obs;
  final error = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchBlogs();
  }

  Future<void> fetchBlogs() async {
    try {
      isLoading.value = true;
      error.value = null;
      final list = await repository.fetchBlogs();
      blogs.assignAll(list);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
