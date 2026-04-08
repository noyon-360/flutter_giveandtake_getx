import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../data/models/chat_message_model.dart';
import '../../data/models/message_room_model.dart';
import '../controller/messaging_controller.dart';

class MessagingScreen extends StatelessWidget {
  MessagingScreen({super.key});

  final MessagingController controller =
      Get.isRegistered<MessagingController>()
      ? Get.find<MessagingController>()
      : Get.put(
          MessagingController(Get.find(), Get.find(), Get.find()),
        );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 900;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Messaging'),
            automaticallyImplyLeading:
                !isWide && controller.selectedRoom.value != null,
          ),
          body: Obx(() {
            if (controller.isLoadingRooms.value &&
                controller.rooms.isEmpty &&
                controller.selectedRoom.value == null) {
              return const Center(child: CircularProgressIndicator());
            }

            if (isWide) {
              return Row(
                children: [
                  SizedBox(
                    width: 320,
                    child: _RoomList(controller: controller),
                  ),
                  const VerticalDivider(width: 1),
                  Expanded(
                    child: controller.selectedRoom.value == null
                        ? const Center(child: Text('Select a conversation'))
                        : _ChatArea(controller: controller),
                  ),
                ],
              );
            }

            if (controller.selectedRoom.value == null) {
              return _RoomList(controller: controller);
            }

            return _ChatArea(controller: controller);
          }),
        );
      },
    );
  }
}

class _RoomList extends StatelessWidget {
  const _RoomList({required this.controller});

  final MessagingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Search conversations',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => controller.searchQuery.value = value,
          ),
        ),
        Expanded(
          child: Obx(() {
            final rooms = controller.filteredRooms;
            if (rooms.isEmpty) {
              return const Center(child: Text('No messages found.'));
            }

            return RefreshIndicator(
              onRefresh: controller.loadRooms,
              child: ListView.separated(
                itemCount: rooms.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final room = rooms[index];
                  final otherUser = room.otherUser(controller.userId ?? '');
                  return ListTile(
                    selected: controller.selectedRoom.value?.id == room.id,
                    leading: CircleAvatar(
                      child: Text(
                        (otherUser?.name?.isNotEmpty ?? false)
                            ? otherUser!.name![0].toUpperCase()
                            : 'U',
                      ),
                    ),
                    title: Text(otherUser?.name ?? 'Unknown User'),
                    subtitle: Text(
                      room.lastMessage.isEmpty ? 'No messages yet' : room.lastMessage,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Text(
                      _formatDate(room.updatedAt),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    onTap: () => controller.selectRoom(room),
                  );
                },
              ),
            );
          }),
        ),
      ],
    );
  }

  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) return '';
    final now = DateTime.now();
    final local = dateTime.toLocal();
    if (now.difference(local).inHours < 24) {
      return DateFormat('HH:mm').format(local);
    }
    if (now.difference(local).inDays < 7) {
      return '${now.difference(local).inDays}d';
    }
    return DateFormat('dd MMM').format(local);
  }
}

class _ChatArea extends StatelessWidget {
  const _ChatArea({required this.controller});

  final MessagingController controller;

  @override
  Widget build(BuildContext context) {
    final room = controller.selectedRoom.value;
    if (room == null) {
      return const SizedBox.shrink();
    }

    final otherUser = room.otherUser(controller.userId ?? '');

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
          ),
          child: Row(
            children: [
              if (MediaQuery.of(context).size.width < 900)
                IconButton(
                  onPressed: () => controller.selectedRoom.value = null,
                  icon: const Icon(Icons.arrow_back),
                ),
              CircleAvatar(
                child: Text(
                  (otherUser?.name?.isNotEmpty ?? false)
                      ? otherUser!.name![0].toUpperCase()
                      : 'U',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  otherUser?.name ?? 'Conversation',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Obx(() {
            if (controller.isLoadingMessages.value &&
                controller.messages.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                if (controller.hasMoreMessages.value)
                  TextButton(
                    onPressed: controller.isLoadingMore.value
                        ? null
                        : controller.loadOlderMessages,
                    child: Text(
                      controller.isLoadingMore.value
                          ? 'Loading...'
                          : 'Load older messages',
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: controller.messages.length,
                    itemBuilder: (context, index) {
                      final message = controller.messages[index];
                      final isOwn = message.userId?.id == controller.userId;
                      return _MessageBubble(
                        message: message,
                        isOwn: isOwn,
                      );
                    },
                  ),
                ),
              ],
            );
          }),
        ),
        Obx(() {
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (controller.attachments.isNotEmpty)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: List.generate(controller.attachments.length, (
                        index,
                      ) {
                        final file = controller.attachments[index];
                        return Chip(
                          label: Text(
                            file.name,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onDeleted: () => controller.removeAttachment(index),
                        );
                      }),
                    ),
                  ),
                Row(
                  children: [
                    IconButton(
                      onPressed: controller.pickAttachments,
                      icon: const Icon(Icons.attach_file),
                    ),
                    Expanded(
                      child: TextField(
                        controller: controller.messageController,
                        minLines: 1,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          hintText: 'Type your message',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: controller.isSending.value
                          ? null
                          : controller.sendMessage,
                      icon: controller.isSending.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.send),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.message,
    required this.isOwn,
  });

  final ChatMessageModel message;
  final bool isOwn;

  @override
  Widget build(BuildContext context) {
    final bubbleColor = isOwn ? Colors.blue.shade600 : Colors.grey.shade200;
    final textColor = isOwn ? Colors.white : Colors.black87;

    return Align(
      alignment: isOwn ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 360),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment:
              isOwn ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (message.message.trim().isNotEmpty)
              Text(
                message.message,
                style: TextStyle(color: textColor, height: 1.4),
              ),
            if (message.files.isNotEmpty) ...[
              if (message.message.trim().isNotEmpty) const SizedBox(height: 8),
              for (final file in message.files)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    file.filename,
                    style: TextStyle(
                      color: textColor,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
            ],
            const SizedBox(height: 6),
            Text(
              _formatMessageTime(message.createdAt),
              style: TextStyle(
                color: isOwn ? Colors.white70 : Colors.black54,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatMessageTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    return DateFormat('dd MMM, hh:mm a').format(dateTime.toLocal());
  }
}
