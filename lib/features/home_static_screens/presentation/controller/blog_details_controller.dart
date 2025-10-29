import 'package:get/get.dart';
import '../../data/models/blog_model.dart';
import '../../data/repositories/blog_repository_impl.dart';
import '../../data/repositories/blog_repository.dart';

class BlogDetailsController extends GetxController {
  final BlogRepository repository;

  BlogDetailsController({BlogRepository? repository})
    : repository = repository ?? BlogRepositoryImpl();

  final blog = Rxn<BlogModel>();
  final isLoading = false.obs;
  final error = RxnString();

  Future<void> fetchById(String id) async {
    try {
      isLoading.value = true;
      error.value = null;
      final b = await repository.fetchBlogById(id);
      blog.value = b;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
