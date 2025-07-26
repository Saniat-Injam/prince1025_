import 'package:flutter/material.dart';
import 'package:prince1025/core/common/styles/global_text_style.dart';
import 'package:prince1025/core/utils/constants/colors.dart';

class PlanDetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isDarkTheme;

  const PlanDetailRow({
    super.key,
    required this.label,
    required this.value,
    required this.isDarkTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: getDMTextStyle(
              color:
                  isDarkTheme
                      ? AppColors.textdarkmode
                      : AppColors.textlightmode,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: getDMTextStyle(
              color:
                  isDarkTheme
                      ? AppColors.textdarkmode
                      : AppColors.textlightmode,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
