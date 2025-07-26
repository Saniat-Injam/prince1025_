import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:prince1025/core/common/styles/global_text_style.dart';
import 'package:prince1025/features/courses/models/course_model.dart';

class HomeCoursesCard extends StatelessWidget {
  final Course course;
  final bool isDarkTheme;
  final Color textColor;
  final VoidCallback? onTap;

  const HomeCoursesCard({
    super.key,
    required this.course,
    required this.isDarkTheme,
    required this.textColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isDarkTheme ? Color(0xFF071123) : Colors.white,
          border:
              isDarkTheme
                  ? Border.all(color: Color(0xFF133663), width: 0.8)
                  : Border.all(color: Color(0xFFA2DFF7), width: 0.5),
          boxShadow:
              isDarkTheme
                  ? null
                  : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Background Image
              Stack(
                children: [
                  SizedBox(
                    height: 120,
                    width: double.infinity,
                    child: CachedNetworkImage(
                      imageUrl: course.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[300],
                        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[300],
                        child: const Center(child: Icon(Icons.error)),
                      ),
                    ),
                  ),
                ],
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.title,
                      style: getDMTextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDarkTheme ? Color(0xFFF5F5F5) : textColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${course.totalLessons.toString()} Lessons',
                      style: getDMTextStyle(fontSize: 14, color: textColor),
                    ),
                  ],
                ),
              ),
          
            ],
          ),
        ),
      ),
    );
  }
}
