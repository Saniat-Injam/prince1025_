import 'package:flutter/material.dart';
import 'package:prince1025/core/common/styles/global_text_style.dart';
import 'package:prince1025/features/profile/controllers/profile_controller.dart';
import 'package:get/get.dart';
import 'package:prince1025/features/profile/views/subscription_screen.dart';
import 'package:prince1025/features/profile/widgets/custom_ev_button.dart';
import 'package:prince1025/core/common/widgets/custom_container.dart';

class SubscriptionSection extends StatelessWidget {
  final ProfileController controller;
  final Color textColor;
  final bool isDarkTheme;

  const SubscriptionSection({
    required this.controller,
    required this.textColor,
    required this.isDarkTheme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      isDarkTheme: isDarkTheme,
      borderRadius: 12,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          final currentSubscription =
              controller.userModel.value?.currentSubscription;
          final isSubscribed =
              controller.userModel.value?.isSubscribed ?? false;

          // Show loading state if userModel is null
          if (controller.userModel.value == null) {
            return Column(
              children: [
                CircularProgressIndicator(
                  color: isDarkTheme ? Colors.white : Colors.blue,
                ),
                const SizedBox(height: 8),
                Text(
                  'Loading subscription...',
                  style: TextStyle(
                    fontFamily: 'Enwallowify',
                    fontSize: 14,
                    color: textColor.withValues(alpha: .7),
                  ),
                ),
              ],
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Plan name or subscription status
                  Expanded(
                    child: Text(
                      isSubscribed && currentSubscription?.plan != null
                          ? '${currentSubscription!.plan!.name} Plan'
                          : 'Premium Plan',
                      style: TextStyle(
                        fontFamily: 'Enwallowify',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                  ),
                  // Active Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isDarkTheme
                              ? const Color(0xFF071123)
                              : Colors.green.shade100,
                      borderRadius: BorderRadius.circular(6.0),
                      border:
                          isDarkTheme
                              ? Border.all(
                                color: const Color(0xFF133663),
                                width: 0.5,
                              )
                              : null,
                    ),
                    child: Text(
                      'Active',
                      style: getDMTextStyle(
                        color:
                            isDarkTheme
                                ? const Color(0xFFF5F5F5)
                                : Colors.green.shade800,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Days remaining and renewal info with progress
              if (isSubscribed && currentSubscription != null)
                Row(
                  children: [
                    // Renewal date
                    Text(
                      'Renews ${currentSubscription.formattedEndDate}',
                      style: getDMTextStyle(
                        fontSize: 14,
                        color:
                            isDarkTheme
                                ? const Color(0xFFBEBEBE)
                                : const Color(0xff939393),
                      ),
                    ),
                    Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${currentSubscription.daysRemaining} days left',
                        style: getDMTextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.orange.shade700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                )
              else
                Text(
                  'Premium subscription active',
                  style: getDMTextStyle(
                    fontSize: 14,
                    color:
                        isDarkTheme
                            ? const Color(0xFFBEBEBE)
                            : const Color(0xff939393),
                  ),
                ),

              const SizedBox(height: 16),

              // Manage subscription button
              CustomEVButton(
                onPressed: () {
                  Get.to(() => const SubscriptionScreen());
                },
                text: 'Manage Subscription',
              ),
            ],
          );
        }),
      ),
    );
  }
}
