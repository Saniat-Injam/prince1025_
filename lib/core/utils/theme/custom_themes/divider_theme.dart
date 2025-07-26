import 'package:flutter/material.dart';
import 'package:prince1025/core/utils/constants/colors.dart';

class AppDividerTheme {
  AppDividerTheme._(); // Private constructor

  static const double _dividerThickness = 1.0;
  static const double _indent = 4.0;
  static const double _endIndent = 4.0;

  static DividerThemeData lightDividerTheme = const DividerThemeData(
    // color: AppColors.primaryWhite,
    color: AppColors.primaryWhite,
    thickness: _dividerThickness,
    space: 32,
    indent: _indent,
    endIndent: _endIndent,
  );

  static DividerThemeData darkDividerTheme = const DividerThemeData(
    color: AppColors.secondaryWhite,
    thickness: _dividerThickness,
    space: 32,
    indent: _indent,
    endIndent: _endIndent,
  );
}
