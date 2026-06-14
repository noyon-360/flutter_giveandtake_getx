class AppNotificationModel {
  AppNotificationModel({
    required this.id,
    required this.message,
    required this.isViewed,
    this.createdAt,
    this.type,
    this.to,
    this.relatedId,
  });

  final String id;
  final String message;
  final bool isViewed;
  final DateTime? createdAt;
  final String? type;
  final String? to;

  /// Id of the entity this notification is ABOUT (a Job, AppliedJob, plan, ...),
  /// taken from the backend's `id` field. Distinct from [id], which is the
  /// notification document's own `_id`. Used to deep-link a tap to the right
  /// screen.
  final String? relatedId;

  factory AppNotificationModel.fromJson(Map<String, dynamic> json) {
    return AppNotificationModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      message: json['message']?.toString() ?? '',
      isViewed: json['isViewed'] == true,
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
      type: json['type']?.toString(),
      to: json['to']?.toString(),
      relatedId: json['id']?.toString(),
    );
  }

  AppNotificationModel copyWith({
    String? id,
    String? message,
    bool? isViewed,
    DateTime? createdAt,
    String? type,
    String? to,
    String? relatedId,
  }) {
    return AppNotificationModel(
      id: id ?? this.id,
      message: message ?? this.message,
      isViewed: isViewed ?? this.isViewed,
      createdAt: createdAt ?? this.createdAt,
      type: type ?? this.type,
      to: to ?? this.to,
      relatedId: relatedId ?? this.relatedId,
    );
  }
}
