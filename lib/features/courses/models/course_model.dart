class Course {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final int totalLessons;
  final int currentLesson;
  final double progress; 
  final String category;
  final bool isLocked;
  final bool hasPreview;

  Course({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.totalLessons,
    required this.currentLesson,
    required this.progress,
    required this.category,
    required this.isLocked,
    this.hasPreview = false,
  });

  // Get progress percentage as integer
  int get progressPercentage => (progress * 100).round();

  // Check if course is in progress
  bool get isInProgress => currentLesson > 0 && progress < 1.0;

  // Check if course is completed
  bool get isCompleted => progress >= 1.0;

  // Update course progress
  void updateProgress(double newProgress, int newCurrentLesson) {
    // Note: In a real app, this would update the backend/database
    // For now, we'll just update local values
  }

  // Create a copy with updated values
  Course copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? imageUrl,
    int? totalLessons,
    int? currentLesson,
    double? progress,
    String? category,
    bool? isLocked,
    bool? hasPreview,
  }) {
    return Course(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      imageUrl: imageUrl ?? this.imageUrl,
      totalLessons: totalLessons ?? this.totalLessons,
      currentLesson: currentLesson ?? this.currentLesson,
      progress: progress ?? this.progress,
      category: category ?? this.category,
      isLocked: isLocked ?? this.isLocked,
      hasPreview: hasPreview ?? this.hasPreview,
    );
  }

  // Get remaining lessons
  int get remainingLessons => totalLessons - currentLesson;
}
