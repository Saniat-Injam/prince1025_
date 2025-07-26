class VideoContent {
  final String id;
  final String title;
  final String category;
  final String duration;
  final String thumbnailUrl;
  final String videoUrl;
  final int views;
  final String publishedDate;
  final String? description;
  final bool isFeatured;
  final bool isFavorite;
  final int totalFavorites;
  final bool isPremium;

  VideoContent({
    required this.id,
    required this.title,
    required this.category,
    required this.duration,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.views,
    required this.publishedDate,
    this.description,
    this.isFeatured = false,
    this.isFavorite = false,
    this.isPremium = false,
    this.totalFavorites = 0,
  });

  VideoContent copyWith({
    String? id,
    String? title,
    String? category,
    String? duration,
    String? thumbnailUrl,
    String? videoUrl,
    int? views,
    String? publishedDate,
    String? description,
    bool? isFeatured,
    bool? isFavorite,
    bool? isPremium,
    int? totalFavorites,
  }) {
    return VideoContent(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      duration: duration ?? this.duration,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      views: views ?? this.views,
      publishedDate: publishedDate ?? this.publishedDate,
      description: description ?? this.description,
      isFeatured: isFeatured ?? this.isFeatured,
      isFavorite: isFavorite ?? this.isFavorite,
      isPremium: isPremium ?? this.isPremium,
      totalFavorites: totalFavorites ?? this.totalFavorites,
    );
  }

  // Format views count
  String get formattedViews {
    if (views >= 1000000) {
      return '${(views / 1000000).toStringAsFixed(1)}M';
    } else if (views >= 1000) {
      return '${(views / 1000).toStringAsFixed(1)}K';
    }
    return views.toString();
  }
}
