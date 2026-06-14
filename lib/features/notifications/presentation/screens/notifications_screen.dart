import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:giveandtake/features/Home/presentation/screens/my_plan_screen.dart';
import 'package:giveandtake/features/messaging/presentation/screens/messaging_screen.dart';
import 'package:giveandtake/features/profile_dasboard/presentation/screens/job_history.dart';

import '../../../../core/bottomNavbar/controllers/bottom_nav_controller.dart';
import '../../data/models/app_notification_model.dart';
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back',
          onPressed: () {
            // Pushed as its own route -> pop it. Otherwise it's the bottom-nav
            // tab (nothing to pop), so fall back to the Home tab.
            if (Navigator.canPop(context)) {
              Get.back();
            } else if (Get.isRegistered<BottomNavController>()) {
              Get.find<BottomNavController>().changeIndex(0);
            }
          },
        ),
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
                onTap: () => _onNotificationTap(notification),
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

  // Mark the tapped notification read (if needed) and route to the screen it
  // relates to. Navigation only targets screens that initialise their own GetX
  // controllers, so a tap can never crash on a missing dependency; anything we
  // can't safely route just marks-as-read.
  void _onNotificationTap(AppNotificationModel notification) {
    if (!notification.isViewed) {
      controller.markRead(notification.id);
    }
    final destination = _destinationFor(notification);
    if (destination != null) {
      Get.to(() => destination);
    }
  }

  Widget? _destinationFor(AppNotificationModel notification) {
    final role = controller.userRole;
    final isOwner = role == 'recruiter' || role == 'company';

    switch (notification.type) {
      // Candidate: you applied / your application status changed -> applications.
      case 'job_application_confirmation':
        return const JobHistoryScreen();
      case 'job_application_status':
        // Owners also receive this (job approved/declined) but that destination
        // needs controllers not guaranteed to be live here, so only the
        // candidate case deep-links for now.
        return isOwner ? null : const JobHistoryScreen();
      // Billing / subscription -> the plan screen (where they can renew/upgrade).
      case 'payg_expired':
      case 'Subscription Expired':
        return const MyPlanScreen();
      // New chat message -> messaging.
      case 'message':
        return MessagingScreen();
      default:
        return null;
    }
  }

  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) return 'Just now';
    return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime.toLocal());
  }
}
