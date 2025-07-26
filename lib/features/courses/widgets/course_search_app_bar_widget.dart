import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:prince1025/features/profile/widgets/custom_form_field.dart';
import 'package:prince1025/features/courses/controllers/course_search_controller.dart';
import 'package:prince1025/core/utils/constants/svg_path.dart';

class CourseSearchAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final bool isDarkTheme;
  final Color textColor;

  const CourseSearchAppBarWidget({
    super.key,
    required this.isDarkTheme,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CourseSearchController>();

    return AppBar(
      backgroundColor: isDarkTheme ? Colors.transparent : Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: SvgPicture.asset(
          SvgPath.backArrowSvg,
          colorFilter: ColorFilter.mode(
            isDarkTheme ? Colors.white : Colors.black,
            BlendMode.srcIn,
          ),
        ),
        onPressed: () => Get.back(),
      ),
      title: Container(
        height: 48,
        decoration: BoxDecoration(
          color:
              isDarkTheme
                  ? const Color(0xFF2D3748).withValues(alpha: 0.8)
                  : const Color(0xFFF1F3F4),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Obx(() {
          return CustomFormField(
            controller: controller.searchController,
            hint: 'Search courses...',
            suffixIcon:
                controller.searchQuery.value.isNotEmpty
                    ? IconButton(
                      icon: Icon(Icons.clear, color: textColor, size: 20),
                      onPressed: controller.clearSearch,
                    )
                    : Icon(Icons.search, color: textColor, size: 24),
          );
        }),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
