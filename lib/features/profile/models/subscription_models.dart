/// Subscription Plan model
/// Represents a subscription plan with pricing and features
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

  /// Create SubscriptionPlan from JSON response
  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      features:
          (json['features'] as List<dynamic>? ?? [])
              .map((feature) => feature.toString())
              .toList(),
      planType: json['planType'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  /// Convert SubscriptionPlan to JSON
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

  /// Check if this is a monthly plan
  bool get isMonthly => planType.toUpperCase() == 'MONTHLY';

  /// Check if this is a yearly plan
  bool get isYearly => planType.toUpperCase() == 'YEARLY';

  /// Check if plan is active
  bool get isActive => status.toUpperCase() == 'ACTIVE';

  /// Get formatted price string
  String get formattedPrice => '\$${price.toStringAsFixed(2)}';

  /// Get period suffix for display
  String get periodSuffix {
    if (isMonthly) return '/month';
    if (isYearly) return '/year';
    return '';
  }

  /// Get plan identifier for comparison
  String get planIdentifier {
    if (isMonthly) return 'monthly';
    if (isYearly) return 'yearly';
    return planType.toLowerCase();
  }

  /// Check if this plan has a savings description
  bool get hasSavings => description.isNotEmpty;

  @override
  String toString() {
    return 'SubscriptionPlan{id: $id, name: $name, planType: $planType, price: $price}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SubscriptionPlan && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
