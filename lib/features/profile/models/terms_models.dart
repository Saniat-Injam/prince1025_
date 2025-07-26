/// Terms and Conditions Key Point model
/// Represents individual key points within a terms category
class TermsKeyPoint {
  final String id;
  final String point;
  final String categoryId;
  final String createdAt;
  final String updatedAt;

  const TermsKeyPoint({
    required this.id,
    required this.point,
    required this.categoryId,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create TermsKeyPoint from JSON response
  factory TermsKeyPoint.fromJson(Map<String, dynamic> json) {
    return TermsKeyPoint(
      id: json['id'] ?? '',
      point: json['point'] ?? '',
      categoryId: json['categoryId'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  /// Convert TermsKeyPoint to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'point': point,
      'categoryId': categoryId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  @override
  String toString() {
    return 'TermsKeyPoint{id: $id, point: ${point.substring(0, point.length > 50 ? 50 : point.length)}...}';
  }
}

/// Terms and Conditions Category model
/// Represents a category of terms with multiple key points
class TermsCategory {
  final String id;
  final String title;
  final String lastUpdated;
  final String createdAt;
  final String updatedAt;
  final List<TermsKeyPoint> keyPoints;

  const TermsCategory({
    required this.id,
    required this.title,
    required this.lastUpdated,
    required this.createdAt,
    required this.updatedAt,
    required this.keyPoints,
  });

  /// Create TermsCategory from JSON response
  factory TermsCategory.fromJson(Map<String, dynamic> json) {
    return TermsCategory(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      lastUpdated: json['lastUpdated'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      keyPoints:
          (json['keyPoints'] as List<dynamic>? ?? [])
              .map(
                (keyPoint) =>
                    TermsKeyPoint.fromJson(keyPoint as Map<String, dynamic>),
              )
              .toList(),
    );
  }

  /// Convert TermsCategory to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'lastUpdated': lastUpdated,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'keyPoints': keyPoints.map((keyPoint) => keyPoint.toJson()).toList(),
    };
  }

  /// Get formatted last updated date
  String get formattedLastUpdated {
    try {
      final dateTime = DateTime.parse(lastUpdated);
      final day = dateTime.day.toString().padLeft(2, '0');
      final monthNames = [
        '',
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      final month = monthNames[dateTime.month];
      final year = dateTime.year;
      return '$day-$month-$year';
    } catch (e) {
      return 'Unknown';
    }
  }

  /// Get combined content from all key points
  String get combinedContent {
    return keyPoints.map((keyPoint) => keyPoint.point).join('\n\n');
  }

  @override
  String toString() {
    return 'TermsCategory{id: $id, title: $title, keyPoints: ${keyPoints.length}}';
  }
}
