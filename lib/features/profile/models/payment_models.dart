/// Payment Request model
/// Represents the request payload for creating a checkout session
class PaymentRequest {
  final String planId;
  final String userId;

  const PaymentRequest({required this.planId, required this.userId});

  /// Convert PaymentRequest to JSON for API call
  Map<String, dynamic> toJson() {
    return {'planId': planId, 'userId': userId};
  }

  @override
  String toString() {
    return 'PaymentRequest{planId: $planId, userId: $userId}';
  }
}

/// Payment Response model
/// Represents the response from payment creation API
class PaymentResponse {
  final String url;

  const PaymentResponse({required this.url});

  /// Create PaymentResponse from JSON response
  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    return PaymentResponse(url: json['url'] ?? '');
  }

  /// Convert PaymentResponse to JSON
  Map<String, dynamic> toJson() {
    return {'url': url};
  }

  /// Check if the response has a valid checkout URL
  bool get hasValidUrl => url.isNotEmpty && Uri.tryParse(url) != null;

  @override
  String toString() {
    return 'PaymentResponse{url: $url}';
  }
}

/// Payment Status enum
/// Represents different states of payment process
enum PaymentStatus { pending, processing, completed, failed, cancelled }

/// Payment Result model
/// Used to track payment completion status
class PaymentResult {
  final PaymentStatus status;
  final String? message;
  final String? transactionId;
  final DateTime timestamp;

  const PaymentResult({
    required this.status,
    this.message,
    this.transactionId,
    required this.timestamp,
  });

  /// Create PaymentResult for success
  factory PaymentResult.success({String? transactionId, String? message}) {
    return PaymentResult(
      status: PaymentStatus.completed,
      message: message ?? 'Payment completed successfully',
      transactionId: transactionId,
      timestamp: DateTime.now(),
    );
  }

  /// Create PaymentResult for failure
  factory PaymentResult.failure({String? message}) {
    return PaymentResult(
      status: PaymentStatus.failed,
      message: message ?? 'Payment failed',
      timestamp: DateTime.now(),
    );
  }

  /// Create PaymentResult for cancellation
  factory PaymentResult.cancelled({String? message}) {
    return PaymentResult(
      status: PaymentStatus.cancelled,
      message: message ?? 'Payment cancelled by user',
      timestamp: DateTime.now(),
    );
  }

  /// Check if payment was successful
  bool get isSuccess => status == PaymentStatus.completed;

  /// Check if payment failed
  bool get isFailed => status == PaymentStatus.failed;

  /// Check if payment was cancelled
  bool get isCancelled => status == PaymentStatus.cancelled;

  @override
  String toString() {
    return 'PaymentResult{status: $status, message: $message, transactionId: $transactionId}';
  }
}
