import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:prince1025/core/utils/constants/colors.dart';
import 'package:prince1025/core/utils/constants/svg_path.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final bool centerTitle;
  final List<Widget>? actions;
  final Widget? leadingIcon;
  final Widget? titleWidget;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final PreferredSizeWidget? bottom;
  final VoidCallback? onBackPressed;
  final bool automaticallyImplyLeading;
  final bool isFullView;

  const CustomAppBar({
    super.key,
    this.title = '',
    this.showBackButton = true,
    this.centerTitle = true,
    this.actions,
    this.leadingIcon,
    this.titleWidget,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.bottom,
    this.onBackPressed,
    this.automaticallyImplyLeading = true,
    this.isFullView = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(isFullView ? 0 : 24),
      child: BackdropFilter(
        filter:
            isDarkMode
                ? ImageFilter.blur(sigmaX: 100, sigmaY: 100)
                : ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AppBar(
          title:
              titleWidget ??
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Enwallowify',
                  fontSize: 22,
                  color:
                      foregroundColor ??
                      (isDarkMode ? Colors.white : AppColors.primaryDarkBlue),
                ),
              ),
          centerTitle: centerTitle,
          backgroundColor:
              backgroundColor ??
              (isDarkMode ? Colors.black.withValues(alpha: .05) : Colors.white),
          elevation: elevation,
          automaticallyImplyLeading:
              showBackButton ? automaticallyImplyLeading : false,
          leading: _buildLeading(isDarkMode, showBackButton),
          actions: actions,
          bottom: bottom,
          shape:
              isDarkMode
                  ? RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(isFullView ? 0 : 24),
                    ),
                    side: BorderSide(
                      color: Colors.white.withValues(alpha: .35),
                      width: isFullView ? 0 : 0.5,
                    ),
                  )
                  : RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(isFullView ? 0 : 24),
                    ),
                    side: BorderSide(
                      color: Colors.black.withValues(alpha: .2),
                      width: 0.5,
                    ),
                  ),
        ),
      ),
    );
  }

  Widget? _buildLeading(bool isDarkMode, bool showBackButton) {
    if (!automaticallyImplyLeading) return null;

    if (leadingIcon != null) return leadingIcon;

    if (showBackButton) {
      return IconButton(
        icon: SvgPicture.asset(
          SvgPath.backArrowSvg,
          colorFilter: ColorFilter.mode(
            isDarkMode ? Colors.white : Colors.black,
            BlendMode.srcIn,
          ),
          height: 24,
          width: 24,
        ),
        onPressed: onBackPressed ?? () => Get.back(),
      );
    }

    return null;
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));
}
