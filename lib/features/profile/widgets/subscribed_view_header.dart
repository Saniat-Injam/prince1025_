import 'package:flutter/material.dart';
import 'package:prince1025/core/utils/constants/colors.dart';

class SubscribedViewHeader extends StatelessWidget {
  final bool isDarkTheme;

  const SubscribedViewHeader({super.key, required this.isDarkTheme});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Current Plan',
          style: TextStyle(
            fontFamily: 'Enwallowify',
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color:
                isDarkTheme ? AppColors.textdarkmode : AppColors.textlightmode,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
