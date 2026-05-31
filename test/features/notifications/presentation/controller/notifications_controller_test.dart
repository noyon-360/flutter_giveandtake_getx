import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:giveandtake/core/network/services/auth_storage_service.dart';
import 'package:giveandtake/core/services/socket_service.dart';
import 'package:giveandtake/features/notifications/data/models/app_notification_model.dart';
import 'package:giveandtake/features/notifications/data/repositories/notification_repository.dart';
import 'package:giveandtake/features/notifications/presentation/controller/notifications_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('NotificationsController', () {
    setUp(() {
      Get.testMode = true;
    });

    tearDown(() {
      Get.reset();
    });

    test('loads notifications, marks reads, and reacts to socket events', () async {
      final repository = FakeNotificationRepository(
        notifications: [
          AppNotificationModel(
            id: 'n1',
            message: 'Unread',
            isViewed: false,
          ),
          AppNotificationModel(
            id: 'n2',
            message: 'Viewed',
            isViewed: true,
          ),
        ],
        markReadCount: 0,
        markAllReadCount: 0,
      );
      final socket = FakeSocketService();
      final controller = NotificationsController(
        repository,
        FakeAuthStorageService(userId: 'user-1'),
        socket,
      );

      controller.onInit();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(repository.fetchCalls, ['user-1']);
      expect(socket.joinedNotificationUsers, ['user-1']);
      expect(controller.notifications.length, 2);
      expect(controller.unreadCount.value, 1);

      await controller.markRead('n1');
      expect(repository.markReadCalls, ['user-1:n1']);
      expect(controller.unreadCount.value, 0);
      expect(controller.notifications.firstWhere((item) => item.id == 'n1').isViewed, isTrue);

      socket.emit(
        'newNotification',
        {
          'notification': {
            '_id': 'n3',
            'message': 'Socket push',
            'isViewed': false,
          },
        },
      );
      expect(controller.notifications.first.id, 'n3');
      expect(controller.unreadCount.value, 1);

      socket.emit('notificationCountUpdated', {'count': 7});
      expect(controller.unreadCount.value, 7);

      await controller.markAllRead();
      expect(repository.markAllReadCalls, ['user-1']);
      expect(controller.notifications.every((item) => item.isViewed), isTrue);
      expect(controller.unreadCount.value, 0);

      controller.onClose();
    });
  });
}

class FakeNotificationRepository extends NotificationRepository {
  FakeNotificationRepository({
    required this.notifications,
    required this.markReadCount,
    required this.markAllReadCount,
  });

  final List<AppNotificationModel> notifications;
  final int? markReadCount;
  final int? markAllReadCount;

  final List<String> fetchCalls = <String>[];
  final List<String> markReadCalls = <String>[];
  final List<String> markAllReadCalls = <String>[];

  @override
  Future<List<AppNotificationModel>> fetchNotifications(String userId) async {
    fetchCalls.add(userId);
    return notifications;
  }

  @override
  Future<int?> markRead(String userId, String notificationId) async {
    markReadCalls.add('$userId:$notificationId');
    return markReadCount;
  }

  @override
  Future<int?> markAllRead(String userId) async {
    markAllReadCalls.add(userId);
    return markAllReadCount;
  }
}

class FakeAuthStorageService extends AuthStorageService {
  FakeAuthStorageService({
    this.userId,
    this.userRole,
  });

  final String? userId;
  final String? userRole;

  @override
  Future<String?> getUserId() async => userId;

  @override
  Future<String?> getUserRole() async => userRole;
}

class FakeSocketService extends SocketService {
  final Map<String, List<Function(dynamic)>> _handlers =
      <String, List<Function(dynamic)>>{};
  final List<String> joinedNotificationUsers = <String>[];
  final List<String> joinedRooms = <String>[];
  final List<String> leftRooms = <String>[];

  @override
  Future<void> initialize() async {}

  @override
  void joinNotification(String userId) {
    joinedNotificationUsers.add(userId);
  }

  @override
  void joinRoom(String roomId) {
    joinedRooms.add(roomId);
  }

  @override
  void leaveRoom(String roomId) {
    leftRooms.add(roomId);
  }

  @override
  void on(String event, Function(dynamic) handler) {
    _handlers.putIfAbsent(event, () => <Function(dynamic)>[]).add(handler);
  }

  @override
  void off(String event, [Function(dynamic)? handler]) {
    if (!_handlers.containsKey(event)) return;
    if (handler == null) {
      _handlers.remove(event);
      return;
    }
    _handlers[event]!.remove(handler);
  }

  void emit(String event, dynamic payload) {
    for (final handler in List<Function(dynamic)>.from(_handlers[event] ?? const [])) {
      handler(payload);
    }
  }
}
