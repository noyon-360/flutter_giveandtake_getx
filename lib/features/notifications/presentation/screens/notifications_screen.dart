import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controller/notifications_controller.dart';

class NotificationsScreen extends StatelessWidget {
  NotificationsScreen({super.key});

  final NotificationsController controller =
      Get.isRegistered<NotificationsController>()
      ? Get.find<NotificationsController>()
      : Get.put(
          NotificationsController(Get.find(), Get.find(), Get.find()),
        );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text('Notifications (${controller.unreadCount.value})'),
        ),
        actions: [
          Obx(
            () => TextButton(
              onPressed: controller.isMarking.value ||
                      controller.unreadCount.value == 0
                  ? null
                  : controller.markAllRead,
              child: Text(
                controller.isMarking.value ? 'Marking...' : 'Mark All Read',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.notifications.isEmpty) {
          return const Center(child: Text('No notifications found.'));
        }

        return RefreshIndicator(
          onRefresh: controller.loadNotifications,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: controller.notifications.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final notification = controller.notifications[index];
              return InkWell(
                onTap: notification.isViewed
                    ? null
                    : () => controller.markRead(notification.id),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: notification.isViewed
                        ? Colors.white
                        : Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: notification.isViewed
                          ? Colors.grey.shade200
                          : Colors.blue.shade100,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: notification.isViewed
                            ? Colors.grey.shade200
                            : Colors.blue.shade100,
                        child: Icon(
                          Icons.notifications_none,
                          color: notification.isViewed
                              ? Colors.grey.shade700
                              : Colors.blue.shade700,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notification.message,
                              style: const TextStyle(fontSize: 14, height: 1.4),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _formatDate(notification.createdAt),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!notification.isViewed)
                        Container(
                          width: 10,
                          height: 10,
                          margin: const EdgeInsets.only(top: 6),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) return 'Just now';
    return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime.toLocal());
  }
}
