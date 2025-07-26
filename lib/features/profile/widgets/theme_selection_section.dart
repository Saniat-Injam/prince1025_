import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:prince1025/core/common/styles/global_text_style.dart';
import 'package:prince1025/core/utils/constants/colors.dart';
import 'package:prince1025/core/utils/constants/svg_path.dart';
import 'package:prince1025/features/profile/controllers/theme_controller.dart';

class ThemeSelectionSection extends StatelessWidget {
  final Color textColor;
  final Color? iconColor;
  final bool isDarkTheme;

  const ThemeSelectionSection({
    super.key,
    required this.textColor,
    required this.iconColor,
    required this.isDarkTheme,
  });

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController());

    return Obx(
      () => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Theme selection header
          InkWell(
            onTap: themeController.toggleThemeExpansion,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 1),
              child: Row(
                children: [
                  Icon(
                    themeController.currentThemeIcon,
                    size: 24,
                    color: iconColor,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Theme',
                          style: getDMTextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: textColor,
                          ),
                        ),
                        Text(
                          themeController.currentThemeDisplayName,
                          style: getDMTextStyle(
                            fontSize: 14,
                            color:
                                isDarkTheme
                                    ? Colors.white70
                                    : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SvgPicture.asset(
                    themeController.isThemeExpanded.value
                        ? SvgPath.arrowDownSvg
                        : SvgPath.rightArrowSvg,
                    colorFilter:
                        iconColor != null
                            ? ColorFilter.mode(iconColor!, BlendMode.srcIn)
                            : null,
                    width: 20,
                    height: 20,
                  ),
                ],
              ),
            ),
          ),

          // Expandable theme options
          if (themeController.isThemeExpanded.value)
            Container(
              margin: const EdgeInsets.only(left: 32, top: 8),
              child: Column(
                children:
                    themeController.themeOptions.map((theme) {
                      final isSelected =
                          themeController.currentTheme.value == theme;
                      return InkWell(
                        onTap: () => themeController.changeTheme(theme),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 12,
                          ),
                          margin: const EdgeInsets.only(bottom: 4),
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? (isDarkTheme
                                        ? Colors.white.withValues(alpha: 0.1)
                                        : Colors.grey.shade100)
                                    : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border:
                                isDarkTheme && isSelected
                                    ? Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.3,
                                      ),
                                      width: 0.5,
                                    )
                                    : null,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                themeController.getThemeIcon(theme),
                                size: 20,
                                color:
                                    isSelected
                                        ? (isDarkTheme
                                            ? Colors.white
                                            : AppColors.primaryDarkBlue)
                                        : (isDarkTheme
                                            ? Colors.white
                                            : Colors.grey.shade700),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _getThemeDisplayName(theme),
                                  style: getDMTextStyle(
                                    fontSize: 14,
                                    fontWeight:
                                        isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                    color:
                                        isSelected
                                            ? (isDarkTheme
                                                ? Colors.white
                                                : AppColors.primaryDarkBlue)
                                            : (isDarkTheme
                                                ? Colors.white70
                                                : Colors.grey.shade700),
                                  ),
                                ),
                              ),
                              if (isSelected)
                                Icon(
                                  Icons.check,
                                  size: 18,
                                  color:
                                      isDarkTheme
                                          ? Colors.white
                                          : AppColors.primaryDarkBlue,
                                ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  String _getThemeDisplayName(String theme) {
    switch (theme) {
      case 'light':
        return 'Light Mode';
      case 'dark':
        return 'Dark Mode';
      case 'system':
      default:
        return 'System Default';
    }
  }
}
