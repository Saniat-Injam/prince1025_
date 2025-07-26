import 'package:prince1025/core/services/api_caller.dart';
import 'package:prince1025/core/utils/constants/api_constants.dart';

/// Example utility class showing how to use ApiCaller in controllers
/// This demonstrates the new pattern to replace duplicate Dio code
class ApiCallerExample {
  /// Example GET request - Fetch user profile
  /// This shows how to use ApiCaller for GET requests
  static Future<void> fetchUserProfile() async {
    await ApiCaller.get(
      endpoint: '${ApiConstants.baseUrl}/user/profile',
      loadingMessage: 'Loading profile...',
      onSuccess: (data) {
        // Handle successful response
        print('Profile data: $data');
        ApiCaller.showSuccess('Profile loaded successfully!');
        return null;
      },
      onError: (error) {
        // Custom error handling if needed
        print('Profile loading failed: $error');
        // ApiCaller automatically shows the error message from API response
      },
    );
  }

  /// Example POST request - Update user profile
  /// This shows how to use ApiCaller for POST requests with data
  static Future<void> updateUserProfile({
    required String name,
    required String email,
  }) async {
    await ApiCaller.post(
      endpoint: '${ApiConstants.baseUrl}/user/profile',
      data: {'name': name, 'email': email},
      loadingMessage: 'Updating profile...',
      onSuccess: (data) {
        // Handle successful response
        print('Profile updated: $data');
        ApiCaller.showSuccess('Profile updated successfully!');
        return null;
      },
      onError: (error) {
        // ApiCaller automatically shows API error message
        print('Profile update failed: $error');
      },
    );
  }

  /// Example PUT request - Update specific user data
  /// This shows how to use ApiCaller for PUT requests
  static Future<void> updateUserSettings(Map<String, dynamic> settings) async {
    await ApiCaller.put(
      endpoint: '${ApiConstants.baseUrl}/user/settings',
      data: settings,
      loadingMessage: 'Saving settings...',
      onSuccess: (data) {
        print('Settings updated: $data');
        ApiCaller.showSuccess('Settings saved successfully!');
        return null;
      },
      onError: (error) {
        print('Settings update failed: $error');
      },
    );
  }

  /// Example DELETE request - Delete user account
  /// This shows how to use ApiCaller for DELETE requests
  static Future<void> deleteUserAccount() async {
    await ApiCaller.delete(
      endpoint: '${ApiConstants.baseUrl}/user/account',
      loadingMessage: 'Deleting account...',
      onSuccess: (data) {
        print('Account deleted: $data');
        ApiCaller.showSuccess('Account deleted successfully!');
        return null;
      },
      onError: (error) {
        print('Account deletion failed: $error');
      },
    );
  }

  /// Example with custom error handling
  /// This shows how to handle errors differently if needed
  static Future<bool> customErrorHandling() async {
    bool success = false;

    await ApiCaller.post(
      endpoint: '${ApiConstants.baseUrl}/some/endpoint',
      data: {'key': 'value'},
      showLoading:
          false, // Don't show loading if you want to handle it yourself
      onSuccess: (data) {
        success = true;
        // Handle success without showing default success message
        return null;
      },
      onError: (error) {
        success = false;
        // Custom error handling - don't show default error message
        if (error.contains('validation')) {
          ApiCaller.showError('Please check your input data');
        } else if (error.contains('network')) {
          ApiCaller.showError('Please check your internet connection');
        } else {
          ApiCaller.showError('Something went wrong. Please try again.');
        }
      },
    );

    return success;
  }

  /// Example with typed response
  /// This shows how to use ApiCaller with specific response types
  static Future<UserProfile?> fetchTypedUserProfile() async {
    UserProfile? profile;

    await ApiCaller.get<Map<String, dynamic>>(
      endpoint: '${ApiConstants.baseUrl}/user/profile',
      onSuccess: (data) {
        // Parse the response data into a specific type
        if (data != null) {
          profile = UserProfile.fromJson(data);
          ApiCaller.showSuccess('Profile loaded!');
        }
        return data;
      },
    );

    return profile;
  }
}

/// Example model class
class UserProfile {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatarUrl: json['avatarUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email, 'avatarUrl': avatarUrl};
  }
}

/// Benefits of using ApiCaller:
/// 
/// 1. REDUCED DUPLICATE CODE:
///    - No need to repeat try-catch blocks
///    - No need to manually handle Dio exceptions
///    - No need to manually show/dismiss loading indicators
///    - No need to manually extract error messages
/// 
/// 2. CONSISTENT ERROR HANDLING:
///    - Automatically extracts API error messages from response
///    - Falls back to meaningful error messages based on status codes
///    - Shows proper connection error messages
///    - Prioritizes API response errors over Dio exception messages
/// 
/// 3. SIMPLIFIED CONTROLLER CODE:
///    - Controllers focus on business logic, not network boilerplate
///    - Clean, readable API calls
///    - Consistent loading and error state management
/// 
/// 4. EASY CUSTOMIZATION:
///    - Optional custom error handlers
///    - Optional custom loading messages
///    - Can disable automatic loading/error displays
///    - Supports typed responses
/// 
/// 5. BETTER USER EXPERIENCE:
///    - Shows actual API error messages instead of technical Dio errors
///    - Consistent loading states across the app
///    - Proper error message hierarchy (API → Status Code → Connection)
/// 
/// USAGE IN CONTROLLERS:
/// 
/// Instead of:
/// ```dart
/// try {
///   EasyLoading.show(status: 'Loading...');
///   final response = await _dio.post('/api/endpoint', data: requestData);
///   if (response.statusCode == 200) {
///     EasyLoading.showSuccess('Success!');
///     // handle success
///   } else {
///     throw Exception('Failed');
///   }
/// } on DioException catch (e) {
///   EasyLoading.showError(AuthApiService.handleApiError(e));
/// } catch (e) {
///   EasyLoading.showError('Something went wrong');
/// }
/// ```
/// 
/// Simply use:
/// ```dart
/// await ApiCaller.post(
///   endpoint: '/api/endpoint',
///   data: requestData,
///   loadingMessage: 'Loading...',
///   onSuccess: (data) {
///     // handle success
///     return null;
///   },
/// );
/// ```
