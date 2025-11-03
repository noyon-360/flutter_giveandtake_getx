class ContentResponse {
  final String id;
  final String type;
  final String title;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;

  ContentResponse({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  factory ContentResponse.fromJson(Map<String, dynamic> json) {
    return ContentResponse(
      id: json['_id'] ?? '',
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      version: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'type': type,
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': version,
    };
  }
}
