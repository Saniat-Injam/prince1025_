import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prince1025/core/common/styles/global_text_style.dart';
import 'package:prince1025/features/videos/controllers/video_detail_controller.dart';
import 'package:prince1025/features/videos/widgets/video_card.dart';

class RelatedVideosSection extends StatelessWidget {
  final bool isDarkTheme;
  final Color textColor;

  const RelatedVideosSection({
    super.key,
    required this.isDarkTheme,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VideoDetailController>();

    return Obx(() {
      final relatedVideos =
          controller.relatedVideos
              .take(6)
              .toList(); // Take 6 videos for 3 rows of 2

      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You might also like',
              style: getDMTextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            const SizedBox(height: 16),
            // Grid layout with 2 videos per row
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.9,
              ),
              itemCount: relatedVideos.length,
              itemBuilder: (context, index) {
                final video = relatedVideos[index];
                return VideoCard(
                  video: video,
                  isDarkTheme: isDarkTheme,
                  onTap: () => controller.playRelatedVideo(video),
                  onFavoriteTap: () => controller.toggleVideoFavorite(video.id),
                  isFavorite: controller.isVideoFavorite(video.id),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      );
    });
  }
}
