import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:prince1025/core/common/widgets/custom_app_bar.dart';
import 'package:prince1025/features/videos/controllers/video_detail_controller.dart';
import 'package:prince1025/features/videos/controllers/videos_controller.dart';
import 'package:prince1025/features/videos/widgets/videos_details_section.dart';
import 'package:prince1025/features/videos/widgets/video_player_section.dart';
import 'package:prince1025/features/videos/widgets/related_videos_section.dart';
import 'package:prince1025/features/videos/widgets/subscription_overlay.dart';
import 'package:prince1025/core/utils/constants/image_path.dart';
import 'package:prince1025/core/utils/constants/svg_path.dart';
import 'package:prince1025/routes/app_routes.dart';
import '../models/video_content_model.dart';

class VideoDetailScreen extends StatelessWidget {
  final VideoContent video;
  const VideoDetailScreen({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    Get.put(VideoDetailController(video: video));
    final videosController = Get.put(VideosController());
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final String? backgroundImage =
        isDarkTheme ? ImagePath.darkSettingScreenbackground : null;
    final textColor = isDarkTheme ? const Color(0xFFF5F5F5) : Colors.black87;
    final backgroundColor = isDarkTheme ? Colors.transparent : Colors.white;

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
        backgroundColor: backgroundColor,
        appBar: CustomAppBar(
          title: '',
          isFullView: true,
          actions: [
            IconButton(
              icon: SvgPicture.asset(
                SvgPath.searchSvg,
                height: 24,
                width: 24,
                colorFilter: ColorFilter.mode(
                  isDarkTheme ? Colors.white : Colors.black,
                  BlendMode.srcIn,
                ),
              ),
              onPressed: () {
                Get.toNamed(AppRoute.videoSearchScreen);
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Video Player Section
                  const VideoPlayerSection(),

                  // Video Details Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: VideoDetailsSection(
                      videosController: videosController,
                      isDarkTheme: isDarkTheme,
                      textColor: textColor,
                    ),
                  ),

                  // Related Videos Section
                  RelatedVideosSection(
                    isDarkTheme: isDarkTheme,
                    textColor: textColor,
                  ),
                ],
              ),
            ),

            // Subscription Warning Overlay
            SubscriptionOverlay(isDarkTheme: isDarkTheme),
          ],
        ),
      ),
    );
  }
}
