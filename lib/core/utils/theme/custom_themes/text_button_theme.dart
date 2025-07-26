import 'package:flutter/material.dart';
import 'package:prince1025/core/common/styles/global_text_style.dart';
import 'package:prince1025/core/utils/constants/colors.dart';

class AppTextButtonTheme {
  AppTextButtonTheme._(); // private constructor

  // Light Theme
  static final TextButtonThemeData lightTextButtonTheme = TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.all(AppColors.primaryWhite),
      textStyle: WidgetStateProperty.all(
        getDMTextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      overlayColor: WidgetStateProperty.all(
        AppColors.primaryWhite.withValues(alpha: 0.1),
      ),
    ),
  );

  // ---------------------------------------------------------------------------

  // Dark Theme
  static final TextButtonThemeData darkTextButtonTheme = TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.all(AppColors.secondaryWhite),
      textStyle: WidgetStateProperty.all(
        const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      overlayColor: WidgetStateProperty.all(
        AppColors.secondaryWhite.withValues(alpha: 0.1),
      ),
    ),
  );
}
