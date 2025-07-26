import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:prince1025/core/common/styles/global_text_style.dart';
import 'package:prince1025/core/utils/constants/svg_path.dart';
import 'package:video_player/video_player.dart';

import 'video_player_custom_controller.dart';

/// A widget that displays a fullscreen video player overlay.
///
/// This widget is intended to be used with an [OverlayEntry] to show a video
/// player that covers the entire screen. It reuses the provided
/// [VideoPlayerCustomController] to maintain the video's state.
///
class FullscreenPlayerOverlay extends StatelessWidget {
  final VideoPlayerCustomController controller;

  const FullscreenPlayerOverlay({super.key, required this.controller});

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
    return Material(
      color: Colors.black,
      child: Obx(
        () => Focus(
          autofocus: true,
          child: GestureDetector(
            onTap: controller.toggleControlsVisibility,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: Center(
                child: AspectRatio(
                  aspectRatio: controller.playerController.value.aspectRatio,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      VideoPlayer(controller.playerController),
                      GestureDetector(
                        onTap: controller.toggleControlsVisibility,
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
                        child: Container(color: Colors.transparent),
                      ),

                      // Animated controls overlay
                      AnimatedOpacity(
                        opacity: controller.showControls.value ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child:
                            controller.showControls.value
                                ? _buildControlsOverlay(context)
                                : const SizedBox.shrink(),
                      ),

                      if (controller.isLoading.value &&
                          !controller.playerController.value.isPlaying)
                        const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      _buildVolumeIndicator(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVolumeIndicator() {
    return Obx(() {
      if (!controller.showVolumeIndicator.value) {
        return const SizedBox.shrink();
      }
      return Positioned(
        top: 60,
        right: 20,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.8), // 0.8 opacity
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                controller.isMuted.value ||
                        controller.currentVolume.value == 0.0
                    ? Icons.volume_off_rounded
                    : controller.currentVolume.value < 0.5
                    ? Icons.volume_down_rounded
                    : Icons.volume_up_rounded,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                controller.isMuted.value ||
                        controller.currentVolume.value == 0.0
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
    });
  }

  Widget _buildControlsOverlay(BuildContext context) {
    return Stack(
      children: [
        // Top gradient with back button and title
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8,
              left: 12,
              right: 12,
              bottom: 20,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.7), // 0.7 opacity
                  Colors.transparent,
                ],
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () => controller.toggleFullScreen(context),
                  tooltip: 'Exit Fullscreen',
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    controller.videoTitle ?? '',
                    style: getDMTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Center play button when paused
        if (!controller.isPlaying.value)
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 70,
                ),
                onPressed: controller.playPause,
              ),
            ),
          ),

        // Bottom controls
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
                  Colors.black.withAlpha(179),
                ], // 0.7 opacity
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
      child: Obx(
        () => Row(
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
      ),
    );
  }

  Widget _buildProgressBar() {
    return Obx(() {
      final currentPosition = controller.position.value;
      final totalDuration = controller.duration.value;
      double sliderValue = 0.0;
      if (totalDuration.inMilliseconds > 0) {
        sliderValue =
            currentPosition.inMilliseconds / totalDuration.inMilliseconds;
      }

      return SliderTheme(
        data: SliderThemeData(
          trackHeight: 4,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
          overlayShape: const RoundSliderOverlayShape(overlayRadius: 15),
          activeTrackColor: Colors.white,
          inactiveTrackColor: Colors.white.withAlpha(77), 
          thumbColor: Colors.white,
          overlayColor: Colors.white.withAlpha(51), 
        ),
        child: Slider(
          value: sliderValue.clamp(0.0, 1.0),
          onChanged: (value) {
            controller.seekTo(totalDuration * value);
          },
        ),
      );
    });
  }

  Widget _buildBottomControlsRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            // Previous video button
            Opacity(
              opacity: controller.onPreviousVideo != null ? 1.0 : 0.3,
              child: IconButton(
                icon: SvgPicture.asset(
                  SvgPath.backSvg,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
                onPressed: controller.onPreviousVideo,
                tooltip:
                    controller.onPreviousVideo != null
                        ? 'Previous Video'
                        : 'No previous video',
              ),
            ),

            // Play/Pause button
            Obx(
              () => Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    controller.isPlaying.value
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 36,
                  ),
                  onPressed: controller.playPause,
                  tooltip: controller.isPlaying.value ? 'Pause' : 'Play',
                ),
              ),
            ),

            // Next video button
            Opacity(
              opacity: controller.onNextVideo != null ? 1.0 : 0.3,
              child: IconButton(
                icon: SvgPicture.asset(
                  SvgPath.forwardSvg,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
                onPressed: controller.onNextVideo,
                tooltip:
                    controller.onNextVideo != null
                        ? 'Next Video'
                        : 'No next video',
              ),
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
                        colorFilter: const ColorFilter.mode(
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
                    width: controller.showVolumeSlider.value ? 80 : 0,
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
                                inactiveTrackColor: Colors.white.withAlpha(77),
                                thumbColor: Colors.white,
                                overlayColor: Colors.white.withAlpha(51),
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
        Row(
          children: [
            // Settings button with better styling
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
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
            ),
            const SizedBox(width: 12),

            // Fullscreen exit button
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.fullscreen_exit_rounded,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: () => controller.toggleFullScreen(context),
                tooltip: 'Exit Fullscreen',
              ),
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
                  onChanged: (value) => controller.toggleLooping(),
                  activeColor: Theme.of(context).colorScheme.primary,
                ),
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
