import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:prince1025/core/common/styles/global_text_style.dart';
import 'package:prince1025/core/utils/constants/colors.dart';
import 'package:prince1025/core/utils/constants/svg_path.dart';
import '../controllers/course_details_controller.dart';
import '../models/lesson_model.dart';

/// Individual lesson item widget used in course content
class LessonItemWidget extends StatelessWidget {
  final Lesson lesson;
  final int lessonNumber;
  final CourseDetailsController controller;
  final bool isDarkTheme;
  final Color textColor;

  const LessonItemWidget({
    super.key,
    required this.lesson,
    required this.lessonNumber,
    required this.controller,
    required this.isDarkTheme,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isCurrentLesson = controller.currentLesson.value?.id == lesson.id;
      final isCompleted = lesson.isCompleted;
      final isLocked = lesson.isLocked;

      return GestureDetector(
        onTap: isLocked ? null : () => controller.selectLesson(lesson),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter:
                isDarkTheme
                    ? ImageFilter.blur(sigmaX: 200, sigmaY: 200)
                    : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:
                    isDarkTheme
                        ? Colors.white.withValues(alpha: 0.01)
                        : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border:
                    isCurrentLesson
                        ? Border.all(
                          color:
                              isDarkTheme
                                  ? const Color(0xFF8E2DE2)
                                  : AppColors.primaryDarkBlue,
                          width: 2,
                        )
                        : Border.all(
                          color:
                              isDarkTheme
                                  ? const Color(0xFF3A3A3A)
                                  : const Color(0xFFE5E5E5),
                          width: 1,
                        ),
              ),
              child: Row(
                children: [
                  // Lesson number or status circle
                  _buildStatusCircle(isCompleted, lessonNumber),

                  const SizedBox(width: 8),

                  // Lesson content
                  _buildLessonContent(),

                  // Right side - play button or lock icon
                  _buildRightIcon(isLocked, isCompleted, isCurrentLesson),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  /// Builds the status circle (lesson number or completion check)
  Widget _buildStatusCircle(bool isCompleted, int lessonNumber) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color:
            isCompleted
                ? Colors.transparent
                : isDarkTheme
                ? Colors.white.withValues(alpha: 0.25)
                : AppColors.primaryDarkBlue,
      ),
      child: Center(
        child:
            isCompleted
                ? SvgPicture.asset(
                  isDarkTheme ? SvgPath.selectDarkSvg : SvgPath.selectLightSvg,
                  width: 24,
                  height: 24,
                )
                : Text(
                  lessonNumber.toString(),
                  style: getDMTextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
      ),
    );
  }

  /// Builds the lesson title and duration content
  Widget _buildLessonContent() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            lesson.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              SvgPicture.asset(
                SvgPath.videoSvg,
                width: 16,
                height: 16,
                colorFilter: ColorFilter.mode(
                  isDarkTheme ? Colors.white : Colors.black,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                lesson.duration,
                style: TextStyle(fontSize: 14, color: textColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds the right icon (play button or lock icon)
  Widget _buildRightIcon(
    bool isLocked,
    bool isCompleted,
    bool isCurrentLesson,
  ) {
    if (isLocked) {
      return Container(
        padding: const EdgeInsets.all(8),
        child: SvgPicture.asset(
          SvgPath.lockSvg,
          colorFilter: ColorFilter.mode(
            isDarkTheme
                ? Color(0xFFBEBEBE).withValues(alpha: 0.8)
                : Color(0xFFA2DFF7).withValues(alpha: 0.5),
            BlendMode.srcIn,
          ),
          width: 18,
          height: 24,
        ),
      );
    } else if (!isCompleted && isCurrentLesson) {
      return SvgPicture.asset(
        isDarkTheme ? SvgPath.playDarkSvg : SvgPath.playLightSvg,
        width: 32,
        height: 32,
      );
    }
    return const SizedBox.shrink();
  }
}
