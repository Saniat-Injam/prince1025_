/// Pending login response model
/// Contains response data when user account is not verified yet
class PendingLoginResponse {
  final String status;
  final String message;
  final String userId;

  const PendingLoginResponse({
    required this.status,
    required this.message,
    required this.userId,
  });

  /// Create PendingLoginResponse from JSON
  factory PendingLoginResponse.fromJson(Map<String, dynamic> json) {
    return PendingLoginResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      userId: json['userId'] ?? '',
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {'status': status, 'message': message, 'userId': userId};
  }

  /// Check if the status is pending
  bool get isPending => status.toLowerCase() == 'pending';
}
