import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayerController extends GetxController {
  final String videoPlayerControllerTag;
  VideoPlayerController? _videoPlayerController;

  CustomVideoPlayerController({required this.videoPlayerControllerTag});

  VideoPlayerController? get videoPlayerController => _videoPlayerController;

  // Method to initialize the actual VideoPlayerController
  // This would typically be called from CustomVideoPlayerWidget
  void initializePlayer(VideoPlayerController controller) {
    _videoPlayerController = controller;
    update(); // Notify listeners
  }

  void play() {
    _videoPlayerController?.play();
    update();
  }

  void pause() {
    _videoPlayerController?.pause();
    update();
  }

  void seekTo(Duration position) {
    _videoPlayerController?.seekTo(position);
    update();
  }

  bool get isPlaying => _videoPlayerController?.value.isPlaying ?? false;

  Duration get position =>
      _videoPlayerController?.value.position ?? Duration.zero;

  Duration get duration =>
      _videoPlayerController?.value.duration ?? Duration.zero;

  @override
  void onClose() {
    // Dispose the video player controller when this controller is closed
    // _videoPlayerController?.dispose(); // This might be handled by the widget itself
    super.onClose();
  }
}
