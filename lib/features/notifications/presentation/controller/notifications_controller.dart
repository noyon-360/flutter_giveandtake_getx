import 'package:get/get.dart';
import 'package:giveandtake/core/network/services/auth_storage_service.dart';
import 'package:giveandtake/core/services/socket_service.dart';

import '../../data/models/app_notification_model.dart';
import '../../data/repositories/notification_repository.dart';

class NotificationsController extends GetxController {
  NotificationsController(
    this._repository,
    this._authStorageService,
    this._socketService,
  );

  final NotificationRepository _repository;
  final AuthStorageService _authStorageService;
  final SocketService _socketService;

  final notifications = <AppNotificationModel>[].obs;
  final unreadCount = 0.obs;
  final isLoading = false.obs;
  final isMarking = false.obs;
  final error = RxnString();

  String? _userId;
  // Cached so the list can route a tap by role synchronously (role is read from
  // secure storage, which is async).
  String? userRole;
  Function(dynamic)? _newNotificationHandler;
  Function(dynamic)? _countHandler;

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  Future<void> _initialize() async {
    _userId = await _authStorageService.getUserId();
    if (_userId == null || _userId!.isEmpty) return;

    userRole = await _authStorageService.getUserRole();

    await loadNotifications();
    _socketService.joinNotification(_userId!);

    _newNotificationHandler = (payload) {
      final raw = payload is Map<String, dynamic>
          ? (payload['notification'] ??
                payload['n'] ??
                payload['notificationDoc'] ??
                payload)
          : payload;

      if (raw is! Map<String, dynamic>) return;
      final notification = AppNotificationModel.fromJson(raw);
      if (notification.id.isEmpty) return;

      final exists = notifications.any((item) => item.id == notification.id);
      if (!exists) {
        notifications.insert(0, notification);
      }

      final count = _extractCount(payload);
      if (count != null) {
        unreadCount.value = count;
      } else if (!notification.isViewed) {
        unreadCount.value += 1;
      }
    };

    _countHandler = (payload) {
      final count = _extractCount(payload);
      if (count != null) {
        unreadCount.value = count;
      }
    };

    _socketService.on('newNotification', _newNotificationHandler!);
    _socketService.on('notificationCountUpdated', _countHandler!);
  }

  Future<void> loadNotifications() async {
    final userId = _userId ?? await _authStorageService.getUserId();
    if (userId == null || userId.isEmpty) return;

    isLoading.value = true;
    error.value = null;
    try {
      final items = await _repository.fetchNotifications(userId);
      notifications.assignAll(items);
      unreadCount.value = items.where((item) => !item.isViewed).length;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAllRead() async {
    final userId = _userId;
    if (userId == null || userId.isEmpty) return;

    isMarking.value = true;
    try {
      final count = await _repository.markAllRead(userId);
      notifications.assignAll(
        notifications.map((item) => item.copyWith(isViewed: true)).toList(),
      );
      unreadCount.value = count ?? 0;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isMarking.value = false;
    }
  }

  Future<void> markRead(String notificationId) async {
    final userId = _userId;
    if (userId == null || userId.isEmpty || notificationId.isEmpty) return;

    try {
      final index = notifications.indexWhere((item) => item.id == notificationId);
      if (index != -1 && !notifications[index].isViewed) {
        notifications[index] = notifications[index].copyWith(isViewed: true);
        unreadCount.value = unreadCount.value > 0 ? unreadCount.value - 1 : 0;
      }

      final count = await _repository.markRead(userId, notificationId);
      if (count != null) {
        unreadCount.value = count;
      }
    } catch (e) {
      error.value = e.toString();
    }
  }

  int? _extractCount(dynamic payload) {
    if (payload is! Map<String, dynamic>) return null;
    if (payload['count'] is int) return payload['count'] as int;
    return int.tryParse(payload['count']?.toString() ?? '');
  }

  @override
  void onClose() {
    if (_newNotificationHandler != null) {
      _socketService.off('newNotification', _newNotificationHandler!);
    }
    if (_countHandler != null) {
      _socketService.off('notificationCountUpdated', _countHandler!);
    }
    super.onClose();
  }
}
