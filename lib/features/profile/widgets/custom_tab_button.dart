import 'package:flutter/material.dart';
import 'package:prince1025/core/common/styles/global_text_style.dart';
import 'package:prince1025/core/utils/constants/colors.dart';

class CustomTabButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDarkTheme;

  const CustomTabButton({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
    required this.isDarkTheme,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? (isDarkTheme ? Colors.blue : AppColors.primaryDarkBlue)
                  : (isDarkTheme
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.grey.withValues(alpha: 0.1)),
          gradient:
              isSelected && isDarkTheme
                  ? const RadialGradient(
                    center: Alignment.center,
                    radius: 2.5,
                    colors: [Color(0xFF4E91FF), Color(0xFF1448CF)],
                  )
                  : isSelected && !isDarkTheme
                  ? const RadialGradient(
                    center: Alignment.center,
                    radius: 2.5,
                    colors: [
                      AppColors.primaryDarkBlue,
                      AppColors.primaryDarkBlue,
                    ],
                  )
                  : null,
          borderRadius: BorderRadius.circular(4),
          border:
              isDarkTheme && !isSelected
                  ? Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 0.5,
                  )
                  : isDarkTheme && isSelected
                  ? Border.all(
                    color: Colors.white.withValues(alpha: 0.35),
                    width: 0.5,
                  )
                  : null,
        ),
        child: Text(
          title,
          style: getDMTextStyle(
            color:
                isSelected
                    ? (isDarkTheme ? AppColors.textdarkmode : Colors.white)
                    : (isDarkTheme ? Colors.white : Colors.black),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
