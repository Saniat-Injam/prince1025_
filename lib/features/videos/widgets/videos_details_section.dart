import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:prince1025/core/common/styles/global_text_style.dart';
import 'package:prince1025/core/utils/constants/svg_path.dart';
import '../controllers/videos_controller.dart';
import '../controllers/video_detail_controller.dart';

/// Widget that displays lesson details including title, favorite/share actions, and description
class VideoDetailsSection extends StatelessWidget {
  final VideosController videosController;
  final bool isDarkTheme;
  final Color textColor;

  const VideoDetailsSection({
    super.key,
    required this.videosController,
    required this.isDarkTheme,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final videoDetailController = Get.find<VideoDetailController>();

    return Obx(() {
      final video = videoDetailController.currentVideo.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          // Lesson title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  video.title,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontFamily: 'Enwallowify',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),

              // Action buttons (favorite and share)
              Expanded(
                flex: 2,
                child: _buildActionButtons(video, videosController),
              ),
            ],
          ),

          const SizedBox(height: 8),
          // views count and published date
          Row(
            children: [
              Text(
                '${video.formattedViews} Views',
                style: TextStyle(
                  fontFamily: 'Enwallowify',
                  fontSize: 12,
                  color: textColor.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                video.publishedDate,
                style: TextStyle(
                  fontFamily: 'Enwallowify',
                  fontSize: 12,
                  color: textColor.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Lesson description with expand/collapse functionality
          _buildExpandableDescription(video, videosController),
        ],
      );
    });
  }

  /// Builds favorite and share action buttons
  Widget _buildActionButtons(video, VideosController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Favorite button
        Obx(() {
          final isFavorited = controller.isVideoFavorite(video.id);
          return IconButton(
            icon: Icon(
              isFavorited ? Icons.favorite : Icons.favorite_border,
              size: 26,
              color:
                  isFavorited
                      ? (isDarkTheme ? Colors.red : Colors.red)
                      : (isDarkTheme ? Colors.white : Colors.black),
            ),
            onPressed: () => controller.toggleVideoFavorite(video.id),
          );
        }),

        // Share button
        IconButton(
          icon: SvgPicture.asset(
            SvgPath.shareSvg,
            colorFilter: ColorFilter.mode(
              isDarkTheme ? Colors.white : Colors.black,
              BlendMode.srcIn,
            ),
          ),
          onPressed: () => controller.shareVideo(video),
        ),
      ],
    );
  }

  /// Builds expandable description with More/Less functionality
  Widget _buildExpandableDescription(video, VideosController controller) {
    return Obx(() {
      final description = video.description ?? "No description available.";
      final isExpanded = controller.isDescriptionExpanded.value;
      final canExpand = description.length > 120;

      final displayedDescription =
          isExpanded || !canExpand
              ? description
              : '${description.substring(0, 100)}...';

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            displayedDescription,
            style: getDMTextStyle(fontSize: 14, color: textColor),
          ),
          if (canExpand)
            GestureDetector(
              onTap: () => controller.toggleDescriptionExpansion(),
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  isExpanded ? "Less" : "More",
                  style: getDMTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDarkTheme ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
        ],
      );
    });
  }
}
