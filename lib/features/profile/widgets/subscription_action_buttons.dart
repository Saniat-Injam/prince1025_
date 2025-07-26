import 'package:flutter/material.dart';
import 'package:prince1025/core/common/styles/global_text_style.dart';
import 'package:prince1025/core/utils/constants/colors.dart';

class SubscriptionActionButtons extends StatelessWidget {
  final VoidCallback onRenewSubscription;
  final VoidCallback onCancelSubscription;
  final bool isRenewButtonEnabled;
  final bool isDarkMode;

  const SubscriptionActionButtons({
    super.key,
    required this.onRenewSubscription,
    required this.onCancelSubscription,
    required this.isRenewButtonEnabled,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // renew subscription button
        GestureDetector(
          onTap: isRenewButtonEnabled ? onRenewSubscription : null,
          child: Container(
            padding: const EdgeInsets.all(12),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: !isRenewButtonEnabled ? Color(0xFFCCCCCC) : null,
              border:
                  isRenewButtonEnabled && !isDarkMode
                      ? Border.all(
                        color: Colors.white.withValues(alpha: .35),
                        width: 1,
                      )
                      : isRenewButtonEnabled && isDarkMode
                      ? Border.all(
                        color: Colors.white.withValues(alpha: .35),
                        width: 1,
                      )
                      : !isRenewButtonEnabled && isDarkMode
                      ? Border.all(
                        color: Colors.white.withValues(alpha: .35),
                        width: 1,
                      )
                      : null,
              gradient:
                  isRenewButtonEnabled && !isDarkMode
                      ? const RadialGradient(
                        center: Alignment.center,
                        radius: 2,
                        colors: [Color(0xFF4E91FF), Color(0xFF1448CF)],
                      )
                      : isRenewButtonEnabled && isDarkMode
                      ? const RadialGradient(
                        center: Alignment.center,
                        radius: 2,
                        colors: [Color(0xFF4E91FF), Color(0xFF1448CF)],
                      )
                      : !isRenewButtonEnabled && isDarkMode
                      ? const RadialGradient(
                        center: Alignment.center,
                        radius: 2,
                        colors: [Color(0xFF210065), Color(0xFF210065)],
                      )
                      : null,
            ),
            child: Center(
              child: Text(
                'Renew Subscription',
                style: getDMTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color:
                      isRenewButtonEnabled && !isDarkMode
                          ? AppColors.textdarkmode
                          : !isRenewButtonEnabled && !isDarkMode
                          ? Color(0xFF252525).withValues(alpha: .5)
                          : isRenewButtonEnabled && isDarkMode
                          ? AppColors.textdarkmode
                          : !isRenewButtonEnabled && isDarkMode
                          ? AppColors.textdarkmode
                          : Colors.white.withValues(alpha: .5),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // cancel subscription button
        GestureDetector(
          onTap: onCancelSubscription,
          child: Container(
            padding: const EdgeInsets.all(12),
            width: double.infinity,
            decoration: BoxDecoration(
              border:
                  isDarkMode
                      ? Border.all(
                        color: Colors.white.withValues(alpha: .35),
                        width: 1,
                      )
                      : null,
              borderRadius: BorderRadius.circular(8),
              color: isDarkMode ? Colors.transparent : Colors.red,
            ),
            child: Center(
              child: Text(
                'Cancel Subscription',
                style: getDMTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
