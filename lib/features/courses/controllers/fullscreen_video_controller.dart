import 'dart:async';
import 'package:get/get.dart';
import '../models/lesson_model.dart';

class FullscreenVideoController extends GetxController {
  final List<Lesson> lessons;
  final int initialLessonIndex;
  final Function(String) onLessonCompleted;

  FullscreenVideoController({
    required this.lessons,
    required int currentLessonIndex,
    required this.onLessonCompleted,
  }) : initialLessonIndex = currentLessonIndex;

  // Current lesson index
  late final RxInt currentLessonIndex;

  // Video player key for forcing rebuilds
  final RxInt videoPlayerKey = 0.obs;

  // Control visibility
  final RxBool showCustomControls = true.obs;

  // Timer for auto-hiding controls
  Timer? _controlsTimer;
  static const _controlsTimeout = Duration(seconds: 4);

  @override
  void onInit() {
    super.onInit();
    currentLessonIndex = initialLessonIndex.obs;
    _startControlsTimer();
  }

  @override
  void onClose() {
    _controlsTimer?.cancel();
    super.onClose();
  }

  // Current lesson getter
  Lesson get currentLesson => lessons[currentLessonIndex.value];

  // Navigation checks
  bool get canGoPrevious => currentLessonIndex.value > 0;
  bool get canGoNext => currentLessonIndex.value < lessons.length - 1;

  // Navigation methods
  void goToPreviousLesson() {
    if (canGoPrevious) {
      currentLessonIndex.value--;
      _changeVideo();
      _showControlsTemporarily();
    }
  }

  void goToNextLesson() {
    if (canGoNext) {
      currentLessonIndex.value++;
      _changeVideo();
      _showControlsTemporarily();
    }
  }

  // Video change handler
  void _changeVideo() {
    videoPlayerKey.value++; // Force video player rebuild
  }

  // Video end handler
  void onVideoEnd() {
    // Mark current lesson as completed
    onLessonCompleted(currentLesson.id);

    // Auto-advance to next lesson if available
    if (canGoNext) {
      // Show controls briefly before auto-advancing
      _showControlsTemporarily();

      // Auto-advance after a short delay
      Timer(const Duration(seconds: 2), () {
        if (canGoNext) {
          goToNextLesson();
        }
      });
    } else {
      // Show controls when video ends and no next lesson
      showCustomControls.value = true;
      _controlsTimer?.cancel();
    }
  }

  // Controls visibility management
  void toggleControlsVisibility() {
    showCustomControls.value = !showCustomControls.value;
    if (showCustomControls.value) {
      _startControlsTimer();
    } else {
      _controlsTimer?.cancel();
    }
  }

  void _showControlsTemporarily() {
    showCustomControls.value = true;
    _startControlsTimer();
  }

  void _startControlsTimer() {
    _controlsTimer?.cancel();
    _controlsTimer = Timer(_controlsTimeout, () {
      showCustomControls.value = false;
    });
  }

  // Touch handler for showing controls
  void onScreenTap() {
    if (showCustomControls.value) {
      showCustomControls.value = false;
      _controlsTimer?.cancel();
    } else {
      _showControlsTemporarily();
    }
  }
}
