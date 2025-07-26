/// Subscription Plan model
class SubscriptionPlan {
  final String id;
  final String name;
  final String description;
  final double price;
  final List<String> features;
  final String planType;
  final String status;
  final String createdAt;
  final String updatedAt;

  const SubscriptionPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.features,
    required this.planType,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create SubscriptionPlan from JSON
  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      features: List<String>.from(json['features'] ?? []),
      planType: json['planType'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'features': features,
      'planType': planType,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  /// Get formatted price with currency
  String get formattedPrice => '\$${price.toStringAsFixed(2)}';

  /// Get plan type display name
  String get planTypeDisplay {
    switch (planType.toUpperCase()) {
      case 'MONTHLY':
        return 'Monthly';
      case 'YEARLY':
        return 'Yearly';
      default:
        return planType;
    }
  }

  /// Check if plan is active
  bool get isActive => status.toUpperCase() == 'ACTIVE';
}

/// User Subscription model
class UserSubscription {
  final String id;
  final String userId;
  final String planId;
  final String startDate;
  final String endDate;
  final String createdAt;
  final String updatedAt;
  final SubscriptionPlan? plan;

  const UserSubscription({
    required this.id,
    required this.userId,
    required this.planId,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    required this.updatedAt,
    this.plan,
  });

  /// Create UserSubscription from JSON
  factory UserSubscription.fromJson(Map<String, dynamic> json) {
    return UserSubscription(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      planId: json['planId'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      plan:
          json['plan'] != null ? SubscriptionPlan.fromJson(json['plan']) : null,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'planId': planId,
      'startDate': startDate,
      'endDate': endDate,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'plan': plan?.toJson(),
    };
  }

  /// Check if subscription is currently active
  bool get isActive {
    try {
      final endDateTime = DateTime.parse(endDate);
      return DateTime.now().isBefore(endDateTime);
    } catch (e) {
      return false;
    }
  }

  /// Get days remaining in subscription
  int get daysRemaining {
    try {
      final endDateTime = DateTime.parse(endDate);
      final now = DateTime.now();
      if (now.isBefore(endDateTime)) {
        return endDateTime.difference(now).inDays;
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }

  /// Get formatted start date
  String get formattedStartDate {
    try {
      final date = DateTime.parse(startDate);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return startDate;
    }
  }

  /// Get formatted end date
  String get formattedEndDate {
    try {
      final date = DateTime.parse(endDate);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return endDate;
    }
  }
}
