import 'package:get/get.dart';
import 'package:prince1025/features/notifications/models/notification_model.dart';

class NotificationController extends GetxController {
  // Observable lists for notifications
  final RxList<NotificationModel> _notifications = <NotificationModel>[].obs;
  final RxList<NotificationModel> _unreadNotifications =
      <NotificationModel>[].obs;
  final RxList<NotificationModel> _readNotifications =
      <NotificationModel>[].obs;

  // Current filter state
  final RxString selectedFilter = 'All'.obs;
  final List<String> filterOptions = ['All', 'Unread', 'Read'];

  // Loading state
  final RxBool isLoading = false.obs;

  // Getters
  List<NotificationModel> get notifications => _notifications;
  List<NotificationModel> get unreadNotifications => _unreadNotifications;
  List<NotificationModel> get readNotifications => _readNotifications;
  int get unreadCount => _unreadNotifications.length;

  @override
  void onInit() {
    super.onInit();
    _initializeMockNotifications();
    _filterNotifications();
  }

  // Initialize with mock notifications based on the UI design
  void _initializeMockNotifications() {
    _notifications.value = [
      // Unread notifications (from the UI design)
      NotificationModel(
        id: '1',
        title: 'New Course Available!',
        message: 'Check out our latest manifestation course.',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        type: NotificationType.newCourse,
        isRead: false,
      ),
      NotificationModel(
        id: '2',
        title: '50% Off Flash Sale!',
        message: 'Limited time offer on all premium courses',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
        type: NotificationType.flashSale,
        isRead: false,
      ),

      // Read notifications
      NotificationModel(
        id: '3',
        title: 'Daily Manifestation Reminder',
        message: 'Your daily affirmation is ready to view',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        type: NotificationType.dailyReminder,
        isRead: true,
      ),
      NotificationModel(
        id: '4',
        title: 'Upcoming Live Session',
        message: 'Join our meditation session at 9 AM.',
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
        type: NotificationType.liveSession,
        isRead: true,
      ),
      NotificationModel(
        id: '5',
        title: 'Weekly Progress Update',
        message: 'You\'ve completed 3 courses this week!',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        type: NotificationType.progressUpdate,
        isRead: true,
      ),
    ];

    _filterNotifications();
  }

  // Filter notifications based on read status
  void _filterNotifications() {
    _unreadNotifications.value =
        _notifications.where((n) => !n.isRead).toList();
    _readNotifications.value = _notifications.where((n) => n.isRead).toList();
  }

  // Get filtered notifications based on selected filter
  List<NotificationModel> getFilteredNotifications() {
    switch (selectedFilter.value) {
      case 'Unread':
        return _unreadNotifications;
      case 'Read':
        return _readNotifications;
      default:
        return _notifications;
    }
  }

  // Change filter
  void changeFilter(String filter) {
    selectedFilter.value = filter;
  }

  // Mark notification as read
  void markAsRead(String notificationId) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1 && !_notifications[index].isRead) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      _filterNotifications();
    }
  }

  // Mark all notifications as read
  void markAllAsRead() {
    for (int i = 0; i < _notifications.length; i++) {
      if (!_notifications[i].isRead) {
        _notifications[i] = _notifications[i].copyWith(isRead: true);
      }
    }
    _filterNotifications();
  }

  // Delete notification
  void deleteNotification(String notificationId) {
    _notifications.removeWhere((n) => n.id == notificationId);
    _filterNotifications();
  }

  // Clear all notifications
  void clearAllNotifications() {
    _notifications.clear();
    _filterNotifications();
  }

  // Refresh notifications (simulate API call)
  Future<void> refreshNotifications() async {
    isLoading.value = true;

    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));

    // In a real app, you would fetch from API here
    _initializeMockNotifications();

    isLoading.value = false;
  }

  // Add new notification (for testing or real-time updates)
  void addNotification(NotificationModel notification) {
    _notifications.insert(0, notification);
    _filterNotifications();
  }

  // Get time ago string
  String getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}
