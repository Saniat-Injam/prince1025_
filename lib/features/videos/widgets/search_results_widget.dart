import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prince1025/core/common/styles/global_text_style.dart';
import 'package:prince1025/features/videos/controllers/video_search_controller.dart';
import 'package:prince1025/features/videos/widgets/video_card.dart';

class SearchResultsWidget extends StatelessWidget {
  final bool isDarkTheme;
  final Color textColor;

  const SearchResultsWidget({
    super.key,
    required this.isDarkTheme,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VideoSearchController>();

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
                final video = controller.searchResults[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SizedBox(
                    height: 200,
                    child: VideoCard(
                      video: video,
                      isDarkTheme: isDarkTheme,
                      onTap: () => controller.playVideo(video),
                      onFavoriteTap:
                          () => controller.toggleVideoFavorite(video.id),
                      isFavorite: controller.isVideoFavorite(video.id),
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
