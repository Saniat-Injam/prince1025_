import 'package:prince1025/core/models/user_model.dart';

/// Login response model
/// Contains response data from login API
class LoginResponse {
  final UserModel user;
  final String accessToken;

  const LoginResponse({required this.user, required this.accessToken});

  /// Create LoginResponse from JSON
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      user: UserModel.fromJson(json['user'] ?? {}),
      accessToken: json['accessToken'] ?? '',
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {'user': user.toJson(), 'accessToken': accessToken};
  }
}
