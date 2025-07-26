import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:prince1025/core/utils/constants/colors.dart';
import 'package:prince1025/core/utils/constants/svg_path.dart';
import 'package:prince1025/features/bottom_nav/controllers/bottom_nav_controller.dart';
import 'package:prince1025/features/home/views/home_screen.dart';
import 'package:prince1025/features/courses/views/courses_screen.dart';
import 'package:prince1025/features/quotes/views/quotes_screen.dart';
import 'package:prince1025/features/profile/views/main_profile_screen.dart';
import 'package:prince1025/features/videos/views/videos_screen.dart';

class BottomNavScreen extends StatelessWidget {
  const BottomNavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BottomNavController());
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Define your pages here
    final List<Widget> pages = [
      HomeScreen(),
      VideosScreen(),
      const CoursesScreen(),
      const QuotesScreen(),
      const MainProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: Obx(() => pages[controller.currentIndex.value]),
      bottomNavigationBar: Container(
        height: 108,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Stack(
          children: [
            // Gradient border for dark mode
            if (isDarkMode)
              Container(
                height: 108,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withValues(alpha: 0.1),
                      Colors.transparent,
                    ],
                    stops: [0.0, 0.3],
                  ),
                ),
              ),
            // Main navigation content
            Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              height: 108,
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.transparent : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow:
                    isDarkMode
                        ? []
                        : [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: .1),
                            blurRadius: 8,
                            offset: const Offset(2, 2),
                          ),
                        ],
              ),
              child: Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildNavItem(
                      context: context,
                      index: 0,
                      lightSvg: SvgPath.homeLightSvg,
                      darkSvg: SvgPath.homeDarkSvg,
                      label: 'Home',
                      controller: controller,
                      isDarkMode: isDarkMode,
                    ),
                    _buildNavItem(
                      context: context,
                      index: 1,
                      lightSvg: SvgPath.videoLightSvg,
                      darkSvg: SvgPath.videoDarkSvg,
                      label: 'Videos',
                      controller: controller,
                      isDarkMode: isDarkMode,
                    ),
                    _buildNavItem(
                      context: context,
                      index: 2,
                      lightSvg: SvgPath.coursesLightSvg,
                      darkSvg: SvgPath.coursesDarkSvg,
                      label: 'Courses',
                      controller: controller,
                      isDarkMode: isDarkMode,
                    ),
                    _buildNavItem(
                      context: context,
                      index: 3,
                      lightSvg: SvgPath.quotesLightSvg,
                      darkSvg: SvgPath.quotesDarkSvg,
                      label: 'Quotes',
                      controller: controller,
                      isDarkMode: isDarkMode,
                    ),
                    _buildNavItem(
                      context: context,
                      index: 4,
                      lightSvg: SvgPath.profileLightSvg,
                      darkSvg: SvgPath.profileDarkSvg,
                      label: 'Profile',
                      controller: controller,
                      isDarkMode: isDarkMode,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required String lightSvg,
    required String darkSvg,
    required String label,
    required BottomNavController controller,
    required bool isDarkMode,
  }) {
    final isSelected = controller.currentIndex.value == index;
    final svgPath = isDarkMode ? darkSvg : lightSvg;

    return GestureDetector(
      onTap: () => controller.changeIndex(index),
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: Container(
          decoration:
              isSelected
                  ? BoxDecoration(
                    color:
                        isDarkMode
                            ? Color(0xffF5F5F5).withValues(alpha: 0.1)
                            : Color(0x1AA2DFF7),
                    borderRadius: BorderRadius.circular(8),
                  )
                  : null,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(svgPath, width: 32, height: 32),
                // Label for the navigation item
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                    color:
                        isSelected
                            ? (isDarkMode
                                ? Colors.white
                                : AppColors.primaryDarkBlue)
                            : (isDarkMode ? Colors.white : Colors.black),
                  ),
                ),

                // Indicator for selected item
                Container(
                  height: 5,
                  width: 10,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    color:
                        isSelected && !isDarkMode
                            ? AppColors.primaryDarkBlue
                            : isSelected && isDarkMode
                            ? Colors.white
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
