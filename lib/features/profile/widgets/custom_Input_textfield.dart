import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:prince1025/core/common/styles/global_text_style.dart';

class CustomInputTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final String? label;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  const CustomInputTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.label,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: BackdropFilter(
        filter:
            isDarkMode
                ? ImageFilter.blur(sigmaX: 100, sigmaY: 100)
                : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
        child: Container(
          decoration: BoxDecoration(
            color:
                isDarkMode
                    ? Colors.black.withValues(alpha: .05)
                    : Colors.transparent,
            border:
                isDarkMode
                    ? Border.all(
                      color: Colors.white.withValues(alpha: .5),
                      width: 0.5,
                    )
                    : null,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            validator: validator,
            style: getDMTextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            decoration: InputDecoration(
              labelText: label,
              labelStyle: getDMTextStyle(
                color:
                    isDarkMode
                        ? Colors.white.withValues(alpha: .5)
                        : Color(0xff939393),
              ),
              hintText: hint,
              hintStyle: getDMTextStyle(
                color:
                    isDarkMode
                        ? Colors.white.withValues(alpha: .5)
                        : Color(0xff939393),
              ),
              prefixIcon:
                  prefixIcon != null
                      ? IconTheme(
                        data: IconThemeData(
                          color: isDarkMode ? Colors.white : null,
                        ),
                        child: prefixIcon!,
                      )
                      : null,
              suffixIcon:
                  suffixIcon != null
                      ? IconTheme(
                        data: IconThemeData(
                          color: isDarkMode ? Colors.white : null,
                        ),
                        child: suffixIcon!,
                      )
                      : null,
              border: _buildOutlineInputBorder(isDarkMode),
              enabledBorder: _buildOutlineInputBorder(isDarkMode),
              focusedBorder: _buildOutlineInputBorder(isDarkMode),
              errorBorder: _buildOutlineInputBorder(isDarkMode),
              focusedErrorBorder: _buildOutlineInputBorder(isDarkMode),
            ),
          ),
        ),
      ),
    );
  }

  OutlineInputBorder _buildOutlineInputBorder(bool isDarkMode) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide:
          isDarkMode
              ? BorderSide(
                width: 0.5,
                color: Colors.white.withValues(alpha: .5),
              )
              : BorderSide(width: 0.5, color: const Color(0xffA2DFF7)),
    );
  }
}
