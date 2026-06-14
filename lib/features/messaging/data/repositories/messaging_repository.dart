import 'dart:io';

import 'package:dio/dio.dart';

import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/constants/key_constants.dart';
import '../../../../core/network/services/secure_store_services.dart';
import '../models/chat_message_model.dart';
import '../models/message_room_model.dart';

class MessagingRepository {
  MessagingRepository({SecureStoreServices? secureStoreServices})
    : _secureStoreServices = secureStoreServices ?? SecureStoreServices();

  final SecureStoreServices _secureStoreServices;

  Future<Dio> _dio({bool multipart = false}) async {
    final dio = Dio();
    dio.options.headers.addAll({
      'Accept': 'application/json',
      'Content-Type': multipart ? 'multipart/form-data' : 'application/json',
    });
    final token = await _secureStoreServices.retrieveData(KeyConstants.accessToken);
    if (token != null && token.isNotEmpty) {
      dio.options.headers['Authorization'] = 'Bearer $token';
    }
    return dio;
  }

  /// Create a conversation with [otherUserId]. The backend forces the
  /// authenticated user into their own participant slot (by role), so we only
  /// send the counterpart's id. Returns the new room id, or null when the room
  /// already exists (HTTP 409) — the caller then locates it from the room list.
  Future<String?> createRoom({required String otherUserId}) async {
    final dio = await _dio();
    try {
      final response = await dio.post(
        ApiConstants.messaging.createRoom,
        data: {'userId': otherUserId},
      );
      final data = response.data is Map ? response.data['data'] : null;
      final id = data is Map ? (data['_id'] ?? data['id']) : null;
      return id?.toString();
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) return null;
      rethrow;
    }
  }

  Future<List<MessageRoomModel>> fetchRooms({
    required String role,
    required String userId,
  }) async {
    final dio = await _dio();
    final response = await dio.get(
      ApiConstants.messaging.rooms(role: role, userId: userId),
    );
    final data = response.data is Map<String, dynamic>
        ? response.data['data']
        : null;
    if (data is! List) {
      return <MessageRoomModel>[];
    }

    return data
        .whereType<Map>()
        .map(
          (item) => MessageRoomModel.fromJson(item.cast<String, dynamic>()),
        )
        .toList();
  }

  Future<PagedMessagesModel> fetchMessages({
    required String roomId,
    required int page,
    int limit = 20,
  }) async {
    final dio = await _dio();
    final response = await dio.get(
      ApiConstants.messaging.roomMessages(
        roomId: roomId,
        page: page,
        limit: limit,
      ),
    );

    if (response.data is Map<String, dynamic>) {
      return PagedMessagesModel.fromJson(response.data);
    }
    return PagedMessagesModel(data: const [], page: 1, totalPages: 1);
  }

  Future<ChatMessageModel?> sendMessage({
    required String userId,
    required String roomId,
    required String message,
    required List<File> files,
  }) async {
    final dio = await _dio(multipart: true);
    final formData = FormData.fromMap({
      'userId': userId,
      'roomId': roomId,
      'message': message,
      'files': [
        for (final file in files)
          await MultipartFile.fromFile(
            file.path,
            filename: file.path.split(Platform.pathSeparator).last,
          ),
      ],
    });

    final response = await dio.post(
      ApiConstants.messaging.sendMessage,
      data: formData,
    );

    final data = response.data is Map<String, dynamic>
        ? response.data['data']
        : null;
    if (data is Map<String, dynamic>) {
      return ChatMessageModel.fromJson(data);
    }
    return null;
  }
}
