import 'dart:ui';

import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final bool isDarkTheme;
  final Widget child;
  final double borderRadius;
  const CustomContainer({
    super.key,
    required this.isDarkTheme,
    required this.child,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow:
            isDarkTheme
                ? null
                : [
                  BoxShadow(
                    color: Color(0xFF323131).withValues(alpha: 0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter:
              isDarkTheme
                  ? ImageFilter.blur(sigmaX: 100, sigmaY: 100)
                  : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              color:
                  isDarkTheme
                      ? Colors.white.withValues(alpha: 0.01)
                      : Colors.white,
              border:
                  isDarkTheme
                      ? Border.all(
                        color: Colors.white.withValues(alpha: 0.5),
                        width: 0.5,
                      )
                      : null,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
