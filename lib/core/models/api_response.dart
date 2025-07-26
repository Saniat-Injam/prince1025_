/// General API response model
/// Contains response data for simple API calls like sendOtp, resendOtp
class ApiResponse {
  final String message;
  final bool success;

  const ApiResponse({required this.message, required this.success});

  /// Create ApiResponse from JSON
  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      message: json['message'] ?? '',
      success: json['success'] ?? true,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {'message': message, 'success': success};
  }
}
