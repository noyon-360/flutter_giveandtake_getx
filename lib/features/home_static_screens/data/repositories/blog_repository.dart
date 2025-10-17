import '../models/blog_model.dart';

abstract class BlogRepository {
  Future<List<BlogModel>> fetchBlogs();
  Future<BlogModel> fetchBlogById(String id);
}
