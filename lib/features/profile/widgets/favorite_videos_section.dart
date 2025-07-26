import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prince1025/core/common/styles/global_text_style.dart';
import 'package:prince1025/features/videos/controllers/videos_controller.dart';
import 'package:prince1025/features/videos/widgets/video_card.dart';
import 'package:prince1025/routes/app_routes.dart';

class FavoriteVideosSection extends StatelessWidget {
  final Color textColor;
  final bool isDarkTheme;

  const FavoriteVideosSection({
    required this.textColor,
    required this.isDarkTheme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Try to get the VideosController, if not found, initialize it
    VideosController videosController;
    try {
      videosController = Get.find<VideosController>();
    } catch (e) {
      videosController = Get.put(VideosController());
    }

    return Obx(() {
      final favoriteVideos =
          videosController.favoriteVideosList.take(2).toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Favorite Videos',
                style: TextStyle(
                  fontFamily: 'Enwallowify',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoute.getAllFavoriteVideosScreen());
                },
                child: Text(
                  'See All',
                  style: getDMTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isDarkTheme ? Color(0xFFC7B0F5) : Color(0xFF005E89),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Videos Grid
          if (favoriteVideos.isEmpty)
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDarkTheme ? Color(0xFF071123) : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border:
                    isDarkTheme
                        ? Border.all(color: Color(0xFF133663), width: 0.8)
                        : Border.all(color: Color(0xFFA2DFF7), width: 0.5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 48,
                    color: isDarkTheme ? Colors.grey[400]! : Colors.grey[600]!,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No favorite videos yet',
                    style: getDMTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color:
                          isDarkTheme ? Colors.grey[400]! : Colors.grey[600]!,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add videos to favorites by tapping the heart icon',
                    style: getDMTextStyle(
                      fontSize: 12,
                      color:
                          isDarkTheme ? Colors.grey[500]! : Colors.grey[500]!,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          else
            Row(
              children:
                  favoriteVideos.map((video) {
                    final isFirst = favoriteVideos.indexOf(video) == 0;
                    return Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: isFirst ? 8 : 0),
                        height: 200,
                        child: VideoCard(
                          video: video,
                          isDarkTheme: isDarkTheme,
                          onTap: () => videosController.playVideo(video),
                          onFavoriteTap:
                              () => videosController.toggleVideoFavorite(
                                video.id,
                              ),
                          isFavorite: videosController.isVideoFavorite(
                            video.id,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
        ],
      );
    });
  }
}
