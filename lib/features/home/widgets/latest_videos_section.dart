import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prince1025/core/common/styles/global_text_style.dart';
import 'package:prince1025/features/bottom_nav/controllers/bottom_nav_controller.dart';
import 'package:prince1025/features/home/controllers/home_controller.dart';
import 'package:prince1025/features/videos/widgets/video_card.dart';

class LatestVideosSection extends StatelessWidget {
  final HomeController homeController;
  final bool isDarkTheme;
  final Color textColor;

  const LatestVideosSection({
    super.key,
    required this.homeController,
    required this.isDarkTheme,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final BottomNavController bottomNavController = Get.put(
      BottomNavController(),
    );
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Latest Videos',
              style: TextStyle(
                fontFamily: 'Enwallowify',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            GestureDetector(
              onTap: () => bottomNavController.changeIndex(1),
              child: Text(
                'See All',
                style: getDMTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color:
                      isDarkTheme
                          ? const Color(0xFFC7B0F5)
                          : const Color(0xFF005E89),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var video in homeController.latestVideos)
                Container(
                  height: 200,
                  width: 260,

                  margin: EdgeInsets.only(right: 16),
                  child: VideoCard(
                    isHomeScreen: true,
                    video: video,
                    isDarkTheme: isDarkTheme,
                    onTap: () => homeController.playVideo(video),
                    onFavoriteTap: () {
                      // Implement favorite functionality
                    },
                    isFavorite: false,
                    isFavButtonVisible: false,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
