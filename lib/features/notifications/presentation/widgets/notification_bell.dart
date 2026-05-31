import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/bottomNavbar/controllers/bottom_nav_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../controller/notifications_controller.dart';
import '../screens/notifications_screen.dart';

/// Notification bell for the main app bar.
///
/// Shows an unread-count badge bound to [NotificationsController.unreadCount].
/// Resolving the controller via [Get.find]/[Get.put] triggers its `onInit`,
/// which joins the user's socket notification room after login.
class NotificationBell extends StatelessWidget {
  NotificationBell({super.key, this.iconColor});

  /// Optional icon color so the bell can match the hosting app bar.
  final Color? iconColor;

  final NotificationsController _controller =
      Get.isRegistered<NotificationsController>()
      ? Get.find<NotificationsController>()
      : Get.put(
          NotificationsController(Get.find(), Get.find(), Get.find()),
        );

  void _openNotifications() {
    // If hosted inside the bottom-nav dashboard, switch to the notifications
    // tab so the nav bar stays in sync; otherwise push the screen directly.
    if (Get.isRegistered<BottomNavController>()) {
      Get.find<BottomNavController>().changeIndex(2);
    } else {
      Get.to(() => NotificationsScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color color = iconColor ?? AppColors.textBlack;

    return Obx(() {
      final count = _controller.unreadCount.value;
      final hasUnread = count > 0;
      final badgeText = count > 99 ? '99+' : '$count';

      return Stack(
        clipBehavior: Clip.none,
        children: [
          IconButton(
            tooltip: 'Notifications',
            icon: Icon(Icons.notifications_none, color: color),
            onPressed: _openNotifications,
          ),
          if (hasUnread)
            Positioned(
              right: 6,
              top: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 1,
                ),
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                child: Text(
                  badgeText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
              ),
            ),
        ],
      );
    });
  }
}
