import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:prince1025/core/common/styles/global_text_style.dart';
import 'package:prince1025/core/utils/constants/svg_path.dart';
import 'package:video_player/video_player.dart';

import 'video_player_custom_controller.dart';

class CustomVideoPlayer extends StatelessWidget {
  final VideoPlayerCustomController controller;
  final String tag;
  final VoidCallback? onVideoEnd;
  final VoidCallback? onNextVideo;
  final VoidCallback? onPreviousVideo;
  final Duration? previewDuration; // Added previewDuration
  final String? videoTitle; // Add video title

  CustomVideoPlayer({
    super.key,
    required this.videoPath,
    required this.dataSourceType,
    required this.tag,
    this.onVideoEnd,
    this.onNextVideo,
    this.onPreviousVideo,
    this.previewDuration, // Added to constructor
    this.videoTitle, // Add to constructor
  }) : controller = Get.put(
         VideoPlayerCustomController(
           videoPath: videoPath,
           dataSourceType: dataSourceType,
           onVideoEnd: onVideoEnd,
           onNextVideo: onNextVideo,
           onPreviousVideo: onPreviousVideo,
           previewDuration: previewDuration, // Pass to controller
           videoTitle: videoTitle, // Pass to controller
         ),
         tag: tag,
       );

  final String videoPath;
  final DataSourceType dataSourceType;

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    if (hours > 0) {
      return "$hours:${twoDigits(minutes)}:${twoDigits(seconds)}";
    }
    return "${twoDigits(minutes)}:${twoDigits(seconds)}";
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Loading state Video is still loading
      if (!controller.isInitialized.value && controller.isLoading.value) {
        return Container(
          height: 200,
          width: double.infinity,
          color: Colors.black.withValues(alpha: 0.2),
          child: Center(
            child: CircularProgressIndicator(
              color:
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
            ),
          ),
        );
      }
      // Error state Video failed to load
      if (!controller.isInitialized.value && !controller.isLoading.value) {
        return Center(
          child: Container(
            height: 200,
            width: double.infinity,
            color: Colors.black.withValues(alpha: 0.2),
            // professtional design for error state
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 8),
                const Icon(Icons.error_outline, color: Colors.red, size: 32),
                const SizedBox(height: 8),
                Text(
                  'Failed to load video',
                  style: TextStyle(
                    color:
                        Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                  ),
                ),

                TextButton(
                  onPressed: () => controller.onInit(),
                  child: const Text("Retry"),
                ),
              ],
            ),
          ),
        );
      }

      return AspectRatio(
        aspectRatio: controller.playerController.value.aspectRatio,
        child: Stack(
          alignment: Alignment.center,
          children: [
            VideoPlayer(controller.playerController),
            GestureDetector(
              onTap: () {
                controller.toggleControlsVisibility();
              },
              onDoubleTapDown: (details) {
                final screenWidth = MediaQuery.of(context).size.width;
                final tapPosition = details.localPosition.dx;
                if (tapPosition < screenWidth / 3) {
                  controller.backwardSeconds(10);
                } else if (tapPosition > screenWidth * 2 / 3) {
                  controller.forwardSeconds(10);
                } else {
                  controller.playPause();
                }
              },
              child: Container(
                color: Colors.transparent, // Hit testing
              ),
            ),
            // controls overlay
            Obx(() {
              if (!controller.showControls.value) {
                return const SizedBox.shrink();
              }
              return _buildControlsOverlay(context);
            }),
            // loading indicator
            if (controller.isLoading.value &&
                !controller.playerController.value.isPlaying)
              Center(
                child: CircularProgressIndicator(
                  color:
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                ),
              ),

            // Volume indicator overlay
            Obx(() => _buildVolumeIndicator()),
          ],
        ),
      );
    });
  }

  Widget _buildVolumeIndicator() {
    if (!controller.showVolumeIndicator.value) {
      return const SizedBox.shrink();
    }

    return Positioned(
      top: 60,
      right: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              controller.isMuted.value || controller.currentVolume.value == 0.0
                  ? Icons.volume_off_rounded
                  : controller.currentVolume.value < 0.5
                  ? Icons.volume_down_rounded
                  : Icons.volume_up_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              controller.isMuted.value || controller.currentVolume.value == 0.0
                  ? 'Muted'
                  : '${(controller.currentVolume.value * 100).round()}%',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlsOverlay(BuildContext context) {
    return Stack(
      children: [
        // Center Play/Pause button (large)
        if (!controller.isPlaying.value)
          Center(
            child: IconButton(
              icon: const Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
                size: 70,
              ),
              onPressed: controller.playPause,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),

        // Bottom Controls Bar
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 4.0,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.7),
                ],
              ),
            ),
            child: Column(
              children: [
                _buildTimeSection(),

                _buildProgressBar(),
                _buildBottomControlsRow(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        children: [
          Text(
            _formatDuration(controller.position.value),
            style: getDMTextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            _formatDuration(controller.duration.value),
            style: getDMTextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Obx(() {
      final currentPosition = controller.position.value;
      final totalDuration = controller.duration.value;
      // final buffered = controller.buffered.value;

      double sliderValue = 0.0;
      if (totalDuration.inMilliseconds > 0) {
        sliderValue =
            currentPosition.inMilliseconds / totalDuration.inMilliseconds;
      }

      return SliderTheme(
        data: SliderThemeData(
          trackHeight: 4,
          thumbShape: const RoundSliderThumbShape(
            enabledThumbRadius: 7,
            disabledThumbRadius: 5,
          ),
          overlayShape: const RoundSliderOverlayShape(overlayRadius: 15),
          activeTrackColor: Colors.white,
          inactiveTrackColor: Colors.white.withValues(alpha: 0.3),
          thumbColor: Colors.white,
          overlayColor: Colors.white.withValues(alpha: 0.2),
          // Custom buffer color
          activeTickMarkColor: Colors.transparent,
          inactiveTickMarkColor: Colors.transparent,
        ),
        child: Slider(
          value: sliderValue.clamp(0.0, 1.0),
          onChanged: (value) {
            final newPosition = totalDuration * value;
            controller.seekTo(newPosition);
          },
        ),
      );
    });
  }

  Widget _buildBottomControlsRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left side: Previous, Play/Pause, Next (navigation controls)
        Row(
          children: [
            // Previous video button
            IconButton(
              icon: SvgPicture.asset(
                SvgPath.backSvg,
                colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
              onPressed: onPreviousVideo,
            ),
            Obx(
              () => IconButton(
                icon: Icon(
                  controller.isPlaying.value
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 32,
                ),
                onPressed: controller.playPause,
              ),
            ),
            // Next video button
            IconButton(
              icon: SvgPicture.asset(
                SvgPath.forwardSvg,
                colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
              onPressed: onNextVideo,
            ),
            // Volume controls with slider (YouTube style)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Volume/Mute button
                Obx(
                  () => GestureDetector(
                    onTap: controller.toggleVolumeSlider,
                    onLongPress: controller.toggleMute,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: SvgPicture.asset(
                        controller.isMuted.value ||
                                controller.currentVolume.value == 0.0
                            ? SvgPath.soundMuteSvg
                            : SvgPath.soundSvg,
                        colorFilter: ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ),
                ),
                // Volume slider - only shown when toggled
                Obx(
                  () => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: controller.showVolumeSlider.value ? 60 : 0,
                    child:
                        controller.showVolumeSlider.value
                            ? SliderTheme(
                              data: SliderThemeData(
                                trackHeight: 3,
                                thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 6,
                                  disabledThumbRadius: 4,
                                ),
                                overlayShape: const RoundSliderOverlayShape(
                                  overlayRadius: 12,
                                ),
                                activeTrackColor: Colors.white,
                                inactiveTrackColor: Colors.white.withValues(
                                  alpha: 0.3,
                                ),
                                thumbColor: Colors.white,
                                overlayColor: Colors.white.withValues(
                                  alpha: 0.2,
                                ),
                              ),
                              child: Slider(
                                value: controller.currentVolume.value.clamp(
                                  0.0,
                                  1.0,
                                ),
                                onChanged: (value) {
                                  controller.setVolume(value);
                                },
                                min: 0.0,
                                max: 1.0,
                              ),
                            )
                            : null,
                  ),
                ),
              ],
            ),
          ],
        ),
        // Right side: 10s controls, Settings, Fullscreen
        Row(
          children: [
            // IconButton(
            //   icon: const Icon(
            //     Icons.replay_10_rounded,
            //     color: Colors.white,
            //     size: 20,
            //   ),
            //   onPressed: () => controller.backwardSeconds(10),
            // ),
            // IconButton(
            //   icon: const Icon(
            //     Icons.forward_10_rounded,
            //     color: Colors.white,
            //     size: 20,
            //   ),
            //   onPressed: () => controller.forwardSeconds(10),
            // ),
            IconButton(
              icon: SvgPicture.asset(
                SvgPath.settingSvg,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
                width: 24,
                height: 24,
              ),
              onPressed: () => _showSettingsMenu(context),
              tooltip: 'Video Settings',
            ),
            IconButton(
              icon: SvgPicture.asset(
                SvgPath.fullscreenSvg,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
                width: 24,
                height: 24,
              ),
              onPressed: () => controller.toggleFullScreen(context),
              tooltip: 'Enter Fullscreen',
            ),
          ],
        ),
      ],
    );
  }

  void _showSettingsMenu(BuildContext context) {
    Get.bottomSheet(
      Material(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        color:
            Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[850]
                : Colors.white,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                'Video Settings',
                style: getDMTextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color:
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                ),
              ),
              const SizedBox(height: 16),

              // Playback Speed
              ListTile(
                leading: Icon(
                  Icons.slow_motion_video_rounded,
                  color:
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                ),
                title: Text(
                  'Playback Speed',
                  style: getDMTextStyle(
                    fontSize: 16,
                    color:
                        Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                  ),
                ),
                trailing: Obx(
                  () => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${controller.currentSpeed.value}x',
                      style: getDMTextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  Get.back(); // Close current sheet
                  _showPlaybackSpeedMenu(context);
                },
              ),

              // Loop Video
              Obx(
                () => SwitchListTile(
                  secondary: Icon(
                    Icons.loop_rounded,
                    color:
                        Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                  ),
                  title: Text(
                    'Loop Video',
                    style: getDMTextStyle(
                      fontSize: 16,
                      color:
                          Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                    ),
                  ),
                  value: controller.isLooping.value,
                  onChanged: (bool value) {
                    controller.toggleLooping();
                  },
                  activeColor: Theme.of(context).colorScheme.primary,
                ),
              ),

              // Quality (placeholder for future implementation)
              ListTile(
                leading: Icon(
                  Icons.high_quality_rounded,
                  color:
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                ),
                title: Text(
                  'Quality',
                  style: getDMTextStyle(
                    fontSize: 16,
                    color:
                        Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                  ),
                ),
                trailing: Obx(
                  () => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      controller.selectedQuality.value,
                      style: getDMTextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color:
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.white70
                                : Colors.black54,
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  Get.snackbar(
                    'Quality',
                    'Quality selection is not implemented for local assets.',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    colorText: Colors.white,
                  );
                },
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
    );
  }

  void _showPlaybackSpeedMenu(BuildContext context) {
    Get.bottomSheet(
      Material(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        color:
            Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[850]
                : Colors.white,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                'Playback Speed',
                style: getDMTextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color:
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                ),
              ),
              const SizedBox(height: 16),

              // Speed options
              ...controller.playbackSpeeds.map((speed) {
                return Obx(() {
                  final isSelected = controller.currentSpeed.value == speed;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.1)
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      title: Text(
                        '${speed}x',
                        style: getDMTextStyle(
                          fontSize: 16,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                          color:
                              isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : (Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black),
                        ),
                      ),
                      trailing:
                          isSelected
                              ? Icon(
                                Icons.check_rounded,
                                color: Theme.of(context).colorScheme.primary,
                              )
                              : null,
                      onTap: () {
                        controller.setPlaybackSpeed(speed);
                        Get.back();
                      },
                    ),
                  );
                });
              }).toList(),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
    );
  }
}
