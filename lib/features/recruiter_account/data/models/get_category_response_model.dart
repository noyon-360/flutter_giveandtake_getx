class GetCategoryResponseModel {
  final List<Category> category;
  final Meta meta;

  GetCategoryResponseModel({
    required this.category,
    required this.meta,
  });

  factory GetCategoryResponseModel.fromJson(Map<String, dynamic> json) {
    return GetCategoryResponseModel(
      category: (json['category'] as List<dynamic>)
          .map((e) => Category.fromJson(e))
          .toList(),
      meta: Meta.fromJson(json['meta']),
    );
  }

  Map<String, dynamic> toJson() => {
    'category': category.map((e) => e.toJson()).toList(),
    'meta': meta.toJson(),
  };
}

class Category {
  final String id;
  final String name;
  final List<String> role;
  final String? categoryIcon;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  Category({
    required this.id,
    required this.name,
    required this.role,
    this.categoryIcon,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      role: List<String>.from(json['role'] ?? []),
      categoryIcon: json['categoryIcon'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'role': role,
    'categoryIcon': categoryIcon,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    '__v': v,
  };
}

class Meta {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;

  Meta({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      currentPage: json['currentPage'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      totalItems: json['totalItems'] ?? 0,
      itemsPerPage: json['itemsPerPage'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'currentPage': currentPage,
    'totalPages': totalPages,
    'totalItems': totalItems,
    'itemsPerPage': itemsPerPage,
  };
}
