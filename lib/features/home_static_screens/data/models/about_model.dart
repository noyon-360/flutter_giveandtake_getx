class AboutModel {
  final String id;
  final String type;
  final String title;
  final String description;
  final int v;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AboutModel({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.v,
    this.createdAt,
    this.updatedAt,
  });

  factory AboutModel.fromJson(Map<String, dynamic> json) {
    return AboutModel(
      id: json['_id'] ?? '',
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      v: (json['__v'] is int)
          ? json['__v'] as int
          : int.tryParse('${json['__v']}') ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'type': type,
    'title': title,
    'description': description,
    '__v': v,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };
}
