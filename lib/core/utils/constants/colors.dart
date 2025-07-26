import 'package:flutter/material.dart';

class AppColors {
  AppColors._();
  static const Color trasparent = Colors.transparent;
  static const Color primaryWhite = Color(0xffFFFFFF);
  static const Color secondaryWhite = Color(0xffF5F5F5);
  static const Color primaryDarkBlue = Color(0xff005E89);

  static const Color secondary = Color(0xFFA2DFF7);
  static const Color textdarkmode = Color(0xffF5F5F5);
  static const Color textlightmode = Color(0xff000000);

  static const RadialGradient primaryGradient = RadialGradient(
    center: Alignment.center, // 50% 50%
    //radius: 1.0952, // 109.52% as a multiplier
    radius: 2.952, // 295.2% as a multiplier
    colors: [
      Color(0xFF4E91FF), // 0%
      Color(0xFF1448CF), // 100%
    ],
    stops: [0.0, 1.0],
  );

  static const LinearGradient redGradient = LinearGradient(
    colors: [Color(0xFFE53935), Color(0xFFEF5350)], // Example red gradient
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Light Theme Colors
  static const Color darkBlue = Color(0xff210065);

  // Dark Theme Colors
  static const Color darkPurple = Color(0xff210065);

  // text colors
}
