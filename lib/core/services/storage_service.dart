import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prince1025/core/models/user_model.dart';

class StorageService {
  // Constants for preference keys
  static const String _tokenKey = 'token';
  static const String _idKey = 'userId';
  static const String _userKey = 'user_data';
  static const String _rememberEmailKey = 'remember_email';
  static const String _rememberPasswordKey = 'remember_password';

  // Singleton instance for SharedPreferences
  static SharedPreferences? _preferences;

  // Initialize SharedPreferences (call this during app startup)
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // Check if a token exists in local storage
  static bool hasToken() {
    final token = _preferences?.getString(_tokenKey);
    return token != null && token.isNotEmpty;
  }

  // Save the token and user ID to local storage
  static Future<void> saveToken(String token, String id) async {
    await _preferences?.setString(_tokenKey, token);
    await _preferences?.setString(_idKey, id);
  }

  // Save complete user data to local storage
  static Future<void> saveUserData(UserModel user) async {
    final userJson = jsonEncode(user.toJson());
    await _preferences?.setString(_userKey, userJson);
    await _preferences?.setString(_idKey, user.id);
  }

  // Save both token and user data
  static Future<void> saveAuthData(String token, UserModel user) async {
    await saveToken(token, user.id);
    await saveUserData(user);
  }

  // Get user data from local storage
  static UserModel? getUserData() {
    final userJson = _preferences?.getString(_userKey);
    if (userJson != null && userJson.isNotEmpty) {
      try {
        final userMap = jsonDecode(userJson) as Map<String, dynamic>;
        return UserModel.fromJson(userMap);
      } catch (e) {
        // If parsing fails, return null
        return null;
      }
    }
    return null;
  }

  // Update user data in local storage
  static Future<void> updateUserData(UserModel user) async {
    await saveUserData(user);
  }

  // Remove the token and user ID from local storage (for logout)
  static Future<void> logoutUser() async {
    await _preferences?.remove(_tokenKey);
    await _preferences?.remove(_idKey);
    await _preferences?.remove(_userKey);
  }

  // Clear all stored data
  static Future<void> clearAll() async {
    await _preferences?.clear();
  }

  // Getter for user ID
  static String? get userId => _preferences?.getString(_idKey);

  // Getter for token
  static String? get token => _preferences?.getString(_tokenKey);

  // Check if user is logged in
  static bool get isLoggedIn => hasToken() && getUserData() != null;

  // Save login credentials for remember me functionality
  static Future<void> saveLoginCredentials(
    String email,
    String password,
  ) async {
    await _preferences?.setString(_rememberEmailKey, email);
    await _preferences?.setString(_rememberPasswordKey, password);
  }

  // Get saved login credentials
  static Map<String, String?> getSavedCredentials() {
    return {
      'email': _preferences?.getString(_rememberEmailKey),
      'password': _preferences?.getString(_rememberPasswordKey),
    };
  }

  // Clear saved login credentials
  static Future<void> clearLoginCredentials() async {
    await _preferences?.remove(_rememberEmailKey);
    await _preferences?.remove(_rememberPasswordKey);
  }

  // Check if login credentials are saved
  static bool get hasRememberedCredentials {
    final email = _preferences?.getString(_rememberEmailKey);
    final password = _preferences?.getString(_rememberPasswordKey);
    return email != null &&
        email.isNotEmpty &&
        password != null &&
        password.isNotEmpty;
  }
}
