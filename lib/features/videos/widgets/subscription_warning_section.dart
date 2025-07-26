import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prince1025/core/utils/constants/colors.dart';
import 'package:prince1025/features/profile/widgets/custom_ev_button.dart';
import 'package:prince1025/core/common/styles/global_text_style.dart';
import 'package:prince1025/routes/app_routes.dart';

class SubscriptionWarningSection extends StatelessWidget {
  final bool isDarkTheme;

  const SubscriptionWarningSection({super.key, required this.isDarkTheme});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
      child: Container(
        padding: EdgeInsets.only(top: 16, bottom: 27),
        decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.4)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Unlock Premium Content',
              style: TextStyle(
                fontFamily: 'Enwallowify',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Enjoy the full video and our entire library of meditation content by subscribing to GlowUp premium.',
              style: getDMTextStyle(fontSize: 12, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 300,
              height: 42,
              child: CustomEVButton(
                customColor: !isDarkTheme ? AppColors.primaryDarkBlue : null,
                textColor: !isDarkTheme ? Colors.white : null,
                text: 'Subscribe Now',
                onPressed: () {
                  Get.toNamed(AppRoute.getSubscriptionScreen());
                },
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Get.back();
                Get.snackbar(
                  'Preview Ended',
                  'Subscription required for full video.',
                );
              },
              child: Text(
                'Maybe Later',
                style: getDMTextStyle(
                  color:
                      (isDarkTheme
                          ? const Color(0xFFC7B0F5)
                          : const Color(0xFFA2DFF7)),
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
