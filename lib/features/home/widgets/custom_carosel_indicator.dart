import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:prince1025/features/home/controllers/home_controller.dart';

class CustomCaroselIndicator extends StatelessWidget {
  final HomeController homeController;
  final bool isDarkTheme;
  const CustomCaroselIndicator({
    super.key,
    required this.homeController,
    required this.isDarkTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          homeController.carosels.length,
          (index) => Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  homeController.currentPage.value == index
                      ? (isDarkTheme
                          ? Colors.white.withValues(alpha: 0.8)
                          : const Color(0xFF005E89))
                      : (isDarkTheme
                          ? Colors.white.withValues(alpha: 0.6)
                          : const Color(0xFFB0CDDA)),
            ),
          ),
        ),
      ),
    );
  }
}
