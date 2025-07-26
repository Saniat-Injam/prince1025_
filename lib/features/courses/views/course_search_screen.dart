import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prince1025/core/utils/constants/colors.dart';
import 'package:prince1025/core/utils/constants/image_path.dart';
import 'package:prince1025/features/courses/controllers/course_search_controller.dart';
import 'package:prince1025/features/videos/widgets/empty_state_widget.dart';
import 'package:prince1025/features/courses/widgets/course_search_app_bar_widget.dart';
import 'package:prince1025/features/courses/widgets/course_search_suggestions_widget.dart';
import 'package:prince1025/features/courses/widgets/course_search_results_widget.dart';

class CourseSearchScreen extends StatelessWidget {
  const CourseSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CourseSearchController());
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final String? backgroundImage =
        isDarkTheme ? ImagePath.darkSettingScreenbackground : null;
    final textColor = isDarkTheme ? const Color(0xFFF5F5F5) : Colors.black87;
    final backgroundColor =
        isDarkTheme ? const Color(0xFF121212) : const Color(0xFFF8F9FA);

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
        backgroundColor: isDarkTheme ? Colors.transparent : backgroundColor,
        appBar: CourseSearchAppBarWidget(
          isDarkTheme: isDarkTheme,
          textColor: textColor,
        ),
        body: SafeArea(
          child: Obx(() {
            // If search query is empty, show search suggestions
            if (controller.searchQuery.value.isEmpty) {
              return CourseSearchSuggestionsWidget(
                isDarkTheme: isDarkTheme,
                textColor: textColor,
              );
            }

            // If search query is not empty, show search results
            if (controller.isSearching.value) {
              return Center(
                child: CircularProgressIndicator(
                  color: isDarkTheme ? Colors.white : AppColors.primaryDarkBlue,
                ),
              );
            }

            // If search results are empty, show empty state
            if (controller.searchResults.isEmpty) {
              return EmptyStateWidget(
                title: 'No courses found',
                subtitle: 'Try searching with different keywords',
                icon: Icons.search_off,
                isDarkTheme: isDarkTheme,
              );
            }

            // If search results are not empty, show search results
            return CourseSearchResultsWidget(
              isDarkTheme: isDarkTheme,
              textColor: textColor,
            );
          }),
        ),
      ),
    );
  }
}
