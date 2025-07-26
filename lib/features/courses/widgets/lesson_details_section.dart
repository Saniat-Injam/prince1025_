import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:prince1025/core/common/styles/global_text_style.dart';
import 'package:prince1025/core/utils/constants/svg_path.dart';
import '../controllers/course_details_controller.dart';
import '../models/lesson_model.dart';

/// Widget that displays lesson details including title, favorite/share actions, and description
class LessonDetailsSection extends StatelessWidget {
  final Lesson lesson;
  final CourseDetailsController controller;
  final bool isDarkTheme;
  final Color textColor;

  const LessonDetailsSection({
    super.key,
    required this.lesson,
    required this.controller,
    required this.isDarkTheme,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        // Lesson title
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Text(
                lesson.title,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  fontFamily: 'Enwallowify',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),

            // Action buttons (favorite and share)
            Expanded(flex: 2, child: _buildActionButtons()),
          ],
        ),

        const SizedBox(height: 8),

        // Lesson description with expand/collapse functionality
        _buildExpandableDescription(),
      ],
    );
  }

  /// Builds favorite and share action buttons
  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Favorite button
        Obx(() {
          final isFavorited = controller.isLessonFavorited(lesson.id);
          return IconButton(
            icon: Icon(
              isFavorited ? Icons.favorite : Icons.favorite_border,
              size: 26,
              color:
                  isFavorited
                      ? (isDarkTheme ? Colors.red : Colors.red)
                      : (isDarkTheme ? Colors.white : Colors.black),
            ),
            onPressed: () => controller.toggleFavorite(lesson.id),
          );
        }),

        // Share button
        IconButton(
          icon: SvgPicture.asset(
            SvgPath.shareSvg,
            colorFilter: ColorFilter.mode(
              isDarkTheme ? Colors.white : Colors.black,
              BlendMode.srcIn,
            ),
          ),
          onPressed: () => controller.shareLesson(lesson),
        ),
      ],
    );
  }

  /// Builds expandable description with More/Less functionality
  Widget _buildExpandableDescription() {
    return Obx(() {
      final description = lesson.description ?? "No description available.";
      final isExpanded = controller.isDescriptionExpanded.value;
      final canExpand = description.length > 120;

      final displayedDescription =
          isExpanded || !canExpand
              ? description
              : '${description.substring(0, 100)}...';

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            displayedDescription,
            style: getDMTextStyle(
              fontSize: 14,
              color: textColor.withValues(alpha: 0.8),
            ),
          ),
          if (canExpand)
            GestureDetector(
              onTap: () => controller.toggleDescriptionExpansion(),
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  isExpanded ? "Less" : "More",
                  style: getDMTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDarkTheme ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
        ],
      );
    });
  }
}
