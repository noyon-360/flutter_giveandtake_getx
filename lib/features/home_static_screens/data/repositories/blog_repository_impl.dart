import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/network/constants/api_constants.dart';
import '../models/blog_model.dart';
import 'blog_repository.dart';

class BlogRepositoryImpl implements BlogRepository {
  final http.Client client;

  BlogRepositoryImpl({http.Client? client}) : client = client ?? http.Client();

  @override
  Future<List<BlogModel>> fetchBlogs() async {
    final uri = Uri.parse('${ApiConstants.baseUrl}/blogs/get-all');
    final resp = await client.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (resp.statusCode == 200) {
      final body = json.decode(resp.body) as Map<String, dynamic>;
      final data = body['data'] as Map<String, dynamic>?;
      final blogs = data != null ? (data['blogs'] as List<dynamic>?) : null;
      if (blogs == null) return [];
      return blogs
          .map((e) => BlogModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to fetch blogs: ${resp.statusCode} ${resp.body}');
    }
  }

  @override
  Future<BlogModel> fetchBlogById(String id) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}/blogs/$id');
    final resp = await client.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (resp.statusCode == 200) {
      final body = json.decode(resp.body) as Map<String, dynamic>;
      final data = body['data'] as Map<String, dynamic>?;
      if (data == null) throw Exception('Missing data in response');
      return BlogModel.fromJson(data);
    } else {
      throw Exception('Failed to fetch blog: ${resp.statusCode} ${resp.body}');
    }
  }
}
