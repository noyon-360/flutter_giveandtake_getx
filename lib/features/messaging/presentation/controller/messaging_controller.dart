import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giveandtake/core/network/services/auth_storage_service.dart';
import 'package:giveandtake/core/services/socket_service.dart';

import '../../data/models/chat_message_model.dart';
import '../../data/models/message_room_model.dart';
import '../../data/repositories/messaging_repository.dart';

class MessagingController extends GetxController {
  MessagingController(
    this._repository,
    this._authStorageService,
    this._socketService,
  );

  final MessagingRepository _repository;
  final AuthStorageService _authStorageService;
  final SocketService _socketService;

  final rooms = <MessageRoomModel>[].obs;
  final messages = <ChatMessageModel>[].obs;
  final selectedRoom = Rxn<MessageRoomModel>();
  final attachments = <PlatformFile>[].obs;
  final searchQuery = ''.obs;
  final messageController = TextEditingController();

  final isLoadingRooms = false.obs;
  final isLoadingMessages = false.obs;
  final isLoadingMore = false.obs;
  final isSending = false.obs;
  final hasMoreMessages = true.obs;
  final error = RxnString();

  int _currentPage = 0;
  int _totalPages = 1;
  String? _userId;
  String? _userRole;
  String? _joinedRoomId;
  Function(dynamic)? _newMessageHandler;

  // The flag used to open a freshly-created (or already-existing) conversation
  // once the room list has been (re)loaded.
  String? _pendingOpenUserId;
  final isOpeningConversation = false.obs;

  String? get userId => _userId;
  String? get userRole => _userRole;

  List<MessageRoomModel> get filteredRooms {
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) return rooms;

