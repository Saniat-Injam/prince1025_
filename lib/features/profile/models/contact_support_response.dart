/// Contact support API response model
/// Handles the response from contact support endpoint
class ContactSupportResponse {
  final String id;
  final String name;
  final String email;
  final String opinion;
  final String createdAt;

  ContactSupportResponse({
    required this.id,
    required this.name,
    required this.email,
    required this.opinion,
    required this.createdAt,
  });

  /// Create ContactSupportResponse from JSON
  factory ContactSupportResponse.fromJson(Map<String, dynamic> json) {
    return ContactSupportResponse(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      opinion: json['opinion'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }

  /// Convert ContactSupportResponse to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'opinion': opinion,
      'createdAt': createdAt,
    };
  }
}

/// Contact support request model
/// Handles the request body for contact support API
class ContactSupportRequest {
  final String name;
  final String email;
  final String opinion;

  ContactSupportRequest({
    required this.name,
    required this.email,
    required this.opinion,
  });

  /// Convert ContactSupportRequest to JSON
  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email, 'opinion': opinion};
  }
}
