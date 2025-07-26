import 'package:flutter/material.dart';
import 'package:prince1025/core/common/styles/global_text_style.dart';

class SubscriptionHeaderSection extends StatelessWidget {
  final Color textColor;

  const SubscriptionHeaderSection({super.key, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose Your Plan',
          style: TextStyle(
            fontFamily: 'Enwallowify',
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Unlock unlimited access to exclusive videos, courses, and quotes.',
          style: getDMTextStyle(fontSize: 14, color: textColor),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
