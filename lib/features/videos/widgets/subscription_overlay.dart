import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prince1025/features/videos/controllers/video_detail_controller.dart';
import 'package:prince1025/features/videos/widgets/subscription_warning_section.dart';

class SubscriptionOverlay extends StatelessWidget {
  final bool isDarkTheme;

  const SubscriptionOverlay({super.key, required this.isDarkTheme});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VideoDetailController>();

    return Obx(() {
      if (controller.showSubscriptionWarning.value) {
        return Container(
          color: Colors.black.withValues(alpha: 0.5),
          child: Center(
            child: SubscriptionWarningSection(isDarkTheme: isDarkTheme),
          ),
        );
      }
      return const SizedBox.shrink();
    });
  }
}
