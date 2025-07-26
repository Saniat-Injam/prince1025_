import 'package:get/get.dart';
import 'package:prince1025/core/common/widgets/custom_video_player/custom_video_player_controller.dart';
import 'package:prince1025/features/videos/controllers/videos_controller.dart';
import 'package:prince1025/features/videos/models/video_content_model.dart';

class VideoDetailController extends GetxController {
  final Rx<VideoContent> currentVideo;
  late CustomVideoPlayerController customVideoPlayerController;
  final VideosController _videosController = Get.find<VideosController>();

  // Observable variables
  final RxBool showSubscriptionWarning = false.obs;
  final RxBool isPreviewPlaying = false.obs;
  final Duration previewDuration = const Duration(seconds: 10);

  VideoDetailController({required VideoContent video})
    : currentVideo = video.obs;

  bool get isPremiumRestricted =>
      currentVideo.value.isPremium && !_videosController.isUserSubscribed.value;

  List<VideoContent> get relatedVideos =>
      _videosController.allVideos
          .where((v) => v.id != currentVideo.value.id)
          .toList();

  List<VideoContent> get allVideos => _videosController.allVideos;

  VideoContent? get nextVideo {
    final currentIndex = allVideos.indexWhere(
      (v) => v.id == currentVideo.value.id,
    );
    if (currentIndex >= 0 && currentIndex < allVideos.length - 1) {
      return allVideos[currentIndex + 1];
    }
    return null;
  }

  VideoContent? get previousVideo {
    final currentIndex = allVideos.indexWhere(
      (v) => v.id == currentVideo.value.id,
    );
    if (currentIndex > 0) {
      return allVideos[currentIndex - 1];
    }
    return null;
  }

  @override
  void onInit() {
    super.onInit();
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() {
    customVideoPlayerController = Get.put(
      CustomVideoPlayerController(
        videoPlayerControllerTag: 'video_detail_${currentVideo.value.id}',
      ),
      tag: 'video_detail_${currentVideo.value.id}',
    );

    if (isPremiumRestricted) {
      isPreviewPlaying.value = true;
      customVideoPlayerController.videoPlayerController?.addListener(
        _checkPreviewEnd,
      );
    }
  }

  void _checkPreviewEnd() {
    if (!isPremiumRestricted || !isPreviewPlaying.value) return;

    final position =
        customVideoPlayerController.videoPlayerController?.value.position;
    if (position != null && position >= previewDuration) {
      customVideoPlayerController.pause();
      showSubscriptionWarning.value = true;
      isPreviewPlaying.value = false;
      customVideoPlayerController.videoPlayerController?.removeListener(
        _checkPreviewEnd,
      );
    }
  }

  void playRelatedVideo(VideoContent relatedVideo) {
    // Update current video instead of navigating
    changeVideo(relatedVideo);
  }

  void changeVideo(VideoContent newVideo) {
    // Dispose current player
    customVideoPlayerController.videoPlayerController?.removeListener(
      _checkPreviewEnd,
    );

    // Remove the existing controller from GetX
    final oldTag = 'video_detail_${currentVideo.value.id}';
    if (Get.isRegistered<CustomVideoPlayerController>(tag: oldTag)) {
      Get.delete<CustomVideoPlayerController>(tag: oldTag);
    }

    // Update current video
    currentVideo.value = newVideo;

    // Reinitialize player with new video
    _initializeVideoPlayer();

    // Reset states
    showSubscriptionWarning.value = false;
    isPreviewPlaying.value = isPremiumRestricted;
  }

  void playNextVideo() {
    final next = nextVideo;
    if (next != null) {
      changeVideo(next);
    }
  }

  void playPreviousVideo() {
    final previous = previousVideo;
    if (previous != null) {
      changeVideo(previous);
    }
  }

  void toggleVideoFavorite(String videoId) {
    _videosController.toggleVideoFavorite(videoId);
  }

  bool isVideoFavorite(String videoId) {
    return _videosController.isVideoFavorite(videoId);
  }

  void shareVideo() {
    _videosController.shareVideo(currentVideo.value);
  }

  void downloadVideo() {
    // Implement download functionality
  }

  void saveVideo() {
    // Implement save functionality
  }

  @override
  void onClose() {
    customVideoPlayerController.videoPlayerController?.removeListener(
      _checkPreviewEnd,
    );
    super.onClose();
  }
}
