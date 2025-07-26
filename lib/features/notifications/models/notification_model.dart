import 'package:prince1025/core/utils/constants/svg_path.dart';

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final NotificationType type;
  final bool isRead;
  final String? imageUrl;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    this.isRead = false,
    this.imageUrl,
  });

  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    DateTime? timestamp,
    NotificationType? type,
    bool? isRead,
    String? imageUrl,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}

enum NotificationType {
  newCourse,
  flashSale,
  dailyReminder,
  liveSession,
  progressUpdate,
}

class NotificationTypeHelper {
  static String getDisplayName(NotificationType type) {
    switch (type) {
      case NotificationType.newCourse:
        return 'New Course';
      case NotificationType.flashSale:
        return 'Flash Sale';
      case NotificationType.dailyReminder:
        return 'Daily Reminder';
      case NotificationType.liveSession:
        return 'Live Session';
      case NotificationType.progressUpdate:
        return 'Progress Update';
    }
  }

  static String getIcon(NotificationType type) {
    switch (type) {
      case NotificationType.newCourse:
        return SvgPath.newCoursesSvg;
      case NotificationType.flashSale:
        return SvgPath.flashSaleSvg;
      case NotificationType.dailyReminder:
        return SvgPath.readNotificationSvg;
      case NotificationType.liveSession:
        return SvgPath.readNotificationSvg;
      case NotificationType.progressUpdate:
        return SvgPath.readNotificationSvg;
    }
  }
}
