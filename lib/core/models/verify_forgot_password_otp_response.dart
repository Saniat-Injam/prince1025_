/// Verify forgot password OTP response model
/// Contains response data when forgot password OTP is verified
class VerifyForgotPasswordOtpResponse {
  final String message;
  final String userId;

  const VerifyForgotPasswordOtpResponse({
    required this.message,
    required this.userId,
  });

  /// Create VerifyForgotPasswordOtpResponse from JSON
  factory VerifyForgotPasswordOtpResponse.fromJson(Map<String, dynamic> json) {
    return VerifyForgotPasswordOtpResponse(
      message: json['message'] ?? '',
      userId: json['userId'] ?? '',
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {'message': message, 'userId': userId};
  }
}
