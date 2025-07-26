import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:prince1025/core/common/styles/global_text_style.dart';
import 'package:prince1025/core/utils/constants/colors.dart';
import 'package:prince1025/core/utils/constants/svg_path.dart';

class SubscriptionPlanCard extends StatelessWidget {
  final bool isSelected;
  final String title;
  final String price;
  final String period;
  final List<String> features;
  final VoidCallback onTap;
  final bool isBestValue;
  final String? savingsText;

  const SubscriptionPlanCard({
    super.key,
    required this.isSelected,
    required this.title,
    required this.price,
    required this.period,
    required this.features,
    required this.onTap,
    this.isBestValue = false,
    this.savingsText,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDarkTheme
            ? (isSelected
                ? const Color(0xFF071123)
                : const Color(0xFFFFFFFF).withValues(alpha: .01))
            : (isSelected ? const Color(0xFFEFF6FF) : const Color(0xFFFFFFFF));
    final textColor = isDarkTheme ? Colors.white : const Color(0xFF323131);
    final subtleTextColor = isDarkTheme ? Colors.white70 : Colors.black54;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow:
                  isDarkTheme
                      ? null
                      : [
                        BoxShadow(
                          color: Color(0xFF323131).withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(-2, 6),
                          spreadRadius: 2,
                        ),
                      ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          isDarkTheme
                              ? (isSelected
                                  ? const Color(0xFF133663)
                                  : const Color(
                                    0xFFFFFFFF,
                                  ).withValues(alpha: .5))
                              : (isSelected
                                  ? const Color(0xFFB0CDDA)
                                  : const Color(
                                    0xFFFFFFFF,
                                  ).withValues(alpha: .5)),
                      width: isDarkTheme ? 1.0 : 0.8,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            title,
                            style: getDMTextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          _buildSelectionIndicator(isDarkTheme),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildPriceSection(
                        textColor,
                        subtleTextColor,
                        isDarkTheme,
                      ),
                      if (savingsText != null) _buildSavingsText(isDarkTheme),
                      const SizedBox(height: 8),
                      ...features.map(
                        (feature) =>
                            _buildFeatureRow(feature, textColor, isDarkTheme),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (isBestValue) _buildBestValueBadge(isDarkTheme),
        ],
      ),
    );
  }

  // Selection Indicator
  Widget _buildSelectionIndicator(bool isDarkTheme) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color:
              isSelected
                  ? AppColors.textdarkmode
                  : (isDarkTheme
                      ? Colors.white.withValues(alpha: .54)
                      : Colors.black26),
          width: 2,
        ),
      ),
      child:
          isSelected
              ? SvgPicture.asset(
                isDarkTheme ? SvgPath.selectDarkSvg : SvgPath.selectLightSvg,
                width: 24,
                height: 24,
              )
              : null,
    );
  }

  // Price Section
  Widget _buildPriceSection(
    Color textColor,
    Color subtleTextColor,
    bool isDarkTheme,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          price,
          style: TextStyle(
            fontFamily: 'Enwallowify',
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color:
                isDarkTheme ? AppColors.secondary : AppColors.primaryDarkBlue,
          ),
        ),
        Text(
          period,
          style: TextStyle(
            fontFamily: 'Enwallowify',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color:
                isDarkTheme ? AppColors.textdarkmode : AppColors.textlightmode,
          ),
        ),
      ],
    );
  }

  // Savings Text
  Widget _buildSavingsText(bool isDarkTheme) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        savingsText!,
        style: getDMTextStyle(
          fontSize: 14,
          color: isDarkTheme ? AppColors.textdarkmode : Color(0xFF008501),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // Feature Row
  Widget _buildFeatureRow(String feature, Color textColor, bool isDarkTheme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SvgPicture.asset(
            isDarkTheme ? SvgPath.checkDarkSvg : SvgPath.checkLightSvg,
            width: 20,
            height: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              feature,
              style: getDMTextStyle(fontSize: 14, color: textColor),
            ),
          ),
        ],
      ),
    );
  }

  // Best Value Badge
  Widget _buildBestValueBadge(bool isDarkTheme) {
    return Positioned(
      top: 0,
      right: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: isDarkTheme ? Colors.white : AppColors.primaryDarkBlue,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          'Best Value',
          style: getDMTextStyle(
            color: isDarkTheme ? Colors.black : Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
