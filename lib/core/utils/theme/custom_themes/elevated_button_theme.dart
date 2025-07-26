import 'package:flutter/material.dart';
import 'package:prince1025/core/utils/constants/colors.dart';
import 'package:prince1025/core/utils/theme/custom_themes/text_theme.dart';

class AppElevatedButtonTheme {
  AppElevatedButtonTheme._();

  // Light Theme
  static final ElevatedButtonThemeData lightElevatedButtonTheme =
      ElevatedButtonThemeData(
        style: ButtonStyle(
          elevation: WidgetStateProperty.all(0),
          foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.disabled)) {
              return Colors.grey;
            }
            return AppColors.primaryWhite;
          }),
          backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.disabled)) {
              return Colors.grey.shade300;
            }
            return AppColors.primaryDarkBlue;
          }),
          //side: WidgetStateProperty.all(const BorderSide()),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(vertical: 12),
          ),
          textStyle: WidgetStateProperty.all(
            // const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            AppTextTheme.lightTextTheme.bodyLarge,
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      );

  // ---------------------------------------------------------------------------

  // Dark Theme
  static final ElevatedButtonThemeData darkElevatedButtonTheme =
      ElevatedButtonThemeData(
        style: ButtonStyle(
          elevation: WidgetStateProperty.all(0),
          foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.disabled)) {
              return Colors.grey.shade600;
            }
            return Colors.white;
          }),
          backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.disabled)) {
              return Colors.grey.shade800;
            }
            return AppColors.primaryDarkBlue;
          }),
          side: WidgetStateProperty.all(const BorderSide()),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(vertical: 12),
          ),
          textStyle: WidgetStateProperty.all(
            //const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            AppTextTheme.darkTextTheme.titleMedium,
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      );
}
