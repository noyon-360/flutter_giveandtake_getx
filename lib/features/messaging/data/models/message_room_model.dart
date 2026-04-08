import 'chat_message_model.dart';

class MessageRoomModel {
  MessageRoomModel({
    required this.id,
    required this.user,
    this.recruiter,
    this.company,
    required this.messageAccepted,
    required this.lastMessage,
    this.lastMessageSender,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final MessageUserModel user;
  final MessageUserModel? recruiter;
  final MessageUserModel? company;
  final bool messageAccepted;
  final String lastMessage;
  final String? lastMessageSender;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory MessageRoomModel.fromJson(Map<String, dynamic> json) {
    return MessageRoomModel(
      id: (json['_id'] ?? '').toString(),
      user: MessageUserModel.fromJson(
        (json['userId'] as Map<String, dynamic>? ?? <String, dynamic>{}),
      ),
      recruiter: json['recruiterId'] is Map<String, dynamic>
          ? MessageUserModel.fromJson(json['recruiterId'])
          : null,
      company: json['companyId'] is Map<String, dynamic>
          ? MessageUserModel.fromJson(json['companyId'])
          : null,
      messageAccepted: json['messageAccepted'] == true,
      lastMessage: json['lastMessage']?.toString() ?? '',
      lastMessageSender: json['lastMessageSender']?.toString(),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? ''),
    );
  }

  MessageUserModel? otherUser(String currentUserId) {
    if (user.id == currentUserId) {
      return recruiter ?? company;
    }
    return user;
  }

  MessageRoomModel copyWith({
    String? lastMessage,
    String? lastMessageSender,
    DateTime? updatedAt,
  }) {
    return MessageRoomModel(
      id: id,
      user: user,
      recruiter: recruiter,
      company: company,
      messageAccepted: messageAccepted,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageSender: lastMessageSender ?? this.lastMessageSender,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
