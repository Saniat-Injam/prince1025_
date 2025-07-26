/// Reset forgot password response model
/// Contains response data when password is successfully reset
class ResetForgotPasswordResponse {
  final String message;

  const ResetForgotPasswordResponse({required this.message});

  /// Create ResetForgotPasswordResponse from JSON
  factory ResetForgotPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ResetForgotPasswordResponse(message: json['message'] ?? '');
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {'message': message};
  }
}
