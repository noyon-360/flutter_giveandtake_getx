class Category {
  final String id;
  final String name;
  final List<String> role;
  final String? categoryIcon; // nullable
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int v;

  Category({
    required this.id,
    required this.name,
    required this.role,
    this.categoryIcon,
    this.createdAt,
    this.updatedAt,
    required this.v,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'] as String,
      name: json['name'] as String? ?? '',
      role: List<String>.from(json['role'] ?? []),
      categoryIcon: json['categoryIcon'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      v: json['__v'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'role': role,
      'categoryIcon': categoryIcon,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': v,
    };
  }
}
