import 'package:get/get.dart';
import 'package:prince1025/core/utils/constants/videos_path.dart';
import 'package:share_plus/share_plus.dart'; // Import share_plus
import '../models/course_model.dart';
import '../models/lesson_model.dart';
import '../views/fullscreen_video_player_screen.dart';

class CourseDetailsController extends GetxController {
  final Course course;

  CourseDetailsController(this.course);

  // Current selected lesson
  final Rx<Lesson?> currentLesson = Rx<Lesson?>(null);

  // For expanding lesson description
  final RxBool isDescriptionExpanded = false.obs;

  // To manage the unique key for the video player instance
  final RxInt videoPlayerKey = 0.obs;

  // Set of completed lesson IDs
  final RxSet<String> completedLessonIds = <String>{}.obs;

  // Set of favorited lesson IDs
  final RxSet<String> favoritedLessonIds = <String>{}.obs;

  // Get all lessons in order for navigation
  List<Lesson> get allLessons {
    return modules.expand((module) => module.lessons).toList();
  }

  // Get current lesson index
  int get currentLessonIndex {
    if (currentLesson.value == null) return -1;
    return allLessons.indexWhere(
      (lesson) => lesson.id == currentLesson.value!.id,
    );
  }

  // Check if can navigate to previous/next lesson
  bool get canGoPrevious => currentLessonIndex > 0;
  bool get canGoNext => currentLessonIndex < allLessons.length - 1;

  // Modules getter will now generate lessons with completion status based on completedLessonIds
  List<CourseModule> get modules => _generateModules();

  @override
  void onInit() {
    super.onInit();
    _initializeCourse();
    // Example: Initialize with some lessons already completed (e.g., from persistence)
    // completedLessonIds.addAll(['lesson1_id_from_module1', 'lesson2_id_from_module1']);
  }



  void _initializeCourse() {
    // Potentially load completed and favorited lessons from a persistent source here
    _generateModules().forEach((module) {
      for (var lesson in module.lessons) {
        if (lesson.isCompleted) {
          completedLessonIds.add(lesson.id);
        }
        // Assuming Lesson model might have an 'isFavorite' field for initial state
        // For now, we'll manage favorites purely through the RxSet
      }
    });
  }

  void selectLesson(Lesson lesson) {
    if (!lesson.isLocked) {
      if (currentLesson.value?.id != lesson.id) {
        currentLesson.value = lesson;
        isDescriptionExpanded.value = false; // Reset description expansion
        videoPlayerKey
            .value++; // Change the key to force re-creation of the CustomVideoPlayer widget
      } else if (currentLesson.value?.id == lesson.id) {
        // If the same lesson is tapped again, perhaps toggle play/pause or bring player to view
        // For now, no specific action if same lesson is re-selected,
        // as player controls are within the player itself.
      }
    }
  }

  // Navigate to previous lesson
  void goToPreviousLesson() {
    if (canGoPrevious) {
      final previousLesson = allLessons[currentLessonIndex - 1];
      selectLesson(previousLesson);
    }
  }

  // Navigate to next lesson
  void goToNextLesson() {
    if (canGoNext) {
      final nextLesson = allLessons[currentLessonIndex + 1];
      selectLesson(nextLesson);
    }
  }

  // Navigate to fullscreen video player
  void openFullscreenPlayer() {
    if (currentLesson.value != null) {
      // Get available lessons (unlocked ones)
      final availableLessons =
          allLessons.where((lesson) => !lesson.isLocked).toList();
      final currentIndex = availableLessons.indexWhere(
        (lesson) => lesson.id == currentLesson.value!.id,
      );

      if (currentIndex != -1) {
        Get.to(
          () => FullscreenVideoPlayerScreen(
            lessons: availableLessons,
            currentLessonIndex: currentIndex,
            onLessonCompleted: markLessonAsCompleted,
          ),
        )?.then((result) {
          // Update current lesson when returning from fullscreen
          if (result != null &&
              result is int &&
              result < availableLessons.length) {
            selectLesson(availableLessons[result]);
          }
        });
      }
    }
  }

