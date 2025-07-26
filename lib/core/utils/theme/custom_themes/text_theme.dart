import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:prince1025/core/utils/constants/colors.dart';

class AppTextTheme {
  AppTextTheme._();

  // Light Theme
  static TextTheme lightTextTheme = TextTheme(
    // light theme - display styles
    displayLarge: GoogleFonts.dmSans(
      fontSize: 57.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    displayMedium: GoogleFonts.dmSans(
      fontSize: 22.0,
      fontWeight: FontWeight.w500,
      color: AppColors.primaryWhite,
    ), // used
    displaySmall: GoogleFonts.dmSans(
      fontSize: 20.0,
      fontWeight: FontWeight.w500,
      color: AppColors.primaryWhite,
    ),

    // light theme - headline styles
    headlineLarge: GoogleFonts.dmSans(
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    headlineMedium: GoogleFonts.dmSans(
      fontSize: 28.0,
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    ),
    headlineSmall: GoogleFonts.dmSans(
      fontSize: 24.0,
      fontWeight: FontWeight.w500,
      color: Colors.black87,
    ),

    // light theme - title styles
    titleLarge: GoogleFonts.dmSans(
      fontSize: 22.0,
      fontWeight: FontWeight.w500,
      color: AppColors.primaryWhite,
    ),
    titleMedium: GoogleFonts.dmSans(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      color: Colors.black87,
    ),
    titleSmall: GoogleFonts.dmSans(
      fontSize: 14.0,
      fontWeight: FontWeight.w400,
      color: AppColors.primaryWhite,
    ),

    // light theme - body styles
    bodyLarge: GoogleFonts.dmSans(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      color: AppColors.secondaryWhite,
    ), // used
    bodyMedium: GoogleFonts.dmSans(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      color: AppColors.primaryWhite,
    ), // used
    bodySmall: GoogleFonts.dmSans(
      fontSize: 12.0,
      fontWeight: FontWeight.w500,
      color: AppColors.primaryWhite,
    ), // used
    // light theme - label styles
    labelLarge: GoogleFonts.dmSans(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      color: AppColors.primaryWhite,
    ), // used
    labelMedium: GoogleFonts.dmSans(
      fontSize: 12.0,
      fontWeight: FontWeight.w500,
      color: Colors.black54,
    ),
    labelSmall: GoogleFonts.dmSans(
      fontSize: 11.0,
      fontWeight: FontWeight.w500,
      color: Colors.black45,
    ),
  );

  // ---------------------------------------------------------------------------

  // Dark Theme
  static TextTheme darkTextTheme = TextTheme(
    // dark theme - display styles
    displayLarge: GoogleFonts.dmSans(
      fontSize: 57.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    displayMedium: GoogleFonts.dmSans(
      fontSize: 22.0,
      fontWeight: FontWeight.w500,
      color: AppColors.secondaryWhite,
    ),
    displaySmall: GoogleFonts.dmSans(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: AppColors.secondaryWhite,
    ),

    // dark theme - headline styles
    headlineLarge: GoogleFonts.dmSans(
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    headlineMedium: GoogleFonts.dmSans(
      fontSize: 28.0,
      fontWeight: FontWeight.w600,
      color: Colors.white70,
    ),
    headlineSmall: GoogleFonts.dmSans(
      fontSize: 24.0,
      fontWeight: FontWeight.w500,
      color: Colors.white70,
    ),

    // dark theme - title styles
    titleLarge: GoogleFonts.dmSans(
      fontSize: 22.0,
      fontWeight: FontWeight.w500,
      color: AppColors.secondaryWhite,
    ),
    titleMedium: GoogleFonts.dmSans(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      color: Colors.white70,
    ),
    titleSmall: GoogleFonts.dmSans(
      fontSize: 14.0,
      fontWeight: FontWeight.w400,
      color: AppColors.secondaryWhite,
    ),

    // dark theme - body styles
    bodyLarge: GoogleFonts.dmSans(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      color: AppColors.primaryWhite,
    ), // used
    bodyMedium: GoogleFonts.dmSans(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      color: AppColors.secondaryWhite,
    ), // used
    bodySmall: GoogleFonts.dmSans(
      fontSize: 12.0,
      fontWeight: FontWeight.w500,
      color: AppColors.secondaryWhite,
    ),

    // dark theme - label styles
    labelLarge: GoogleFonts.dmSans(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      color: AppColors.secondaryWhite,
    ), // used
    labelMedium: GoogleFonts.dmSans(
      fontSize: 12.0,
      fontWeight: FontWeight.w500,
      color: AppColors.primaryWhite,
    ),
    labelSmall: GoogleFonts.dmSans(
      fontSize: 11.0,
      fontWeight: FontWeight.w500,
      color: Colors.white54,
    ),
  );
}
