import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prince1025/core/common/styles/global_text_style.dart';
import 'package:prince1025/core/common/widgets/custom_container.dart';
import 'package:prince1025/features/bottom_nav/controllers/bottom_nav_controller.dart';
import 'package:prince1025/features/profile/models/course_progress_model.dart';

class MyContentsSection extends StatelessWidget {
  final Color textColor;
  final bool isDarkTheme;

  const MyContentsSection({
    required this.textColor,
    required this.isDarkTheme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final BottomNavController bottomNavController = Get.put(
      BottomNavController(),
    );
    final List<CourseProgress> courses = [
      CourseProgress(
        title: 'Mindfulness Meditation',
        progress: 0.75, // 75%
        lastAccessed: 'Yesterday',
      ),
      CourseProgress(
        title: 'Stress Management',
        progress: 0.32, // 32%
        lastAccessed: '3 days ago',
      ),
    ];

    return CustomContainer(
      isDarkTheme: isDarkTheme,
      borderRadius: 12,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My Contents',
                  style: TextStyle(
                    fontFamily: 'Enwallowify',
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Courses in Progress Subsection
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Courses in Progress',
                  style: getDMTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isDarkTheme ? Color(0xFFBEBEBE) : Color(0xFF2E2E2E),
                  ),
                ),
                GestureDetector(
                  onTap: () => bottomNavController.changeIndex(2),
                  child: Text(
                    'See All',
                    style: getDMTextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color:
                          isDarkTheme ? Color(0xFFC7B0F5) : Color(0xFF005E89),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Course Progress Items
            ...courses.map((course) => _buildCourseProgressItem(course)),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseProgressItem(CourseProgress course) {
    final progressGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        isDarkTheme ? Color(0xFF8E2DE2) : Color(0xFF4A00E0),
        isDarkTheme ? Color(0xFF005E89) : Color(0xFF005E89),
      ],
    );
    final progressPercentage = (course.progress * 100).round();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            isDarkTheme ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border:
            isDarkTheme
                ? Border.all(
                  color: Colors.white.withValues(alpha: 0.4),
                  width: 0.5,
                )
                : Border.all(color: Color(0xFFA2DFF7), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Course Title and Progress Percentage
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  course.title,
                  style: getDMTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ),
              Text(
                '$progressPercentage%',
                style: getDMTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDarkTheme ? Color(0xFFC7B0F5) : Color(0xFF005E89),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Progress Bar
          Container(
            height: 8,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: isDarkTheme ? Color(0xFFBEBEBE) : Color(0xFFBEBEBE),
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
          ),
          const SizedBox(height: 8),

          // Last Accessed
          Text(
            'Last accessed: ${course.lastAccessed}',
            style: getDMTextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: isDarkTheme ? Color(0xFFBEBEBE) : Color(0xFF939393),
            ),
          ),
        ],
      ),
    );
  }
}