  void toggleDescriptionExpansion() {
    isDescriptionExpanded.value = !isDescriptionExpanded.value;
  }

  List<CourseModule> _generateModules() {
    // Helper to check completion status
    bool isLessonCompleted(String id) => completedLessonIds.contains(id);

    return [
      CourseModule(
        id: 'module1',
        title: 'Module 1: Foundations',
        lessons: [
          Lesson(
            id: 'lesson1', // Assuming 'lesson1' is the unique ID
            title: 'Lesson 1: Introduction to Manifestation',
            duration: '15 min',
            description:
                'Start your journey by understanding the core principles of manifestation. This lesson covers the basics and sets the stage for deeper learning.',
            isCompleted: isLessonCompleted('lesson1'), // Use helper
            isLocked: false,
            videoUrl: VideosPath.lesseon1,
          ),
          Lesson(
            id: 'lesson2',
            title: 'Lesson 2: Energy Alignment',
            duration: '20 min',
            description:
                'Learn how to align your energy with your desires. This lesson explores techniques for raising your vibration and attracting positive outcomes.',
            isCompleted: isLessonCompleted('lesson2'),
            isLocked: false,
            videoUrl: VideosPath.lesseon2,
          ),
          Lesson(
            id: 'lesson3',
            title: 'Lesson 3: Visualization Techniques',
            duration: '18 min',
            description:
                'Master the art of visualization. This lesson provides practical exercises to help you create vivid mental images of your goals.',
            isCompleted: isLessonCompleted('lesson3'),
            isLocked: false,
            videoUrl: VideosPath.lesseon3,
          ),
          Lesson(
            id: 'lesson4',
            title: 'Lesson 4: Daily Affirmations',
            duration: '15 min',
            description:
                'Start your day with clarity and purpose. This guided meditation helps you set positive intentions and prepare your mind for a productive day ahead. Perfect for beginners and experienced meditators alike.',
            isCompleted: isLessonCompleted('lesson4'),
            isLocked: false,
            videoUrl: VideosPath.lesseon4,
          ),
        ],
      ),
      CourseModule(
        id: 'module2',
        title: 'Module 2: Advanced Techniques',
        lessons: [
          Lesson(
            id: 'lesson5',
            title: 'Lesson 5: Manifestation Journaling',
            duration: '25 min',
            description:
                'Explore the power of journaling in the manifestation process. Learn different journaling techniques to clarify your desires and track your progress.',
            isCompleted: isLessonCompleted('lesson5'),
            isLocked: true,
            videoUrl: VideosPath.lesseon1,
          ),
          Lesson(
            id: 'lesson6',
            title: 'Lesson 6: Abundance Meditation',
            duration: '30 min',
            description:
                'A guided meditation focused on cultivating an abundance mindset. Overcome scarcity beliefs and open yourself to receiving.',
            isCompleted: isLessonCompleted('lesson6'),
            isLocked: true,
            videoUrl: VideosPath.lesseon1,
          ),
          Lesson(
            id: 'lesson7',
            title: 'Lesson 7: Removing Blocks',
            duration: '28 min',
            description:
                'Identify and release common manifestation blocks. This lesson provides tools to overcome limiting beliefs and emotional barriers.',
            isCompleted: isLessonCompleted('lesson7'),
            isLocked: true,
            videoUrl: VideosPath.lesseon1,
          ),
          Lesson(
            id: 'lesson8',
            title: 'Lesson 8: Advanced Affirmations',
            duration: '15 min',
            description:
                'Take your affirmation practice to the next level. Learn how to craft powerful and effective affirmations for specific goals.',
            isCompleted: isLessonCompleted('lesson8'),
            isLocked: true,
            videoUrl: VideosPath.lesseon1,
          ),
        ],
      ),
      CourseModule(
        id: 'module3',
        title: 'Module 3: Mastery',
        lessons: [
          Lesson(
            id: 'lesson9',
            title: 'Lesson 9: Gratitude Practice',
            duration: '15 min',
            description:
                'Deepen your understanding and practice of gratitude. Learn how gratitude accelerates manifestation and enhances well-being.',
            isCompleted: isLessonCompleted('lesson9'),
            isLocked: true,
            videoUrl: VideosPath.lesseon1,
          ),
          Lesson(
            id: 'lesson10',
            title: 'Lesson 10: Living in Abundance',
            duration: '32 min',
            description:
                'Integrate manifestation principles into your daily life. This lesson focuses on maintaining a high vibration and living in a state of abundance.',
            isCompleted: isLessonCompleted('lesson10'),
            isLocked: true,
            videoUrl: VideosPath.lesseon1,
          ),
        ],
      ),
    ];
  }

