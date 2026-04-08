import 'package:dio/dio.dart';

import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/constants/key_constants.dart';
import '../../../../core/network/services/secure_store_services.dart';
import '../models/app_notification_model.dart';

class NotificationRepository {
  NotificationRepository({SecureStoreServices? secureStoreServices})
    : _secureStoreServices = secureStoreServices ?? SecureStoreServices();

  final SecureStoreServices _secureStoreServices;

  Future<Dio> _dio() async {
    final dio = Dio();
    dio.options.headers.addAll({
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    });
    final token = await _secureStoreServices.retrieveData(KeyConstants.accessToken);
    if (token != null && token.isNotEmpty) {
      dio.options.headers['Authorization'] = 'Bearer $token';
    }
    return dio;
  }

  Future<List<AppNotificationModel>> fetchNotifications(String userId) async {
    final dio = await _dio();
    final response = await dio.get(ApiConstants.notification.list(userId));
    final data = response.data is Map<String, dynamic>
        ? response.data['data']
        : null;

    if (data is! List) {
      return <AppNotificationModel>[];
    }

    return data
        .whereType<Map>()
        .map(
          (item) => AppNotificationModel.fromJson(
            item.cast<String, dynamic>(),
          ),
        )
        .toList();
  }

  Future<int?> markAllRead(String userId) async {
    final dio = await _dio();
    final response = await dio.patch(ApiConstants.notification.markAllRead(userId));
    return _extractUnreadCount(response.data);
  }

  Future<int?> markRead(String userId, String notificationId) async {
    final dio = await _dio();
    final response = await dio.patch(
      ApiConstants.notification.markRead(userId, notificationId),
    );
    return _extractUnreadCount(response.data);
  }

  int? _extractUnreadCount(dynamic data) {
    if (data is! Map<String, dynamic>) return null;
    final unreadCount = data['unreadCount'] ?? data['data']?['unreadCount'];
    if (unreadCount is int) return unreadCount;
    return int.tryParse(unreadCount?.toString() ?? '');
  }
}