    return rooms.where((room) {
      final otherUser = room.otherUser(_userId ?? '');
      return (otherUser?.name?.toLowerCase() ?? '').contains(query);
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  Future<void> _initialize() async {
    _userId = await _authStorageService.getUserId();
    _userRole = await _authStorageService.getUserRole();
    if ((_userId ?? '').isEmpty || (_userRole ?? '').isEmpty) return;

    await loadRooms();

    _newMessageHandler = (payload) {
      if (payload is! Map<String, dynamic>) return;
      final newMessage = ChatMessageModel.fromJson(payload);
      if (newMessage.id.isEmpty || newMessage.roomId.isEmpty) return;

      _upsertRoomPreview(
        roomId: newMessage.roomId,
        lastMessage: newMessage.message.trim().isNotEmpty
            ? newMessage.message
            : 'Attachment',
      );

      if (selectedRoom.value?.id == newMessage.roomId) {
        final exists = messages.any((item) => item.id == newMessage.id);
        if (!exists) {
          messages.add(newMessage);
        }
      }
    };

    _socketService.on('newMessage', _newMessageHandler!);
  }

  Future<void> loadRooms() async {
    if ((_userId ?? '').isEmpty || (_userRole ?? '').isEmpty) return;

    isLoadingRooms.value = true;
    error.value = null;
    try {
      final fetched = await _repository.fetchRooms(
        role: _userRole!,
        userId: _userId!,
      );
      rooms.assignAll(fetched);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoadingRooms.value = false;
    }
  }

  /// Create-or-open a conversation with [otherUserId] (e.g. a candidate a
  /// recruiter is viewing) and select it. Safe to call right after navigating
  /// to the messaging screen.
  Future<void> openConversationWith(String otherUserId) async {
    if (otherUserId.isEmpty) return;
    isOpeningConversation.value = true;
    try {
      _userId ??= await _authStorageService.getUserId();
      _userRole ??= await _authStorageService.getUserRole();

      _pendingOpenUserId = otherUserId;
      try {
        // Idempotent: returns the new room id, or null (409) if it already exists.
        await _repository.createRoom(otherUserId: otherUserId);
      } catch (e) {
        error.value = e.toString();
      }

      await loadRooms();

      final target = _findRoomByOtherUser(otherUserId);
      _pendingOpenUserId = null;
      if (target != null) {
        await selectRoom(target);
      }
    } finally {
      isOpeningConversation.value = false;
    }
  }

  MessageRoomModel? _findRoomByOtherUser(String otherUserId) {
    final me = _userId ?? '';
    for (final room in rooms) {
      if (room.otherUser(me)?.id == otherUserId) return room;
    }
    return null;
  }

  Future<void> selectRoom(MessageRoomModel room) async {
    if (_joinedRoomId != null && _joinedRoomId != room.id) {
      _socketService.leaveRoom(_joinedRoomId!);
    }

    selectedRoom.value = room;
    messages.clear();
    attachments.clear();
    messageController.clear();
    _currentPage = 0;
    _totalPages = 1;
    hasMoreMessages.value = true;

    _joinedRoomId = room.id;
    _socketService.joinRoom(room.id);
    await loadMessages(reset: true);
  }

  Future<void> loadMessages({bool reset = false}) async {
    final room = selectedRoom.value;
    if (room == null) return;

    if (reset) {
      isLoadingMessages.value = true;
      _currentPage = 0;
      _totalPages = 1;
      hasMoreMessages.value = true;
      messages.clear();
    } else {
      if (!hasMoreMessages.value || isLoadingMore.value) return;
      isLoadingMore.value = true;
    }

    try {
      final nextPage = _currentPage + 1;
      final response = await _repository.fetchMessages(
        roomId: room.id,
        page: nextPage,
      );

      _currentPage = response.page;
      _totalPages = response.totalPages;
      hasMoreMessages.value = _currentPage < _totalPages;

      final pageMessages = response.data.reversed.toList();
      if (reset) {
        messages.assignAll(pageMessages);
      } else {
        messages.insertAll(0, pageMessages);
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoadingMessages.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> loadOlderMessages() async {
    await loadMessages(reset: false);
  }

  Future<void> pickAttachments() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      withData: false,
      type: FileType.any,
    );

    if (result != null) {
      attachments.assignAll(
        result.files.where((item) => item.path != null && item.path!.isNotEmpty),
      );
    }
  }

  void removeAttachment(int index) {
    attachments.removeAt(index);
  }

  Future<void> sendMessage() async {
    final room = selectedRoom.value;
    final currentUserId = _userId;
    if (room == null || currentUserId == null || currentUserId.isEmpty) return;

    final text = messageController.text.trim();
    if (text.isEmpty && attachments.isEmpty) return;

    isSending.value = true;
    try {
      final files = attachments
          .where((item) => item.path != null && item.path!.isNotEmpty)
          .map((item) => File(item.path!))
          .toList();

      final response = await _repository.sendMessage(
        userId: currentUserId,
        roomId: room.id,
        message: text,
        files: files,
      );

      if (response != null) {
        final exists = messages.any((item) => item.id == response.id);
        if (!exists) {
          messages.add(response);
        }
      }

      _upsertRoomPreview(
        roomId: room.id,
        lastMessage: text.isNotEmpty ? text : 'Attachment',
      );

      messageController.clear();
      attachments.clear();
    } catch (e) {
      error.value = e.toString();
    } finally {
      isSending.value = false;
    }
  }

  void _upsertRoomPreview({
    required String roomId,
    required String lastMessage,
  }) {
    final index = rooms.indexWhere((room) => room.id == roomId);
    if (index == -1) return;

    final updated = rooms[index].copyWith(
      lastMessage: lastMessage,
      updatedAt: DateTime.now().toUtc(),
    );
    rooms.removeAt(index);
    rooms.insert(0, updated);

    if (selectedRoom.value?.id == roomId) {
      selectedRoom.value = updated;
    }
  }

  @override
  void onClose() {
    if (_joinedRoomId != null) {
      _socketService.leaveRoom(_joinedRoomId!);
    }
    if (_newMessageHandler != null) {
      _socketService.off('newMessage', _newMessageHandler!);
    }
    messageController.dispose();
    super.onClose();
  }
}
