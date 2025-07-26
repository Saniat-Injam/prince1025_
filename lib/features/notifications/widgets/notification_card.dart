import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:prince1025/core/common/styles/global_text_style.dart';
import 'package:prince1025/core/utils/constants/colors.dart';
import 'package:prince1025/features/notifications/models/notification_model.dart';

class NotificationCard extends StatelessWidget {
  final dynamic notification;
  final dynamic controller;
  final bool isDarkTheme;
  final Color textColor;
  final bool isUnread;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.controller,
    required this.isDarkTheme,
    required this.textColor,
    required this.isUnread,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow:
            isDarkTheme
                ? null
                : [
                  BoxShadow(
                    color: const Color(0xFF323131).withValues(alpha: 0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter:
              isDarkTheme
                  ? ImageFilter.blur(sigmaX: 300, sigmaY: 300)
                  : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color:
                  isDarkTheme
                      ? Colors.black.withValues(alpha: 0.1)
                      : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border:
                  isDarkTheme
                      ? Border.all(
                        color: Colors.white.withValues(alpha: 0.5),
                        width: 0.5,
                      )
                      : null,
            ),
            child: Row(
              children: [
                // Notification icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color:
                        isDarkTheme
                            ? const Color(0x26BEBEBE)
                            : AppColors.primaryDarkBlue.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      NotificationTypeHelper.getIcon(notification.type),
                      width: 24,
                      height: 24,
                      colorFilter: ColorFilter.mode(
                        !isDarkTheme
                            ? AppColors.primaryDarkBlue
                            : const Color(0xFFBEBEBE),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Notification content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            notification.title,
                            style: getDMTextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                          if (isUnread)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors:
                                      isDarkTheme
                                          ? [
                                            Color(0xFF8E2DE2),
                                            Color(0xFF4A00E0),
                                          ]
                                          : [
                                            Color(0xFF4E91FF),
                                            Color(0xFF1448CF),
                                          ],
                                ),
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      Text(
                        notification.message,
                        style: getDMTextStyle(
                          fontSize: 14,
                          color:
                              isDarkTheme
                                  ? const Color(0xFFBEBEBE)
                                  : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                // Purple dot for unread
              ],
            ),
          ),
        ),
      ),
    );
  }
}
