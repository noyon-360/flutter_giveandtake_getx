class MessageUserModel {
  MessageUserModel({
    required this.id,
    this.name,
    this.email,
    this.role,
    this.avatarUrl,
  });

  final String id;
  final String? name;
  final String? email;
  final String? role;
  final String? avatarUrl;

  factory MessageUserModel.fromJson(Map<String, dynamic> json) {
    final avatar = json['avatar'];
    final avatarUrl = avatar is Map<String, dynamic> ? avatar['url']?.toString() : null;
    return MessageUserModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      name: json['name']?.toString(),
      email: json['email']?.toString(),
      role: json['role']?.toString(),
      avatarUrl: avatarUrl,
    );
  }
}

class MessageAttachmentModel {
  MessageAttachmentModel({
    required this.filename,
    required this.url,
  });

  final String filename;
  final String url;

  factory MessageAttachmentModel.fromJson(Map<String, dynamic> json) {
    return MessageAttachmentModel(
      filename: json['filename']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
    );
  }
}

class ChatMessageModel {
  ChatMessageModel({
    required this.id,
    required this.userId,
    required this.message,
    required this.roomId,
    required this.files,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final MessageUserModel? userId;
  final String message;
  final String roomId;
  final List<MessageAttachmentModel> files;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    final userData = json['userId'];
    return ChatMessageModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      userId: userData is Map<String, dynamic>
          ? MessageUserModel.fromJson(userData)
          : MessageUserModel(id: userData?.toString() ?? ''),
      message: json['message']?.toString() ?? '',
      roomId: json['roomId']?.toString() ?? '',
      files: ((json['file'] ?? json['files']) as List<dynamic>? ?? [])
          .whereType<Map>()
          .map(
            (item) => MessageAttachmentModel.fromJson(
              item.cast<String, dynamic>(),
            ),
          )
          .toList(),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? ''),
    );
  }
}

class PagedMessagesModel {
  PagedMessagesModel({
    required this.data,
    required this.page,
    required this.totalPages,
  });

  final List<ChatMessageModel> data;
  final int page;
  final int totalPages;

  factory PagedMessagesModel.fromJson(Map<String, dynamic> json) {
    final meta = json['meta'] as Map<String, dynamic>? ?? <String, dynamic>{};
    return PagedMessagesModel(
      data: (json['data'] as List<dynamic>? ?? [])
          .whereType<Map>()
          .map(
            (item) => ChatMessageModel.fromJson(item.cast<String, dynamic>()),
          )
          .toList(),
      page: meta['page'] is int ? meta['page'] as int : 1,
      totalPages:
          meta['totalPages'] is int ? meta['totalPages'] as int : 1,
    );
  }
}
