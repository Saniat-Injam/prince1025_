import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:prince1025/core/common/styles/global_text_style.dart';
import 'package:prince1025/core/utils/constants/svg_path.dart';
import 'package:prince1025/features/profile/widgets/custom_ev_button.dart';
import '../models/course_model.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final bool isDarkTheme;
  final Color textColor;
  final VoidCallback? onTap;
  final VoidCallback? onResumeTap;
  final bool showProgress;
  final bool showResumeButton;

  const CourseCard({
    super.key,
    required this.course,
    required this.isDarkTheme,
    required this.textColor,
    this.onTap,
    this.onResumeTap,
    this.showProgress = false,
    this.showResumeButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
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
                    ? ImageFilter.blur(sigmaX: 100, sigmaY: 100)
                    : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
            child: Container(
              decoration: BoxDecoration(
                color:
                    isDarkTheme
                        ? Colors.white.withValues(alpha: 0.01)
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Course Image with overlay content
                  _buildCourseImage(),

                  // Course Content below image
                  if (showProgress && course.progress > 0) ...[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Lesson Info and Progress
                          _buildLessonInfo(),
                          const SizedBox(height: 12),

                          // Progress Bar
                          _buildProgressBar(),

                          // Resume Button
                          if (showResumeButton) ...[
                            const SizedBox(height: 16),
                            _buildResumeButton(),
                          ],
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCourseImage() {
    return Stack(
      children: [
        // Course Image
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          child: Image.network(
            course.imageUrl,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF4E91FF).withValues(alpha: 0.8),
                      const Color(0xFF1448CF).withValues(alpha: 0.8),
                    ],
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.play_circle_filled,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
        ),

        // Gradient Overlay
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.6),
                ],
              ),
            ),
          ),
        ),

        // Lock Icon (if course is locked) - centered
        if (course.isLocked)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                color: Colors.black.withValues(alpha: 0.6),
              ),
              child: Center(
                child: SvgPicture.asset(SvgPath.lockSvg, width: 40, height: 40),
              ),
            ),
          ),

        // Free Preview Badge (if has preview)
        if (course.hasPreview && !course.isLocked)
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color:
                    isDarkTheme
                        ? const Color(0xFF210065)
                        : const Color(0xFF005E89),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Free Preview',
                style: getDMTextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),

        // Course Title and Subtitle on image
        Positioned(
          bottom: 16,
          left: 12,
          right: 12,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                course.title,
                style: TextStyle(
                  fontFamily: 'Enwallowify',
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: const Offset(0, 1),
                      blurRadius: 3,
                      color: Colors.black.withValues(alpha: 0.5),
                    ),
                  ],
                ),
              ),
              Text(
                course.subtitle,
                style: getDMTextStyle(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLessonInfo() {
    String lessonText;
    if (course.currentLesson > 0) {
      lessonText = 'Lesson ${course.currentLesson} of ${course.totalLessons}';
    } else {
      lessonText = '${course.totalLessons} Lessons';
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          lessonText,
          style: getDMTextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color:
                isDarkTheme ? const Color(0xFFF5F5F5) : const Color(0xFF2E2E2E),
          ),
        ),
        if (course.progress > 0)
          Text(
            '${course.progressPercentage}%',
            style: getDMTextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color:
                  isDarkTheme
                      ? const Color(0xFFC7B0F5)
                      : const Color(0xFF005E89),
            ),
          ),
      ],
    );
  }

  Widget _buildProgressBar() {
    final progressGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        isDarkTheme ? const Color(0xFF8E2DE2) : const Color(0xFF4A00E0),
        isDarkTheme ? const Color(0xFF005E89) : const Color(0xFF005E89),
      ],
    );

    return Container(
      height: 8,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: isDarkTheme ? const Color(0xFFBEBEBE) : const Color(0xFFBEBEBE),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: course.progress,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            gradient: progressGradient,
          ),
        ),
      ),
    );
  }

  Widget _buildResumeButton() {
    return CustomEVButton(
      text: 'Resume Learning',
      onPressed: onResumeTap ?? () {},
    );
  }
}
