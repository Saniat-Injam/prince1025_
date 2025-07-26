import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prince1025/core/common/styles/global_text_style.dart';
import '../controllers/course_details_controller.dart';

/// Widget that displays the user's progress through the course
class ProgressSection extends StatelessWidget {
  final CourseDetailsController controller;
  final bool isDarkTheme;
  final Color textColor;

  const ProgressSection({
    super.key,
    required this.controller,
    required this.isDarkTheme,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          const SizedBox(height: 16),

          // Progress header with percentage
          _buildProgressHeader(),

          const SizedBox(height: 12),

          // Progress bar
          _buildProgressBar(),
        ],
      ),
    );
  }

  /// Builds progress header showing "Your progress" and percentage
  Widget _buildProgressHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Lesson Progress',
          style: getDMTextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color:
                isDarkTheme ? const Color(0xFFF5F5F5) : const Color(0xFF2E2E2E),
          ),
        ),
        Text(
          controller.progressText,
          style: getDMTextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color:
                isDarkTheme ? const Color(0xFFC7B0F5) : const Color(0xFF005E89),
          ),
        ),
      ],
    );
  }

  /// Builds the visual progress bar
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
        widthFactor: controller.course.progress,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            gradient: progressGradient,
          ),
        ),
      ),
    );
  }
}
