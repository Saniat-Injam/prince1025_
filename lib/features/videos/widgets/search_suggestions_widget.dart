import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prince1025/core/common/styles/global_text_style.dart';
import 'package:prince1025/features/videos/controllers/video_search_controller.dart';
import 'package:prince1025/features/videos/widgets/video_card.dart';

class SearchSuggestionsWidget extends StatelessWidget {
  final bool isDarkTheme;
  final Color textColor;

  const SearchSuggestionsWidget({
    super.key,
    required this.isDarkTheme,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VideoSearchController>();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Popular Searches',
            style: TextStyle(
              fontFamily: 'Enwallowify',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                controller.popularSearches.map((search) {
                  return GestureDetector(
                    onTap: () => controller.selectPopularSearch(search),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isDarkTheme
                                ? const Color(0xFF2D3748).withValues(alpha: 0.7)
                                : const Color(0xFFF1F3F4),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        search,
                        style: getDMTextStyle(fontSize: 12, color: textColor),
                      ),
                    ),
                  );
                }).toList(),
          ),
          const SizedBox(height: 24),
          Text(
            'Recent Videos',
            style: getDMTextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: controller.recentVideos.length,
              itemBuilder: (context, index) {
                final video = controller.recentVideos[index];
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
            ),
          ),
        ],
      ),
    );
  }
}
