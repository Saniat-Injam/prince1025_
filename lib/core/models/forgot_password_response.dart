/// Forgot password response model
/// Contains response data when OTP is sent for password reset
class ForgotPasswordResponse {
  final String message;
  final String userId;

  const ForgotPasswordResponse({required this.message, required this.userId});

  /// Create ForgotPasswordResponse from JSON
  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponse(
      message: json['message'] ?? '',
      userId: json['userId'] ?? '',
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {'message': message, 'userId': userId};
  }
}
