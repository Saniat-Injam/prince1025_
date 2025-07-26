import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prince1025/core/common/widgets/custom_app_bar.dart';
import 'package:prince1025/core/utils/constants/colors.dart';
import 'package:prince1025/core/utils/constants/image_path.dart';
import 'package:prince1025/features/notifications/controllers/notification_controller.dart';
import 'package:prince1025/features/notifications/widgets/notification_card.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationController());
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final String? backgroundImage =
        isDarkTheme ? ImagePath.darkSettingScreenbackground : null;
    final textColor =
        isDarkTheme ? const Color(0xFFF5F5F5) : AppColors.primaryDarkBlue;

    return Container(
      decoration: BoxDecoration(
        image:
            isDarkTheme && backgroundImage != null
                ? DecorationImage(
                  image: AssetImage(backgroundImage),
                  fit: BoxFit.cover,
                )
                : null,
      ),
      child: Scaffold(
        backgroundColor: isDarkTheme ? Colors.transparent : Colors.white,
        appBar: CustomAppBar(
          title: 'Notification',
          backgroundColor: isDarkTheme ? Colors.transparent : Colors.white,
          foregroundColor: isDarkTheme ? Colors.white : null,
          elevation: isDarkTheme ? 0 : 1,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Unread Section
              Obx(() {
                final unreadNotifications = controller.unreadNotifications;
                if (unreadNotifications.isNotEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Unread',
                        style: TextStyle(
                          fontFamily: 'Enwallowify',
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...unreadNotifications.map(
                        (notification) => NotificationCard(
                          notification: notification,
                          controller: controller,
                          isDarkTheme: isDarkTheme,
                          textColor: textColor,
                          isUnread: true,
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  );
                }
                return const SizedBox.shrink();
              }),

              // Read Section
              Obx(() {
                final readNotifications = controller.readNotifications;
                if (readNotifications.isNotEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Read',
                        style: TextStyle(
                          fontFamily: 'Enwallowify',
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...readNotifications.map(
                        (notification) => NotificationCard(
                          notification: notification,
                          controller: controller,
                          isDarkTheme: isDarkTheme,
                          textColor: textColor,
                          isUnread: false,
                        ),
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              }),
            ],
          ),
        ),
      ),
    );
  }
}
