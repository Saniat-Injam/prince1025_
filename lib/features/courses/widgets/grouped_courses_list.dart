import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prince1025/core/common/styles/global_text_style.dart';
import 'package:prince1025/features/profile/widgets/custom_ev_button.dart';
import 'package:prince1025/routes/app_routes.dart';
import '../models/course_model.dart';
import 'course_card.dart';

class GroupedCoursesList extends StatelessWidget {
  final List<Map<String, dynamic>> groupedCourses;
  final bool isDarkTheme;
  final Color textColor;
  final VoidCallback? onPremiumButtonTap;
  final Function(Course)? onCourseTap;
  final Function(Course)? onResumeTap;

  const GroupedCoursesList({
    super.key,
    required this.groupedCourses,
    required this.isDarkTheme,
    required this.textColor,
    this.onPremiumButtonTap,
    this.onCourseTap,
    this.onResumeTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount:
          groupedCourses.length +
          (onPremiumButtonTap != null ? 1 : 0), // Add space for premium button
      itemBuilder: (context, index) {
        // Check if this is the premium button item
        if (index == groupedCourses.length && onPremiumButtonTap != null) {
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: CustomEVButton(
              onPressed: onPremiumButtonTap!,
              text: 'More Courses With Premium',
            ),
          );
        }

        final section = groupedCourses[index];
        final sectionTitle = section['title'] as String;
        final courses = section['courses'] as List<Course>;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header
            _buildSectionHeader(sectionTitle, index),
            const SizedBox(height: 16),

            // Courses in Section
            ...courses.map((course) => _buildCourseItem(course, sectionTitle)),

            // Add spacing between sections
            if (index < groupedCourses.length - 1) const SizedBox(height: 24),
          ],
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, int sectionIndex) {
    final section = groupedCourses[sectionIndex];
    final courses = section['courses'] as List<Course>;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Enwallowify',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        if (courses.length >
            1) // Show "See All" if section has more than 1 course
          GestureDetector(
            onTap: () {
              _navigateToSectionScreen(title);
            },
            child: Text(
              'See All',
              style: getDMTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color:
                    isDarkTheme
                        ? const Color(0xFFC7B0F5)
                        : const Color(0xFF005E89),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCourseItem(Course course, String sectionTitle) {
    // Determine if this is the "Continue Where You Left" section
    final isContinueSection = sectionTitle == 'Continue Where You Left';

    return CourseCard(
      course: course,
      isDarkTheme: isDarkTheme,
      textColor: textColor,
      onTap: onCourseTap != null ? () => onCourseTap!(course) : null,
      onResumeTap:
          isContinueSection && onResumeTap != null
              ? () => onResumeTap!(course)
              : null,
      showProgress: course.progress > 0,
      showResumeButton: isContinueSection,
    );
  }

  void _navigateToSectionScreen(String sectionTitle) {
    String route;
    switch (sectionTitle) {
      case 'Continue Where You Left':
        route = AppRoute.getCourseContinueScreen();
        break;
      case 'In Progress':
        route = AppRoute.getCourseInProgressScreen();
        break;
      case 'Available Courses':
        route = AppRoute.getCourseAvailableScreen();
        break;
      case 'Completed':
        route = AppRoute.getCourseCompletedScreen();
        break;
      default:
        return;
    }
    Get.toNamed(route);
  }
}
