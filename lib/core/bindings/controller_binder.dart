import 'package:get/get.dart';
import 'package:prince1025/core/common/widgets/custom_video_player/video_player_custom_controller.dart';
import 'package:prince1025/features/auth/controllers/auth_controller.dart';
import 'package:prince1025/features/profile/controllers/theme_controller.dart';
import 'package:prince1025/features/videos/controllers/videos_controller.dart';
import 'package:video_player/video_player.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    // Initialize ThemeController to handle theme persistence
    Get.put(AuthController(), permanent: true);
    Get.put<ThemeController>(ThemeController(), permanent: true);
    Get.put(VideoPlayerController);
    Get.put(VideosController());

    Get.lazyPut<VideoPlayerCustomController>(
      () => VideoPlayerCustomController(
        videoPath: '',
        dataSourceType: DataSourceType.network,
      ),
      fenix: true,
    );
  }
}
