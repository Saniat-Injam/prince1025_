import 'package:flutter/material.dart';
import 'package:prince1025/core/common/styles/global_text_style.dart';
import 'package:prince1025/core/utils/constants/colors.dart';

class CustomEVButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color? customColor;
  final Color? textColor;

  const CustomEVButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.customColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient:
            customColor == null && isDarkMode
                ? const RadialGradient(
                  center: Alignment.center,
                  radius: 2,
                  colors: [Color(0xFF4E91FF), Color(0xFF1448CF)],
                )
                : null,
        color: customColor ?? (isDarkMode ? null : const Color(0xffA2DFF7)),
        border:
            isDarkMode
                ? Border.all(
                  color: Colors.white.withValues(alpha: .35),
                  width: 1,
                )
                : null,
      ),
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          overlayColor: WidgetStateProperty.all(
            isDarkMode
                ? Colors.white.withValues(alpha: .1)
                : Colors.black.withValues(alpha: .05),
          ),
        ),
        child: Text(
          text,
          style: getDMTextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,

            color:
                textColor ??
                (isDarkMode ? Colors.white : AppColors.primaryDarkBlue),
          ),
        ),
      ),
    );
  }
}
