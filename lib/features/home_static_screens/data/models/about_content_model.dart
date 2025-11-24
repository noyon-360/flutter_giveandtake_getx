class AboutContentModel {
  final String id;
  final String type;
  final String title;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;

  AboutContentModel({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AboutContentModel.fromJson(Map<String, dynamic> json) {
    return AboutContentModel(
      id: json['_id'] ?? '',
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'type': type,
    'title': title,
    'description': description,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}
