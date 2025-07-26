import 'package:flutter/material.dart';
import 'package:prince1025/features/profile/widgets/custom_ev_button.dart';
import '../models/course_model.dart';
import 'course_card.dart';

class SingleCoursesList extends StatelessWidget {
  final List<Course> courses;
  final bool isDarkTheme;
  final Color textColor;
  final VoidCallback? onPremiumButtonTap;
  final Function(Course)? onCourseTap;
  final Function(Course)? onResumeTap;
  final bool showProgress;
  final bool showResumeButton;

  const SingleCoursesList({
    super.key,
    required this.courses,
    required this.isDarkTheme,
    required this.textColor,
    this.onPremiumButtonTap,
    this.onCourseTap,
    this.onResumeTap,
    this.showProgress = false,
    this.showResumeButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount:
          courses.length +
          (onPremiumButtonTap != null ? 1 : 0), // Add space for premium button
      itemBuilder: (context, index) {
        // Check if this is the premium button item
        if (index == courses.length && onPremiumButtonTap != null) {
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: CustomEVButton(
              onPressed: onPremiumButtonTap!,
              text: 'More Courses With Premium',
            ),
          );
        }

        final course = courses[index];

        return CourseCard(
          course: course,
          isDarkTheme: isDarkTheme,
          textColor: textColor,
          onTap: onCourseTap != null ? () => onCourseTap!(course) : null,
          onResumeTap: onResumeTap != null ? () => onResumeTap!(course) : null,
          showProgress: showProgress || course.progress > 0,
          showResumeButton:
              showResumeButton ||
              (course.progress > 0 && course.progress < 1.0),
        );
      },
    );
  }
}
