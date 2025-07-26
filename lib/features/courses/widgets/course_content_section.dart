import 'package:flutter/material.dart';
import '../controllers/course_details_controller.dart';
import '../models/lesson_model.dart';
import 'module_header.dart';
import 'lesson_item_widget.dart';

/// Widget that displays all course modules and their lessons
class CourseContentSection extends StatelessWidget {
  final CourseDetailsController controller;
  final bool isDarkTheme;
  final Color textColor;

  const CourseContentSection({
    super.key,
    required this.controller,
    required this.isDarkTheme,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          controller.modules
              .map((module) => _buildModuleSection(module))
              .toList(),
    );
  }

  /// Builds a single module section with header and lessons
  Widget _buildModuleSection(CourseModule module) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),

        // Module header
        ModuleHeader(
          module: module,
          isDarkTheme: isDarkTheme,
          textColor: textColor,
        ),

        const SizedBox(height: 16),

        // Lessons in module
        ...module.lessons.asMap().entries.map((entry) {
          final index = entry.key;
          final lesson = entry.value;
          return LessonItemWidget(
            lesson: lesson,
            lessonNumber: index + 1,
            controller: controller,
            isDarkTheme: isDarkTheme,
            textColor: textColor,
          );
        }),

        const SizedBox(height: 24),
      ],
    );
  }
}
