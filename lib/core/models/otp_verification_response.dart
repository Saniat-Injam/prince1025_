import 'package:prince1025/core/models/user_model.dart';

/// OTP verification response model
/// Contains response data from OTP verification API
class OtpVerificationResponse {
  final String status;
  final String message;
  final UserModel user;
  final String accessToken;

  const OtpVerificationResponse({
    required this.status,
    required this.message,
    required this.user,
    required this.accessToken,
  });

  /// Create OtpVerificationResponse from JSON
  factory OtpVerificationResponse.fromJson(Map<String, dynamic> json) {
    return OtpVerificationResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      user: UserModel.fromJson(json['user'] ?? {}),
      accessToken: json['accessToken'] ?? '',
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'user': user.toJson(),
      'accessToken': accessToken,
    };
  }
}
