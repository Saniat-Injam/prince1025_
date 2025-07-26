class Lesson {
  final String id;
  final String title;
  final String duration;
  final bool isCompleted;
  final bool isLocked;
  final String videoUrl;
  final String? description; 

  Lesson({
    required this.id,
    required this.title,
    required this.duration,
    required this.isCompleted,
    required this.isLocked,
    required this.videoUrl,
    this.description,
  });

  Lesson copyWith({
    String? id,
    String? title,
    String? duration,
    bool? isCompleted,
    bool? isLocked,
    String? videoUrl,
    String? description,
  }) {
    return Lesson(
      id: id ?? this.id,
      title: title ?? this.title,
      duration: duration ?? this.duration,
      isCompleted: isCompleted ?? this.isCompleted,
      isLocked: isLocked ?? this.isLocked,
      videoUrl: videoUrl ?? this.videoUrl,
      description:
          description ?? this.description,
    );
  }

  // Get lesson number from title or ID
  String get lessonNumber {
    final regex = RegExp(r'(\d+)');
    final match = regex.firstMatch(title);
    return match?.group(1) ?? id.replaceAll('lesson_', '');
  }
}

class CourseModule {
  final String id;
  final String title;
  final List<Lesson> lessons;

  CourseModule({required this.id, required this.title, required this.lessons});

  // Get module number from title
  String get moduleNumber {
    final regex = RegExp(r'Module (\d+)');
    final match = regex.firstMatch(title);
    return match?.group(1) ?? '1';
  }

  // Get module title without "Module X:" prefix
  String get moduleTitle {
    return title.replaceFirst(RegExp(r'Module \d+:\s*'), '');
  }

  // Check if all lessons in module are completed
  bool get isCompleted {
    return lessons.every((lesson) => lesson.isCompleted);
  }

  // Get progress percentage for this module
  double get progress {
    if (lessons.isEmpty) return 0.0;
    final completedLessons =
        lessons.where((lesson) => lesson.isCompleted).length;
    return completedLessons / lessons.length;
  }

  // Get number of completed lessons
  int get completedLessonCount {
    return lessons.where((lesson) => lesson.isCompleted).length;
  }
}
