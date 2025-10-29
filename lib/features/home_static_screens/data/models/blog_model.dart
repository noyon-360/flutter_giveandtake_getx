class BlogModel {
  final String id;
  final String title;
  final String description;
  final String? image;
  final String? userId;
  final String? createdAt;
  final String? updatedAt;

  BlogModel({
    required this.id,
    required this.title,
    required this.description,
    this.image,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  factory BlogModel.fromJson(Map<String, dynamic> json) {
    return BlogModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] as String?,
      userId: json['userId'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'title': title,
    'description': description,
    'image': image,
    'userId': userId,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };
}
