import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prince1025/core/common/widgets/custom_app_bar.dart';
import 'package:prince1025/core/utils/constants/image_path.dart';
import 'package:prince1025/features/courses/controllers/courses_controller.dart';
import 'package:prince1025/features/courses/models/course_model.dart';
import 'package:prince1025/features/courses/widgets/course_card.dart';
import 'package:prince1025/features/courses/views/course_details_screen.dart';

class CourseSectionScreen extends StatelessWidget {
  final String sectionTitle;
  final String sectionType;

  const CourseSectionScreen({
    super.key,
    required this.sectionTitle,
    required this.sectionType,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CoursesController>();
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final String? backgroundImage =
        isDarkTheme ? ImagePath.darkSettingScreenbackground : null;
    final textColor = isDarkTheme ? const Color(0xFFF5F5F5) : Colors.black87;

    return Container(
      decoration: BoxDecoration(
        image:
            isDarkTheme && backgroundImage != null
                ? DecorationImage(
                  image: AssetImage(backgroundImage),
                  fit: BoxFit.cover,
                )
                : null,
      ),
      child: Scaffold(
        backgroundColor: isDarkTheme ? Colors.transparent : Colors.white,
        appBar: CustomAppBar(
          title: sectionTitle,
          backgroundColor: isDarkTheme ? Colors.transparent : Colors.white,
          foregroundColor: isDarkTheme ? Colors.white : null,
          elevation: 0,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildCoursesList(controller, isDarkTheme, textColor),
          ),
        ),
      ),
    );
  }

  Widget _buildCoursesList(
    CoursesController controller,
    bool isDarkTheme,
    Color textColor,
  ) {
    List<Course> courses = _getCoursesBySection(controller);

    if (courses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.school_outlined,
              size: 64,
              color: isDarkTheme ? Colors.grey[600] : Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No courses found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: isDarkTheme ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Check back later for new courses',
              style: TextStyle(
                fontSize: 14,
                color: isDarkTheme ? Colors.grey[500] : Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: CourseCard(
            course: course,
            isDarkTheme: isDarkTheme,
            textColor: textColor,
            onTap: () => _onCourseTap(course),
            onResumeTap:
                _shouldShowResumeButton(course)
                    ? () => _onResumeTap(course)
                    : null,
            showProgress: course.progress > 0,
            showResumeButton: _shouldShowResumeButton(course),
          ),
        );
      },
    );
  }

  List<Course> _getCoursesBySection(CoursesController controller) {
    switch (sectionType) {
      case 'continue':
        return controller.allCourses
            .where((c) => c.progress > 0 && c.progress < 1.0)
            .toList();
      case 'in_progress':
        return controller.allCourses
            .where((c) => c.progress > 0 && c.progress < 1.0)
            .toList();
      case 'available':
        return controller.allCourses.where((c) => c.progress == 0).toList();
      case 'completed':
        return controller.allCourses.where((c) => c.progress == 1.0).toList();
      default:
        return controller.allCourses;
    }
  }

  bool _shouldShowResumeButton(Course course) {
    return sectionType == 'continue' ||
        (sectionType == 'in_progress' &&
            course.progress > 0 &&
            course.progress < 1.0);
  }

  void _onCourseTap(Course course) {
    Get.to(() => CourseDetailsScreen(course: course));
  }

  void _onResumeTap(Course course) {
    Get.to(() => CourseDetailsScreen(course: course));
  }
}
