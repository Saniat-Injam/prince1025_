import 'subscription_models.dart';

/// User model for authentication responses
/// Contains user information returned from API
class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String? photo;
  final String? resetToken;
  final String? resetTokenExpiry;
  final bool isSubscribed;
  final String role;
  final List<dynamic> progresses;
  final List<dynamic> favoriteContents;
  final List<dynamic> notifications;
  final List<dynamic> savedQuotes;
  final String createdAt;
  final String updatedAt;
  final List<UserSubscription> subscriptions;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.photo,
    this.resetToken,
    this.resetTokenExpiry,
    required this.isSubscribed,
    required this.role,
    this.progresses = const [],
    this.favoriteContents = const [],
    this.notifications = const [],
    this.savedQuotes = const [],
    required this.createdAt,
    required this.updatedAt,
    this.subscriptions = const [],
  });

  /// Create UserModel from JSON response
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      photo: json['photo'],
      resetToken: json['resetToken'],
      resetTokenExpiry: json['resetTokenExpiry'],
      isSubscribed: json['isSubscribed'] ?? false,
      role: json['role'] ?? 'USER',
      progresses: json['progresses'] ?? [],
      favoriteContents: json['FavoriteContents'] ?? [],
      notifications: json['notifications'] ?? [],
      savedQuotes: json['SavedQuotes'] ?? [],
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      subscriptions:
          (json['subscriptions'] as List<dynamic>?)
              ?.map((subscription) => UserSubscription.fromJson(subscription))
              .toList() ??
          [],
    );
  }

  /// Convert UserModel to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'photo': photo,
      'resetToken': resetToken,
      'resetTokenExpiry': resetTokenExpiry,
      'isSubscribed': isSubscribed,
      'role': role,
      'progresses': progresses,
      'FavoriteContents': favoriteContents,
      'notifications': notifications,
      'SavedQuotes': savedQuotes,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'subscriptions':
          subscriptions.map((subscription) => subscription.toJson()).toList(),
    };
  }

  /// Copy with method for updating user data
  UserModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phoneNumber,
    String? photo,
    String? resetToken,
    String? resetTokenExpiry,
    bool? isSubscribed,
    String? role,
    List<dynamic>? progresses,
    List<dynamic>? favoriteContents,
    List<dynamic>? notifications,
    List<dynamic>? savedQuotes,
    String? createdAt,
    String? updatedAt,
    List<UserSubscription>? subscriptions,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photo: photo ?? this.photo,
      resetToken: resetToken ?? this.resetToken,
      resetTokenExpiry: resetTokenExpiry ?? this.resetTokenExpiry,
      isSubscribed: isSubscribed ?? this.isSubscribed,
      role: role ?? this.role,
      progresses: progresses ?? this.progresses,
      favoriteContents: favoriteContents ?? this.favoriteContents,
      notifications: notifications ?? this.notifications,
      savedQuotes: savedQuotes ?? this.savedQuotes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      subscriptions: subscriptions ?? this.subscriptions,
    );
  }

  /// Get current active subscription
  UserSubscription? get currentSubscription {
    for (final subscription in subscriptions) {
      if (subscription.isActive) {
        return subscription;
      }
    }
    return subscriptions.isNotEmpty ? subscriptions.first : null;
  }

  /// Check if user has any active subscription
  bool get hasActiveSubscription {
    return subscriptions.any((subscription) => subscription.isActive);
  }
}
