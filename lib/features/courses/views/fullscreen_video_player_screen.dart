import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:prince1025/core/common/widgets/custom_video_player/custom_video_player_widget.dart';
import 'package:prince1025/core/common/widgets/custom_video_player/video_player_custom_controller.dart';
import 'package:video_player/video_player.dart' show DataSourceType;
import '../controllers/fullscreen_video_controller.dart';
import '../models/lesson_model.dart';

class FullscreenVideoPlayerScreen extends StatefulWidget {
  final List<Lesson> lessons;
  final int currentLessonIndex;
  final Function(String) onLessonCompleted;

  const FullscreenVideoPlayerScreen({
    super.key,
    required this.lessons,
    required this.currentLessonIndex,
    required this.onLessonCompleted,
  });

  @override
  State<FullscreenVideoPlayerScreen> createState() =>
      _FullscreenVideoPlayerScreenState();
}

class _FullscreenVideoPlayerScreenState
    extends State<FullscreenVideoPlayerScreen> {
  late FullscreenVideoController controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode();

    // Set system UI for fullscreen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    controller = Get.put(
      FullscreenVideoController(
        lessons: widget.lessons,
        currentLessonIndex: widget.currentLessonIndex,
        onLessonCompleted: widget.onLessonCompleted,
      ),
    );

    // Request focus for keyboard input
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();

    // Restore system UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    Get.delete<FullscreenVideoController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: (event) {
        if (event is KeyDownEvent) {
          final videoPlayerController = Get.find<VideoPlayerCustomController>(
            tag: 'fullscreen_video_${controller.videoPlayerKey.value}',
          );

          switch (event.logicalKey.keyLabel) {
            case 'Arrow Up':
              final currentVolume = videoPlayerController.currentVolume.value;
              videoPlayerController.setVolume(
                (currentVolume + 0.1).clamp(0.0, 1.0),
              );
              break;
            case 'Arrow Down':
              final currentVolume = videoPlayerController.currentVolume.value;
              videoPlayerController.setVolume(
                (currentVolume - 0.1).clamp(0.0, 1.0),
              );
              break;
            case 'M':
            case 'm':
              videoPlayerController.toggleMute();
              break;
            case 'Space':
              videoPlayerController.playPause();
              break;
            case 'Arrow Left':
              if (controller.canGoPrevious) {
                controller.goToPreviousLesson();
              }
              break;
            case 'Arrow Right':
              if (controller.canGoNext) {
                controller.goToNextLesson();
              }
              break;
          }
        }
      },
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) {
            // Handle back navigation
            Get.back(result: controller.currentLessonIndex.value);
          }
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: GestureDetector(
              onTap: controller.onScreenTap,
              onPanUpdate: (details) {
                // Handle vertical pan for volume control on the right side
                final screenWidth = MediaQuery.of(context).size.width;
                final panX = details.globalPosition.dx;

                // Volume control on right side (right 1/3 of screen)
                if (panX > screenWidth * 2 / 3) {
                  final videoPlayerController = Get.find<
                    VideoPlayerCustomController
                  >(tag: 'fullscreen_video_${controller.videoPlayerKey.value}');

                  // Calculate volume change based on vertical movement
                  final deltaY = details.delta.dy;
                  final volumeChange =
                      -deltaY /
                      200; // Negative because upward should increase volume
                  final newVolume = (videoPlayerController.currentVolume.value +
                          volumeChange)
                      .clamp(0.0, 1.0);
                  videoPlayerController.setVolume(newVolume);
                }
              },
              child: Stack(
                children: [
                  // Main video player
                  Center(
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Obx(() => _buildVideoPlayer()),
                    ),
                  ),

                  // Custom controls overlay
                  Obx(() => _buildCustomControls()),

                  // Volume indicator for fullscreen
                  Obx(() => _buildFullscreenVolumeIndicator()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVideoPlayer() {
    final lesson = controller.currentLesson;
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

    return CustomVideoPlayer(
      key: ValueKey('fullscreen_${controller.videoPlayerKey.value}'),
      videoPath: videoUrl,
      dataSourceType: videoDataSourceType,
      tag: 'fullscreen_video_${controller.videoPlayerKey.value}',
      onVideoEnd: () {
        controller.onVideoEnd();
      },
    );
  }

  Widget _buildCustomControls() {
    if (!controller.showCustomControls.value) {
      return const SizedBox.shrink();
    }

    return Container(
      color: Colors.black.withValues(alpha: 0.3),
      child: Stack(
        children: [
          // Top controls
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Row(
              children: [
                // Back button
                IconButton(
                  onPressed: () {
                    Get.back(result: controller.currentLessonIndex.value);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),

                // Lesson title
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.currentLesson.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${controller.currentLessonIndex.value + 1} of ${controller.lessons.length}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                // Minimize button
                IconButton(
                  onPressed: () {
                    Get.back(result: controller.currentLessonIndex.value);
                  },
                  icon: const Icon(
                    Icons.fullscreen_exit,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ],
            ),
          ),

          // Center navigation controls
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Previous lesson button
                _buildNavigationButton(
                  icon: Icons.skip_previous,
                  onPressed:
                      controller.canGoPrevious
                          ? controller.goToPreviousLesson
                          : null,
                  label: 'Previous',
                ),

                const SizedBox(width: 60),

                // Next lesson button
                _buildNavigationButton(
                  icon: Icons.skip_next,
                  onPressed:
                      controller.canGoNext ? controller.goToNextLesson : null,
                  label: 'Next',
                ),
              ],
            ),
          ),

          // Bottom controls
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Column(
              children: [
                // Lesson progress indicator
                if (controller.lessons.length > 1)
                  Container(
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: LinearProgressIndicator(
                      value:
                          (controller.currentLessonIndex.value + 1) /
                          controller.lessons.length,
                      backgroundColor: Colors.white.withValues(alpha: 0.3),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.blue,
                      ),
                    ),
                  ),

                // Lesson navigation row
                if (controller.lessons.length > 1)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Previous lesson info
                      Expanded(
                        child:
                            controller.canGoPrevious
                                ? _buildLessonInfo(
                                  controller.lessons[controller
                                          .currentLessonIndex
                                          .value -
                                      1],
                                  'Previous',
                                  Icons.skip_previous,
                                  controller.goToPreviousLesson,
                                )
                                : const SizedBox(),
                      ),

                      const SizedBox(width: 32),

                      // Next lesson info
                      Expanded(
                        child:
                            controller.canGoNext
                                ? _buildLessonInfo(
                                  controller.lessons[controller
                                          .currentLessonIndex
                                          .value +
                                      1],
                                  'Next',
                                  Icons.skip_next,
                                  controller.goToNextLesson,
                                )
                                : const SizedBox(),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required String label,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.6),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(
              icon,
              color: onPressed != null ? Colors.white : Colors.white38,
              size: 36,
            ),
            padding: const EdgeInsets.all(16),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: onPressed != null ? Colors.white : Colors.white38,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildLessonInfo(
    Lesson lesson,
    String label,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  Text(
                    lesson.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    lesson.duration,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFullscreenVolumeIndicator() {
    // Get the video player controller to access volume information
    final videoPlayerController = Get.find<VideoPlayerCustomController>(
      tag: 'fullscreen_video_${controller.videoPlayerKey.value}',
    );

    if (!videoPlayerController.showVolumeIndicator.value) {
      return const SizedBox.shrink();
    }

    return Positioned(
      top: 80,
      right: 40,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              videoPlayerController.isMuted.value ||
                      videoPlayerController.currentVolume.value == 0.0
                  ? Icons.volume_off_rounded
                  : videoPlayerController.currentVolume.value < 0.5
                  ? Icons.volume_down_rounded
                  : Icons.volume_up_rounded,
              color: Colors.white,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              videoPlayerController.isMuted.value ||
                      videoPlayerController.currentVolume.value == 0.0
                  ? 'Muted'
                  : '${(videoPlayerController.currentVolume.value * 100).round()}%',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            // Volume bar
            Container(
              height: 100,
              width: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height:
                      videoPlayerController.isMuted.value
                          ? 0
                          : 100 * videoPlayerController.currentVolume.value,
                  width: 4,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
