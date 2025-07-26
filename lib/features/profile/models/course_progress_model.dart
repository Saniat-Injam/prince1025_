class CourseProgress {
  final String title;
  final double progress; // 0.0 to 1.0
  final String lastAccessed;

  CourseProgress({
    required this.title,
    required this.progress,
    required this.lastAccessed,
  });
}