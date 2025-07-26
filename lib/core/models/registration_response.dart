/// Registration response model
/// Contains response data from registration API
class RegistrationResponse {
  final String status;
  final String message;
  final String userId;

  const RegistrationResponse({
    required this.status,
    required this.message,
    required this.userId,
  });

  /// Create RegistrationResponse from JSON
  factory RegistrationResponse.fromJson(Map<String, dynamic> json) {
    return RegistrationResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      userId: json['userId'] ?? '',
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {'status': status, 'message': message, 'userId': userId};
  }
}
