import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:prince1025/core/models/registration_response.dart';
import 'package:prince1025/core/services/api_caller.dart';
import 'package:prince1025/core/utils/constants/api_constants.dart';
import 'package:prince1025/features/auth/controllers/auth_controller.dart';
import 'package:prince1025/routes/app_routes.dart';

/// Registration controller for handling user registration
/// Manages form validation, image picking, and API calls
class RegistrationController extends GetxController {
  final Logger _logger = Logger();

  // Form key for validation
  final formKey = GlobalKey<FormState>();

  // Text editing controllers
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Observable variables
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final agreedToTerms = false.obs;
  final isLoading = false.obs;

  // Registration response data
  final registrationResponse = Rxn<RegistrationResponse>();

  /// Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  /// Toggle confirm password visibility
  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  /// Toggle terms agreement
  void toggleTermsAgreement(bool? value) {
    agreedToTerms.value = value ?? false;
  }

  /// Validate full name field
  String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your full name';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    if (value.length > 50) {
      return 'Name must be less than 50 characters';
    }
    // Check if name contains only letters and spaces
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Name can only contain letters and spaces';
    }
    return null;
  }

  /// Validate email field
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// Validate password field
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
      return 'Password must contain uppercase, lowercase and number';
    }
    return null;
  }

  /// Validate confirm password field
  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  /// Submit registration form
  Future<void> register() async {
    // Validate form
    if (!formKey.currentState!.validate()) {
      EasyLoading.showError('Please fill out all fields correctly');
      return;
    }

    // Check terms agreement
    if (!agreedToTerms.value) {
      EasyLoading.showError('You must agree to the terms and conditions');
      return;
    }

    isLoading.value = true;
    _logger.i('📤 Starting registration process');

    await ApiCaller.post<RegistrationResponse>(
      endpoint: ApiConstants.register,
      data: {
        'fullName': fullNameController.text.trim(),
        'email': emailController.text.trim(),
        'phoneNumber': phoneController.text.trim(),
        'password': passwordController.text,
      },
      loadingMessage: 'Creating account...',
      onSuccess: (data) {
        final registrationData = RegistrationResponse.fromJson(data);
        registrationResponse.value = registrationData;

        _logger.i(
          '✅ Registration successful, navigating to OTP method selection',
        );

        // Get the AuthController and set user ID for OTP flow
        final authController = Get.find<AuthController>();
        authController.setUserId(registrationData.userId);

        // Copy registration data to AuthController for display in OTP screen
        authController.emailController.text = emailController.text.trim();
        authController.phoneController.text = phoneController.text.trim();

        // Navigate to OTP sending screen for method selection
        Get.toNamed(AppRoute.otpSendingScreen);

        return registrationData;
      },
      onError: (error) {
        _logger.e('❌ Registration failed: $error');
        EasyLoading.showError(error);
        // Error is automatically shown by ApiCaller
      },
    );

    isLoading.value = false;
  }

  /// Clear all form data
  void clearForm() {
    fullNameController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    agreedToTerms.value = false;
    isPasswordVisible.value = false;
    isConfirmPasswordVisible.value = false;
    registrationResponse.value = null;
  }

  @override
  void onClose() {
    // Dispose controllers
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
