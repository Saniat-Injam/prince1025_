import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:prince1025/core/common/widgets/custom_app_bar.dart';
import 'package:prince1025/core/utils/constants/image_path.dart';
import 'package:prince1025/core/utils/constants/svg_path.dart';
import 'package:prince1025/features/courses/controllers/courses_controller.dart';
import 'package:prince1025/features/courses/widgets/grouped_courses_list.dart';
import 'package:prince1025/routes/app_routes.dart';
import 'course_details_screen.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CoursesController());
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
          showBackButton: false,

          automaticallyImplyLeading: false,
          title: 'My Courses',
          actions: [
            IconButton(
              tooltip: 'Search courses',
              icon: SvgPicture.asset(
                SvgPath.searchSvg,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  isDarkTheme ? Colors.white : Colors.black,
                  BlendMode.srcIn,
                ),
              ),
              onPressed: () {
                Get.toNamed(AppRoute.getCourseSearchScreen());
              },
            ),
          ],
        ),
        body: SafeArea(
          child: GroupedCoursesList(
            groupedCourses: controller.groupedCourses,
            isDarkTheme: isDarkTheme,
            textColor: textColor,
            onPremiumButtonTap: () => _navigateToSubscription(),
            onCourseTap: (course) => _onCourseTap(course),
            onResumeTap: (course) => _onResumeTap(course),
          ),
        ),
      ),
    );
  }

  void _navigateToSubscription() {
    Get.toNamed('/subscription');
  }

  void _onCourseTap(course) {
    // Navigate to course details screen
    Get.to(() => CourseDetailsScreen(course: course));
  }

  void _onResumeTap(course) {
    // Navigate to course player with resume functionality
    Get.to(() => CourseDetailsScreen(course: course));
  }
}
