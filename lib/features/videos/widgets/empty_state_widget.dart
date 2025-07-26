import 'package:flutter/material.dart';
import 'package:prince1025/core/common/styles/global_text_style.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isDarkTheme;
  final VoidCallback? onAction;
  final String? actionText;

  const EmptyStateWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isDarkTheme,
    this.onAction,
    this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color:
                    isDarkTheme
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.grey.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border:
                    isDarkTheme
                        ? Border.all(
                          color: Colors.white.withValues(alpha: 0.1),
                          width: 1,
                        )
                        : null,
              ),
              child: Icon(
                icon,
                size: 48,
                color:
                    isDarkTheme
                        ? Colors.white.withValues(alpha: 0.4)
                        : Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: getDMTextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color:
                    isDarkTheme
                        ? Colors.white.withValues(alpha: 0.8)
                        : Colors.grey.shade700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: getDMTextStyle(
                fontSize: 14,
                color:
                    isDarkTheme
                        ? Colors.white.withValues(alpha: 0.6)
                        : Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            if (onAction != null && actionText != null) ...[
              const SizedBox(height: 24),
              TextButton(
                onPressed: onAction,
                style: TextButton.styleFrom(
                  foregroundColor:
                      isDarkTheme
                          ? const Color(0xFF4E91FF)
                          : const Color(0xFF005E89),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: Text(
                  actionText!,
                  style: getDMTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
