import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prince1025/core/common/styles/global_text_style.dart';
import 'package:prince1025/core/common/widgets/custom_app_bar.dart';
import 'package:prince1025/core/utils/constants/image_path.dart';
import 'package:prince1025/features/videos/controllers/videos_controller.dart';
import 'package:prince1025/features/videos/widgets/video_card.dart';

class AllFavoriteVideosScreen extends StatelessWidget {
  const AllFavoriteVideosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final String? backgroundImage =
        isDarkTheme ? ImagePath.darkSettingScreenbackground : null;

    // Try to get the VideosController, if not found, initialize it
    VideosController videosController;
    try {
      videosController = Get.find<VideosController>();
    } catch (e) {
      videosController = Get.put(VideosController());
    }

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
        backgroundColor: isDarkTheme ? Colors.transparent : Colors.white,
        appBar: CustomAppBar(
          title: 'Favorite Videos',
          backgroundColor: isDarkTheme ? Colors.transparent : Colors.white,
          foregroundColor: isDarkTheme ? Colors.white : null,
          elevation: 0,
        ),
        body: SafeArea(
          child: Obx(() {
            final favoriteVideos = videosController.favoriteVideosList;

            if (favoriteVideos.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 80,
                      color:
                          isDarkTheme ? Colors.grey[400]! : Colors.grey[600]!,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'No favorite videos yet',
                      style: getDMTextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color:
                            isDarkTheme ? Colors.grey[300]! : Colors.grey[700]!,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        'Start adding videos to your favorites by tapping the heart icon on any video',
                        style: getDMTextStyle(
                          fontSize: 14,
                          color:
                              isDarkTheme
                                  ? Colors.grey[400]!
                                  : Colors.grey[600]!,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.9,
                ),
                itemCount: favoriteVideos.length,
                itemBuilder: (context, index) {
                  final video = favoriteVideos[index];
                  return VideoCard(
                    video: video,
                    isDarkTheme: isDarkTheme,
                    onTap: () => videosController.playVideo(video),
                    onFavoriteTap:
                        () => videosController.toggleVideoFavorite(video.id),
                    isFavorite: videosController.isVideoFavorite(video.id),
                  );
                },
              ),
            );
          }),
        ),
      ),
    );
  }
}
