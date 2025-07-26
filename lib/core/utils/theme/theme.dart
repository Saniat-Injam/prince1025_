import 'package:flutter/material.dart';
import 'package:prince1025/core/utils/constants/colors.dart';
import 'package:prince1025/core/utils/theme/custom_themes/divider_theme.dart';
import 'package:prince1025/core/utils/theme/custom_themes/text_button_theme.dart';
import 'custom_themes/app_bar_theme.dart';
import 'custom_themes/elevated_button_theme.dart';
import 'custom_themes/text_form_field_theme.dart';
import 'custom_themes/text_theme.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'DM Sans',
    brightness: Brightness.light,
    primaryColor: AppColors.primaryDarkBlue,
    scaffoldBackgroundColor: Colors.white,
    textTheme: AppTextTheme.lightTextTheme,
    elevatedButtonTheme: AppElevatedButtonTheme.lightElevatedButtonTheme,
    textButtonTheme: AppTextButtonTheme.lightTextButtonTheme,
    appBarTheme: App_BarTheme.lightAppBarTheme,
    inputDecorationTheme: AppTextFormFieldTheme.lightInputDecorationTheme,
    dividerTheme: AppDividerTheme.lightDividerTheme,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'DM Sans',
    brightness: Brightness.dark,
    primaryColor: AppColors.darkPurple,
    scaffoldBackgroundColor: Colors.black,
    textTheme: AppTextTheme.darkTextTheme,
    elevatedButtonTheme: AppElevatedButtonTheme.darkElevatedButtonTheme,
    textButtonTheme: AppTextButtonTheme.darkTextButtonTheme,
    appBarTheme: App_BarTheme.darkAppBarTheme,
    inputDecorationTheme: AppTextFormFieldTheme.darkInputDecorationTheme,
    dividerTheme: AppDividerTheme.darkDividerTheme,
  );
}

// bottomsheet theme
// checkbox theme
// chip theme
// Outlined button theme


// radio theme
// switch theme
// slider theme
// card theme
// dialog theme
// tooltip theme
// popup menu theme
// progress indicator theme
// snack bar theme
// tab bar theme
// date picker theme
// time picker theme
// dialog theme
// navigation drawer theme
// navigation rail theme
// bottom navigation bar theme
// divider theme


