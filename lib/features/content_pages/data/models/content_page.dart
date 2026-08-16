abstract interface class ContentPageIdentity {
  String? get type;
  bool get isSystem;
}

class ContentPageSummary implements ContentPageIdentity {
  const ContentPageSummary({
    required this.id,
    required this.type,
    required this.title,
    required this.isSystem,
  });

  final String id;
  @override
  final String? type;
  final String title;
  @override
  final bool isSystem;

  factory ContentPageSummary.fromJson(Map<String, dynamic> json) {
    final id = json['_id'];
    final type = json['type'];
    final title = json['title'];
    final isSystem = json['isSystem'];

    if (id is! String ||
        (type != null && type is! String) ||
        title is! String ||
        (isSystem != null && isSystem is! bool)) {
      throw const FormatException('Invalid content page summary');
    }

    return ContentPageSummary(
      id: id,
      type: type as String?,
      title: title,
      isSystem: isSystem as bool? ?? false,
    );
  }
}

class ContentPage implements ContentPageIdentity {
  const ContentPage({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.isSystem,
    required this.published,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  @override
  final String type;
  final String title;
  final String description;
  @override
  final bool isSystem;
  final bool published;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory ContentPage.fromJson(Map<String, dynamic> json) {
    final id = json['_id'];
    final type = json['type'];
    final title = json['title'];
    final description = json['description'];
    final isSystem = json['isSystem'];
    final published = json['published'];
    final createdAt = json['createdAt'];
    final updatedAt = json['updatedAt'];

    if (id is! String ||
        type is! String ||
        title is! String ||
        (description != null && description is! String) ||
        (isSystem != null && isSystem is! bool) ||
        (published != null && published is! bool) ||
        (createdAt != null && createdAt is! String) ||
        (updatedAt != null && updatedAt is! String)) {
      throw const FormatException('Invalid content page');
    }

    return ContentPage(
      id: id,
      type: type,
      title: title,
      description: description as String? ?? '',
      isSystem: isSystem as bool? ?? false,
      published: published as bool? ?? true,
      createdAt: _parseDate(createdAt as String?),
      updatedAt: _parseDate(updatedAt as String?),
    );
  }

  static DateTime? _parseDate(String? value) {
    if (value == null) return null;
    final parsed = DateTime.tryParse(value);
    if (parsed == null) {
      throw const FormatException('Invalid content page date');
    }
    return parsed;
  }
}
