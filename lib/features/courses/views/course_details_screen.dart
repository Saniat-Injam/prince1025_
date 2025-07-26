import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prince1025/core/common/widgets/custom_app_bar.dart';
import 'package:prince1025/core/utils/constants/image_path.dart';
import 'package:prince1025/features/courses/controllers/course_details_controller.dart';
import 'package:prince1025/features/courses/widgets/course_content_section.dart';
import 'package:prince1025/features/courses/widgets/lesson_details_section.dart';
import 'package:prince1025/features/courses/widgets/progress_section.dart';
import 'package:prince1025/features/courses/widgets/video_section.dart';
import '../models/course_model.dart';


class CourseDetailsScreen extends StatelessWidget {
  final Course course;

  const CourseDetailsScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    // Initialize controller and theme variables
    final controller = Get.put(CourseDetailsController(course));
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final String? backgroundImage =
        isDarkTheme ? ImagePath.darkSettingScreenbackground : null;
    final textColor = isDarkTheme ? const Color(0xFFF5F5F5) : Colors.black;

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
        appBar: CustomAppBar(title: course.title, isFullView: true),
        body: Column(
          children: [
            // Video player or course image section (fixed at top)
            VideoSection(
              course: course,
              controller: controller,
              isDarkTheme: isDarkTheme,
              textColor: textColor,
            ),

            // Scrollable content area
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      // Lesson details section (when lesson is selected)
                      Obx(() {
                        if (controller.currentLesson.value != null) {
                          return LessonDetailsSection(
                            lesson: controller.currentLesson.value!,
                            controller: controller,
                            isDarkTheme: isDarkTheme,
                            textColor: textColor,
                          );
                        }
                        return const SizedBox.shrink();
                      }),

                      // Progress section
                      ProgressSection(
                        controller: controller,
                        isDarkTheme: isDarkTheme,
                        textColor: textColor,
                      ),

                      // Course content section (modules and lessons)
                      CourseContentSection(
                        controller: controller,
                        isDarkTheme: isDarkTheme,
                        textColor: textColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
