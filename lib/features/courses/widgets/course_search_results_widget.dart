import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prince1025/core/common/styles/global_text_style.dart';
import 'package:prince1025/features/courses/controllers/course_search_controller.dart';
import 'package:prince1025/features/courses/widgets/course_card.dart';

class CourseSearchResultsWidget extends StatelessWidget {
  final bool isDarkTheme;
  final Color textColor;

  const CourseSearchResultsWidget({
    super.key,
    required this.isDarkTheme,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CourseSearchController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Obx(() {
            return Text(
              '${controller.searchResults.length} results for "${controller.searchQuery.value}"',
              style: getDMTextStyle(
                fontSize: 16,
                color: textColor.withValues(alpha: 0.8),
              ),
            );
          }),
        ),
        Expanded(
          child: Obx(() {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: controller.searchResults.length,
              itemBuilder: (context, index) {
                final course = controller.searchResults[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SizedBox(
                    height: 218,
                    child: CourseCard(
                      course: course,
                      isDarkTheme: isDarkTheme,
                      textColor: textColor,
                      onTap: () => controller.navigateToCourseDetails(course),
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
