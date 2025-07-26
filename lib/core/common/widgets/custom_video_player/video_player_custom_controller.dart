import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:prince1025/core/common/widgets/custom_video_player/fullscreen_player_overlay.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerCustomController extends GetxController {
  final String videoPath;
  final DataSourceType dataSourceType;
  final VoidCallback? onVideoEnd;
  final VoidCallback? onNextVideo;
  final VoidCallback? onPreviousVideo;
  final Duration? previewDuration;
  final String? videoTitle; // Add video title property

  VideoPlayerCustomController({
    required this.videoPath,
    required this.dataSourceType,
    this.onVideoEnd,
    this.onNextVideo,
    this.onPreviousVideo,
    this.previewDuration,
    this.videoTitle, // Add to constructor
  });

  late VideoPlayerController playerController;
  OverlayEntry? _overlayEntry;

  final RxBool isInitialized = false.obs;
  final RxBool isLoading = true.obs;
  final RxBool isPlaying = false.obs;
  final Rx<Duration> duration = Duration.zero.obs;
  final Rx<Duration> position = Duration.zero.obs;
  final Rx<List<DurationRange>> buffered = Rx<List<DurationRange>>([]);
  final RxDouble currentVolume = 1.0.obs;
  final RxDouble previousVolume = 1.0.obs;
  final RxBool isMuted = false.obs;
  final RxDouble currentSpeed = 1.0.obs;
  final RxBool isLooping = false.obs;
  final RxBool isFullScreen = false.obs;
  final RxBool showControls = true.obs;
  final RxBool showVolumeIndicator = false.obs;
  final RxBool showVolumeSlider = false.obs;

  Timer? _controlsTimer;
  Timer? _volumeIndicatorTimer;
  Timer? _volumeSliderTimer;
  static const _controlsTimeout = Duration(seconds: 3);
  static const _volumeIndicatorTimeout = Duration(seconds: 2);
  static const _volumeSliderTimeout = Duration(seconds: 3);

  final List<double> playbackSpeeds = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];
  final List<String> availableQualities = ['Auto'];
  final RxString selectedQuality = 'Auto'.obs;

  @override
  void onInit() {
    super.onInit();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    isLoading.value = true;
    isInitialized.value = false;
    try {
      switch (dataSourceType) {
        case DataSourceType.asset:
          playerController = VideoPlayerController.asset(videoPath);
          break;
        case DataSourceType.network:
          playerController = VideoPlayerController.networkUrl(
            Uri.parse(videoPath),
          );
          break;
        case DataSourceType.file:
          throw UnimplementedError("File data source not implemented yet");
        case DataSourceType.contentUri:
          throw UnimplementedError(
            "Content URI data source not implemented yet",
          );
      }

      await playerController.initialize();

      duration.value = playerController.value.duration;
      position.value = playerController.value.position;
      buffered.value = playerController.value.buffered;
      isPlaying.value = playerController.value.isPlaying;
      currentVolume.value = playerController.value.volume;
      isLooping.value = playerController.value.isLooping;

      playerController.addListener(_playerListener);

      isInitialized.value = true;
      isLoading.value = false;

      if (previewDuration != null && previewDuration! > Duration.zero) {
        Timer(previewDuration!, () {
          if (isPlaying.value && isInitialized.value) {
            pause();
          }
        });
      }
      resetControlsTimer();
    } catch (e) {
      isLoading.value = false;
      isInitialized.value = false;
      Get.snackbar(
        'Error',
        'Failed to initialize video player: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      if (kDebugMode) {
        print("Video Player Initialization Error: $e");
      }
    }
  }

  void _playerListener() {
    if (!playerController.value.isInitialized) return;

    position.value = playerController.value.position;
    buffered.value = playerController.value.buffered;
    isPlaying.value = playerController.value.isPlaying;
    isLoading.value =
        playerController.value.isBuffering && !playerController.value.isPlaying;

    if (playerController.value.hasError) {
      Get.snackbar(
        'Error',
        playerController.value.errorDescription ??
            'An unknown video error occurred.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }

    if (position.value >= duration.value &&
        duration.value > Duration.zero &&
        !isLooping.value &&
        playerController.value.isPlaying) {
      playerController.pause();
      playerController.seekTo(duration.value);
      isPlaying.value = false;
      showControls.value = true;
      _controlsTimer?.cancel();
      onVideoEnd?.call();
    }
  }

  void play() {
    if (!isInitialized.value || playerController.value.isPlaying) return;
    playerController.play();
    isPlaying.value = true;
    resetControlsTimer();
  }

  void pause() {
    if (!isInitialized.value || !playerController.value.isPlaying) return;
    playerController.pause();
    isPlaying.value = false;
    showControls.value = true;
    _controlsTimer?.cancel();
  }

  void playPause() {
    if (playerController.value.isPlaying) {
      pause();
    } else {
      if (position.value >= duration.value) {
        seekTo(Duration.zero);
      }
      play();
    }
  }

  void seekTo(Duration newPosition) {
    if (!isInitialized.value) return;
    playerController.seekTo(newPosition);
    position.value = newPosition;
    resetControlsTimer();
  }

  void setVolume(double volume) {
    if (!isInitialized.value) return;
    final newVolume = volume.clamp(0.0, 1.0);

    if (newVolume == 0.0) {
      if (currentVolume.value > 0.0) {
        previousVolume.value = currentVolume.value;
      }
      isMuted.value = true;
    } else {
      isMuted.value = false;
      if (currentVolume.value == 0.0 && newVolume > 0.0) {
        previousVolume.value = newVolume;
      }
    }

    currentVolume.value = newVolume;
    playerController.setVolume(currentVolume.value);
    _showVolumeIndicator();

    if (showVolumeSlider.value) {
      _resetVolumeSliderTimer();
    }

    resetControlsTimer();
  }

  void toggleMute() {
    if (!isInitialized.value) return;
    if (isMuted.value || currentVolume.value == 0.0) {
      final restoreVolume =
          previousVolume.value > 0.0 ? previousVolume.value : 0.5;
      setVolume(restoreVolume);
    } else {
      if (currentVolume.value > 0.0) {
        previousVolume.value = currentVolume.value;
      }
      setVolume(0.0);
    }
  }

  void _showVolumeIndicator() {
    showVolumeIndicator.value = true;
    _volumeIndicatorTimer?.cancel();
    _volumeIndicatorTimer = Timer(_volumeIndicatorTimeout, () {
      showVolumeIndicator.value = false;
    });
  }

  void toggleVolumeSlider() {
    showVolumeSlider.value = !showVolumeSlider.value;
    if (showVolumeSlider.value) {
      _resetVolumeSliderTimer();
    } else {
      _volumeSliderTimer?.cancel();
    }
    resetControlsTimer();
  }

  void _resetVolumeSliderTimer() {
    _volumeSliderTimer?.cancel();
    _volumeSliderTimer = Timer(_volumeSliderTimeout, () {
      showVolumeSlider.value = false;
    });
  }

  void setPlaybackSpeed(double speed) {
    if (!isInitialized.value || !playbackSpeeds.contains(speed)) return;
    currentSpeed.value = speed;
    playerController.setPlaybackSpeed(speed);
    update();
    resetControlsTimer();
  }

  void toggleLooping() {
    if (!isInitialized.value) return;
    isLooping.value = !isLooping.value;
    playerController.setLooping(isLooping.value);
    update();
    resetControlsTimer();
  }

  void forwardSeconds(int seconds) {
    if (!isInitialized.value) return;
    final newPosition = position.value + Duration(seconds: seconds);
    seekTo(newPosition > duration.value ? duration.value : newPosition);
  }

  void backwardSeconds(int seconds) {
    if (!isInitialized.value) return;
    final newPosition = position.value - Duration(seconds: seconds);
    seekTo(newPosition < Duration.zero ? Duration.zero : newPosition);
  }

  void toggleFullScreen(BuildContext context) {
    isFullScreen.value = !isFullScreen.value;
    if (isFullScreen.value) {
      _enterFullScreen(context);
    } else {
      _exitFullScreen();
    }
    update();
    resetControlsTimer();
  }

  void _enterFullScreen(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    _overlayEntry = OverlayEntry(
      builder: (context) => FullscreenPlayerOverlay(controller: this),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _exitFullScreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void toggleControlsVisibility() {
    showControls.value = !showControls.value;
    if (showControls.value && playerController.value.isPlaying) {
      resetControlsTimer();
    } else {
      _controlsTimer?.cancel();
    }
  }

  void resetControlsTimer() {
    _controlsTimer?.cancel();
    if (playerController.value.isPlaying && showControls.value) {
      _controlsTimer = Timer(_controlsTimeout, () {
        if (playerController.value.isPlaying) {
          showControls.value = false;
        }
      });
    }
  }

  void disposePlayer() {
    _controlsTimer?.cancel();
    _volumeIndicatorTimer?.cancel();
    _volumeSliderTimer?.cancel();
    playerController.removeListener(_playerListener);
    playerController.dispose();
    isInitialized.value = false;
  }

  @override
  void onClose() {
    disposePlayer();
    super.onClose();
  }
}
