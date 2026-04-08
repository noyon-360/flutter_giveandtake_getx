import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:giveandtake/core/network/services/auth_storage_service.dart';
import 'package:giveandtake/core/services/socket_service.dart';
import 'package:giveandtake/features/messaging/data/models/chat_message_model.dart';
import 'package:giveandtake/features/messaging/data/models/message_room_model.dart';
import 'package:giveandtake/features/messaging/data/repositories/messaging_repository.dart';
import 'package:giveandtake/features/messaging/presentation/controller/messaging_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MessagingController', () {
    setUp(() {
      Get.testMode = true;
    });

    tearDown(() {
      Get.reset();
    });

    test('loads rooms, merges paged history, and handles realtime messages', () async {
      final room = MessageRoomModel(
        id: 'room-1',
        user: MessageUserModel(id: 'user-1', name: 'Candidate'),
        recruiter: MessageUserModel(id: 'recruiter-1', name: 'Recruiter'),
        messageAccepted: true,
        lastMessage: 'Old preview',
      );
      final repository = FakeMessagingRepository(
        rooms: [room],
        pages: <int, PagedMessagesModel>{
          1: PagedMessagesModel(
            data: [
              ChatMessageModel(
                id: 'm1',
                userId: MessageUserModel(id: 'recruiter-1'),
                message: 'First page older',
                roomId: 'room-1',
                files: const [],
              ),
              ChatMessageModel(
                id: 'm2',
                userId: MessageUserModel(id: 'user-1'),
                message: 'First page newer',
                roomId: 'room-1',
                files: const [],
              ),
            ],
            page: 1,
            totalPages: 2,
          ),
          2: PagedMessagesModel(
            data: [
              ChatMessageModel(
                id: 'm0',
                userId: MessageUserModel(id: 'recruiter-1'),
                message: 'Second page oldest',
                roomId: 'room-1',
                files: const [],
              ),
            ],
            page: 2,
            totalPages: 2,
          ),
        },
      );
      final socket = FakeSocketService();
      final controller = MessagingController(
        repository,
        FakeAuthStorageService(
          userId: 'user-1',
          userRole: 'candidate',
        ),
        socket,
      );

      controller.onInit();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(repository.fetchRoomCalls, ['candidate:user-1']);
      expect(controller.rooms.length, 1);

      await controller.selectRoom(room);
      expect(socket.joinedRooms, ['room-1']);
      expect(repository.fetchMessageCalls, ['room-1:1:20']);
      expect(controller.messages.map((item) => item.id).toList(), ['m2', 'm1']);
      expect(controller.hasMoreMessages.value, isTrue);

      await controller.loadOlderMessages();
      expect(repository.fetchMessageCalls, ['room-1:1:20', 'room-1:2:20']);
      expect(controller.messages.map((item) => item.id).toList(), ['m0', 'm2', 'm1']);
      expect(controller.hasMoreMessages.value, isFalse);

      socket.emit(
        'newMessage',
        {
          '_id': 'm3',
          'roomId': 'room-1',
          'userId': {'_id': 'recruiter-1', 'name': 'Recruiter'},
          'message': 'Realtime update',
          'files': const [],
        },
      );

      expect(controller.messages.last.id, 'm3');
      expect(controller.rooms.first.id, 'room-1');
      expect(controller.rooms.first.lastMessage, 'Realtime update');
      expect(controller.selectedRoom.value!.lastMessage, 'Realtime update');

      controller.onClose();
      expect(socket.leftRooms, ['room-1']);
    });
  });
}

class FakeMessagingRepository extends MessagingRepository {
  FakeMessagingRepository({
    required this.rooms,
    required this.pages,
  });

  final List<MessageRoomModel> rooms;
  final Map<int, PagedMessagesModel> pages;

  final List<String> fetchRoomCalls = <String>[];
  final List<String> fetchMessageCalls = <String>[];

  @override
  Future<List<MessageRoomModel>> fetchRooms({
    required String role,
    required String userId,
  }) async {
    fetchRoomCalls.add('$role:$userId');
    return rooms;
  }

  @override
  Future<PagedMessagesModel> fetchMessages({
    required String roomId,
    required int page,
    int limit = 20,
  }) async {
    fetchMessageCalls.add('$roomId:$page:$limit');
    return pages[page] ?? PagedMessagesModel(data: const [], page: page, totalPages: page);
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
  final List<String> joinedRooms = <String>[];
  final List<String> leftRooms = <String>[];

  @override
  void initialize() {}

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
