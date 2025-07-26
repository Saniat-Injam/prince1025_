import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prince1025/core/common/widgets/custom_video_player/custom_video_player_widget.dart';
import 'package:prince1025/features/videos/controllers/video_detail_controller.dart';
import 'package:video_player/video_player.dart' show DataSourceType;

class VideoPlayerSection extends StatelessWidget {
  const VideoPlayerSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VideoDetailController>();

    return Obx(() {
      final video = controller.currentVideo.value;
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          color: Colors.black,
          child: CustomVideoPlayer(
            key: ValueKey(
              'video_${video.id}',
            ), // Add key to force rebuild when video changes
            videoPath: video.videoUrl,
            dataSourceType:
                video.videoUrl.startsWith('http')
                    ? DataSourceType.network
                    : DataSourceType.asset,
            tag: 'video_detail_${video.id}',
            videoTitle: video.title, // Pass video title
            previewDuration:
                controller.isPremiumRestricted
                    ? controller.previewDuration
                    : null,
            onNextVideo:
                controller.nextVideo != null ? controller.playNextVideo : null,
            onPreviousVideo:
                controller.previousVideo != null
                    ? controller.playPreviousVideo
                    : null,
          ),
        ),
      );
    });
  }
}
