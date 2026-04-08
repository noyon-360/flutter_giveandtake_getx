class AppNotificationModel {
  AppNotificationModel({
    required this.id,
    required this.message,
    required this.isViewed,
    this.createdAt,
    this.type,
    this.to,
  });

  final String id;
  final String message;
  final bool isViewed;
  final DateTime? createdAt;
  final String? type;
  final String? to;

  factory AppNotificationModel.fromJson(Map<String, dynamic> json) {
    return AppNotificationModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      message: json['message']?.toString() ?? '',
      isViewed: json['isViewed'] == true,
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
      type: json['type']?.toString(),
      to: json['to']?.toString(),
    );
  }

  AppNotificationModel copyWith({
    String? id,
    String? message,
    bool? isViewed,
    DateTime? createdAt,
    String? type,
    String? to,
  }) {
    return AppNotificationModel(
      id: id ?? this.id,
      message: message ?? this.message,
      isViewed: isViewed ?? this.isViewed,
      createdAt: createdAt ?? this.createdAt,
      type: type ?? this.type,
      to: to ?? this.to,
    );
  }
}
