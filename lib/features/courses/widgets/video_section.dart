import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prince1025/core/common/styles/global_text_style.dart';
import 'package:prince1025/core/common/widgets/custom_video_player/custom_video_player_widget.dart';
import 'package:video_player/video_player.dart' show DataSourceType;
import '../controllers/course_details_controller.dart';
import '../models/course_model.dart';

/// Widget that displays either a video player for the current lesson
/// or the course image with title/subtitle overlay when no lesson is selected
class VideoSection extends StatelessWidget {
  final Course course;
  final CourseDetailsController controller;
  final bool isDarkTheme;
  final Color textColor;

  const VideoSection({
    super.key,
    required this.course,
    required this.controller,
    required this.isDarkTheme,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final currentLesson = controller.currentLesson.value;

      if (currentLesson != null) {
        // Show video player for selected lesson
        return _buildVideoPlayer(currentLesson);
      } else {
        // Show course image with overlay
        return _buildCourseImageOverlay();
      }
    });
  }

  /// Builds video player widget for current lesson
  Widget _buildVideoPlayer(lesson) {
    String videoUrl = lesson.videoUrl;
    DataSourceType videoDataSourceType;

    // Determine video source type
    if (videoUrl.startsWith('network:')) {
      videoDataSourceType = DataSourceType.network;
      videoUrl = videoUrl.replaceFirst('network:', '');
    } else if (videoUrl.startsWith('file:')) {
      videoDataSourceType = DataSourceType.file;
      videoUrl = videoUrl.replaceFirst('file:', '');
    } else {
      videoDataSourceType = DataSourceType.asset;
    }

    final String videoPlayerTag =
        'videoPlayer_${controller.videoPlayerKey.value}';

    return CustomVideoPlayer(
      key: ValueKey(videoPlayerTag),
      videoPath: videoUrl,
      dataSourceType: videoDataSourceType,
      tag: videoPlayerTag,
      onVideoEnd: () {
        controller.markLessonAsCompleted(lesson.id);
        // Auto-advance to next lesson if available
        if (controller.canGoNext) {
          controller.goToNextLesson();
        }
      },
      onNextVideo: controller.canGoNext ? controller.goToNextLesson : null,
      onPreviousVideo:
          controller.canGoPrevious ? controller.goToPreviousLesson : null,
    );
  }

  /// Builds course image with title/subtitle overlay
  Widget _buildCourseImageOverlay() {
    return Container(
      height: 240,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(course.imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                course.title,
                style: getDMTextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              Text(
                course.subtitle,
                style: getDMTextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
