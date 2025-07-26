import 'package:flutter/material.dart';
import 'package:prince1025/core/common/styles/global_text_style.dart';
import 'package:prince1025/core/common/widgets/custom_container.dart';

class ContactSupportHeader extends StatelessWidget {
  final bool isDarkTheme;
  final Color textColor;

  const ContactSupportHeader({
    super.key,
    required this.isDarkTheme,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      isDarkTheme: isDarkTheme,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              Icons.support_agent_outlined,
              size: 80,
              color: isDarkTheme ? Colors.white : Colors.blue,
            ),
            const SizedBox(height: 16),
            Text(
              'How can we help you?',
              style: getDMTextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Our support team is here to help you with any issues or questions.',
              textAlign: TextAlign.center,
              style: getDMTextStyle(
                fontSize: 14,
                color:
                    isDarkTheme
                        ? Colors.white.withValues(alpha: 0.7)
                        : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
