import 'category_model.dart';

class CategoryResponse {
  final List<Category> categories;

  CategoryResponse({required this.categories});

  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    // Access 'category' directly
    final categoryList = json['category'] as List? ?? [];

    return CategoryResponse(
      categories: categoryList
          .map((item) => Category.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': categories.map((item) => item.toJson()).toList(),
    };
  }
}
