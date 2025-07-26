import 'package:flutter/material.dart';
import 'package:prince1025/core/common/styles/global_text_style.dart';
import 'package:prince1025/core/utils/constants/colors.dart';

class AppTextFormFieldTheme {
  AppTextFormFieldTheme._();

  static final InputDecorationTheme lightInputDecorationTheme =
      InputDecorationTheme(
        errorMaxLines: 3,
        prefixIconColor: AppColors.primaryWhite,
        suffixIconColor: AppColors.primaryWhite,
        labelStyle: const TextStyle(fontSize: 14, color: Colors.black),
        hintStyle: getDMTextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.secondaryWhite,
        ),
        errorStyle: const TextStyle(fontSize: 12, color: Colors.red),
        // ignore: deprecated_member_use
        floatingLabelStyle: TextStyle(
          color: Colors.black.withValues(alpha: 0.8),
        ),
        fillColor: Color(0x1A005E89),
        filled: true,
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        isDense: true,

        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: AppColors.primaryWhite),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: AppColors.primaryWhite),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: AppColors.primaryWhite),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: AppColors.primaryWhite),
        ),
      );

  // -----------------------------------------------------------------------------

  static final InputDecorationTheme darkInputDecorationTheme =
      InputDecorationTheme(
        errorMaxLines: 3,
        prefixIconColor: AppColors.secondaryWhite,
        suffixIconColor: AppColors.secondaryWhite,
        labelStyle: TextStyle(fontSize: 14, color: Colors.white),
        hintStyle: getDMTextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.secondaryWhite,
        ),
        errorStyle: TextStyle(fontSize: 12, color: Colors.redAccent),
        floatingLabelStyle: TextStyle(color: Colors.white70),
        fillColor: Colors.transparent,
        filled: true,
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        isDense: true,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(
            color: AppColors.primaryWhite.withValues(alpha: 0.5),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(
            color: AppColors.primaryWhite.withValues(alpha: 0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(
            color: AppColors.primaryWhite.withValues(alpha: 0.5),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(
            color: AppColors.primaryWhite.withValues(alpha: 0.5),
          ),
        ),
      );
}
