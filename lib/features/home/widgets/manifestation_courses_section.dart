import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prince1025/core/common/styles/global_text_style.dart';
import 'package:prince1025/features/bottom_nav/controllers/bottom_nav_controller.dart';
import 'package:prince1025/features/home/controllers/home_controller.dart';
import 'package:prince1025/features/home/widgets/home_courses_card.dart';

class ManifestationCoursesSection extends StatelessWidget {
  final HomeController controller;
  final bool isDarkTheme;
  final Color textColor;

  const ManifestationCoursesSection({
    super.key,
    required this.controller,
    required this.isDarkTheme,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final BottomNavController bottomNavController = Get.put(
      BottomNavController(),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Manifestation Courses',
              style: TextStyle(
                fontFamily: 'Enwallowify',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: textColor,
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
                      isDarkTheme
                          ? const Color(0xFFC7B0F5)
                          : const Color(0xFF005E89),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var course in controller.manifestationCourses)
                Container(
                  height: 200,
                  width: 260,
                  margin: EdgeInsets.only(right: 16),
                  child: HomeCoursesCard(
                    course: course,
                    isDarkTheme: isDarkTheme,
                    textColor: textColor,
                    onTap: () => controller.navigateToCourseDetails(course),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