  void markLessonAsCompleted(String? lessonId) {
    if (lessonId == null) return;
    bool alreadyCompleted = completedLessonIds.contains(lessonId);
    if (!alreadyCompleted) {
      completedLessonIds.add(lessonId);
      if (currentLesson.value?.id == lessonId) {
        currentLesson.value = currentLesson.value?.copyWith(isCompleted: true);
      }
      update(); // Trigger UI refresh for listeners (e.g., progress bars)
    }
  }

  // Method to toggle favorite status
  void toggleFavorite(String? lessonId) {
    if (lessonId == null) return;
    if (favoritedLessonIds.contains(lessonId)) {
      favoritedLessonIds.remove(lessonId);
      // Optionally, update currentLesson if it's the one being unfavorited
      if (currentLesson.value?.id == lessonId) {
        // currentLesson.value = currentLesson.value?.copyWith(isFavorite: false); // Assuming Lesson has isFavorite
      }
    } else {
      favoritedLessonIds.add(lessonId);
      // Optionally, update currentLesson if it's the one being favorited
      if (currentLesson.value?.id == lessonId) {
        // currentLesson.value = currentLesson.value?.copyWith(isFavorite: true); // Assuming Lesson has isFavorite
      }
    }
    update(); // To refresh UI elements that depend on favorite status
  }

  // Method to check if a lesson is favorited
  bool isLessonFavorited(String? lessonId) {
    if (lessonId == null) return false;
    return favoritedLessonIds.contains(lessonId);
  }

  // Method to share lesson
  void shareLesson(Lesson? lesson) {
    if (lesson == null) return;
    final String lessonUrl =
        "https://example.com/lesson/${lesson.id}"; // Replace with actual lesson URL
    final String shareText =
        "Check out this lesson: ${lesson.title}\\n${lesson.description ?? ''}\\nWatch it here: $lessonUrl";
    SharePlus.instance.share(ShareParams(text: shareText));
  }

  // Getters for progress text and overall progress
  String get progressText {
    final allLessons = modules.expand((module) => module.lessons).toList();
    final completedLessons =
        allLessons.where((lesson) => lesson.isCompleted).length;
    return "$completedLessons of ${allLessons.length} lessons completed";
  }

  double get overallProgress {
    final allLessons = modules.expand((module) => module.lessons).toList();
    if (allLessons.isEmpty) return 0.0;
    final completedLessons =
        allLessons.where((lesson) => lesson.isCompleted).length;
    return completedLessons / allLessons.length;
  }

  // Remove _updateCourseProgress as its functionality is covered by markLessonAsCompleted and reactive getters
  // void _updateCourseProgress() {
  //   final allLessons = modules.expand((module) => module.lessons).toList();
  //   int completedCount = allLessons.where((lesson) => lesson.isCompleted).length;
  //   print("Completed lessons: $completedCount / ${allLessons.length}");
  //   update();
  // }
}

// Ensure VideosPath is defined, e.g., in your constants file.
// For example, in lib/core/utils/constants/videos_path.dart

