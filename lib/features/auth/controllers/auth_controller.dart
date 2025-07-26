import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:prince1025/core/models/login_response.dart';
import 'package:prince1025/core/models/otp_verification_response.dart';
import 'package:prince1025/core/models/pending_login_response.dart';
import 'package:prince1025/core/services/api_caller.dart';
import 'package:prince1025/core/services/auth_api_service.dart';
import 'package:prince1025/core/services/storage_service.dart';
import 'package:prince1025/core/utils/constants/api_constants.dart';
import 'package:prince1025/features/auth/screens/verification_code_screen.dart';
import 'package:prince1025/features/bottom_nav/views/bottom_nav_screen.dart';
import 'package:prince1025/routes/app_routes.dart';

class AuthController extends GetxController {
  final Logger _logger = Logger();

  final List<FocusNode> focusNodes = List.generate(4, (_) => FocusNode());

  // Store user ID for OTP flow
  String? _userId;

  /// Set user ID for OTP verification flow
  void setUserId(String userId) {
    _userId = userId;
  }

  // Common controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Login-specific
  final rememberMe = false.obs;
  final obscurePassword = true.obs;

  // Register-specific
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final agreedToTerms = false.obs;
  var fullPhoneNumber = ''.obs;

  // Auth mode toggle
  final isLogin = true.obs;

  // OTP and verification
  final selectedOTPMethod = 'email'.obs; // Default to email
  final otpCode = List.filled(4, '').obs;

  // Countdown timer for OTP resend
  final resendCountdown = 0.obs;
  final canResendOTP = true.obs;
  Timer? _countdownTimer;

  // Toggle functions
  void toggleRememberMe(bool? value) => rememberMe.value = value ?? false;
  void togglePasswordVisibility() =>
      obscurePassword.value = !obscurePassword.value;
  void toggleRegisterPasswordVisibility() =>
      isPasswordVisible.value = !isPasswordVisible.value;
  void toggleConfirmPasswordVisibility() =>
      isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  void toggleTermsAgreement(bool? value) =>
      agreedToTerms.value = value ?? false;
  void toggleAuthMode() => isLogin.value = !isLogin.value;

  // OTP method selection
  void setOTPMethod(String method) => selectedOTPMethod.value = method;

  /// Start countdown timer for OTP resend
  void startResendCountdown() {
    // Cancel existing timer if running
    _countdownTimer?.cancel();

    canResendOTP.value = false;
    resendCountdown.value = 60; // 60 seconds

    // Start countdown with proper Timer
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      resendCountdown.value--;

      if (resendCountdown.value <= 0) {
        canResendOTP.value = true;
        timer.cancel();
        _countdownTimer = null;
      }
    });
  }

  //!==============================OTP sending logic==========================
  Future<void> sendOTPCode({String? userId}) async {
    // Use provided userId or stored one
    final userIdToUse = userId ?? _userId;
    if (userIdToUse == null) {
      EasyLoading.showError('User ID not available');
      return;
    }

    _logger.i(
      '📤 Sending OTP to user: $userIdToUse via ${selectedOTPMethod.value}',
    );

    await ApiCaller.post(
      endpoint: ApiConstants.sendOtp,
      data: {'userId': userIdToUse, 'method': selectedOTPMethod.value},
      loadingMessage: "Sending OTP...",
      onSuccess: (data) {
        _logger.i('✅ OTP sent successfully');
        ApiCaller.showSuccess(
          'Verification code sent to your ${selectedOTPMethod.value}',
        );

        // Store userId for future use
        _userId = userIdToUse;

        // Navigate to verification screen and start countdown
        Get.to(
          () => VerificationCodeScreen(origin: VerificationOrigin.otpSending),
        );

        // Start countdown timer for resend
        startResendCountdown();

        return null;
      },
      onError: (error) {
        _logger.e('❌ Send OTP failed: $error');
        // Error is automatically shown by ApiCaller
      },
    );
  }

  //!==============================OTP sending logic end=======================
  void sendResetLink() {
    EasyLoading.show(status: "Sending reset link...");
    Future.delayed(Duration(seconds: 1), () {
      EasyLoading.showSuccess(
        'Verification link sent to your ${selectedOTPMethod.value}',
      );
      //Get.toNamed(AppRoute.verifyCodeScreen);
      Get.to(
        () => VerificationCodeScreen(origin: VerificationOrigin.otpSending),
      );
    });
  }

  // Update a single digit of the code
  void updateOTPCode(int index, String value) {
    if (index >= 0 && index < otpCode.length) {
      otpCode[index] = value;
    }
  }

  //!=============== Verify OTP code and complete registration===============
  Future<void> verifyOTPCode() async {
    if (!otpCode.every((e) => e.isNotEmpty)) {
      EasyLoading.showError("Please enter the complete code");
      return;
    }

    if (_userId == null) {
      EasyLoading.showError('User ID not available');
      return;
    }

    final otpString = otpCode.join('');
    _logger.i('📤 Verifying OTP for user: $_userId');

    await ApiCaller.post(
      endpoint: ApiConstants.verifyOtp,
      data: {'userId': _userId, 'otp': otpString},
      loadingMessage: "Verifying code...",
      onSuccess: (data) {
        _logger.i('✅ OTP verified successfully');

        try {
          _logger.i('📊 Parsing verification response...');
          final verificationResponse = OtpVerificationResponse.fromJson(data);
          _logger.i('✅ Response parsed successfully');

          // Save user data and token using the correct method names
          _logger.i('💾 Saving auth data...');
          StorageService.saveAuthData(
            verificationResponse.accessToken,
            verificationResponse.user,
          );
          _logger.i('✅ Auth data saved successfully');

          ApiCaller.showSuccess("Registration completed successfully!");

          // Clear OTP code and reset countdown
          _logger.i('🧹 Clearing OTP state...');
          otpCode.value = List.filled(4, '');
          resendCountdown.value = 0;
          canResendOTP.value = true;
          _logger.i('✅ OTP state cleared');

          // Navigate to home screen after successful verification
          Future.delayed(Duration(milliseconds: 500)).then((_) {
            _logger.i('🚀 Attempting navigation to home screen...');
            try {
              Get.offAll(() => BottomNavScreen());
              _logger.i('🏠 Successfully navigated to home screen');
            } catch (navError) {
              _logger.e('❌ Navigation error: $navError');
              // Fallback navigation
              Get.offAll(() => BottomNavScreen());
            }
          });
        } catch (parseError) {
          _logger.e('❌ Error parsing verification response: $parseError');
          ApiCaller.showError(
            'Verification successful but navigation failed. Please restart the app.',
          );
        }

        return null;
      },
      onError: (error) {
        _logger.e('❌ OTP verification failed: $error');
        EasyLoading.showError(error.toString());
        // Error is automatically shown by ApiCaller
      },
    );
  }
  //!========================================================================

  //!==============================Resend OTP code==========================
  Future<void> resendOTPCode() async {
    // Check if resend is allowed
    if (!canResendOTP.value) {
      EasyLoading.showError(
        'Please wait ${resendCountdown.value} seconds before requesting a new code',
      );
      return;
    }

    if (_userId == null) {
      EasyLoading.showError('User ID not available');
      return;
    }

    _logger.i(
      '📤 Resending OTP to user: $_userId via ${selectedOTPMethod.value}',
    );

    await ApiCaller.post(
      endpoint: ApiConstants.resendOtp,
      data: {'userId': _userId, 'method': selectedOTPMethod.value},
      loadingMessage: "Resending OTP...",
      onSuccess: (data) {
        _logger.i('✅ OTP resent successfully');
        ApiCaller.showSuccess(
          'Verification code resent to your ${selectedOTPMethod.value}',
        );

        // Start countdown timer again
        startResendCountdown();

        return null;
      },
      onError: (error) {
        _logger.e('❌ Resend OTP failed: $error');
        EasyLoading.showError(error.toString());
        // Error is automatically shown by ApiCaller
      },
    );
  }
  //!========================================================================

  //!==============================Login ====================================
  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      EasyLoading.showError("Email and password cannot be empty");
      return;
    }

    _logger.i('📤 Logging in user: $email');

    try {
      EasyLoading.show(status: 'Logging in...');

      // Get Dio instance for direct API call to handle both success and error responses
      final dio = AuthApiService.getDio();

      final response = await dio.post(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );

      // Handle successful login (200/201 status codes)
      if (response.statusCode == 200 || response.statusCode == 201) {
        _logger.i('✅ Login successful for verified account');

        EasyLoading.dismiss();

        final loginResponse = LoginResponse.fromJson(response.data);

        // Save user data and token based on remember me preference
        if (rememberMe.value) {
          // Save credentials for auto-login
          StorageService.saveAuthData(
            loginResponse.accessToken,
            loginResponse.user,
          );
          StorageService.saveLoginCredentials(email, password);
          _logger.i('💾 User credentials saved for auto-login');
        } else {
          // Save only for current session
          StorageService.saveAuthData(
            loginResponse.accessToken,
            loginResponse.user,
          );
          StorageService.clearLoginCredentials();
          _logger.i('🔐 User logged in for current session only');
        }

        ApiCaller.showSuccess("Login successful!");

        // Navigate to home screen after successful login
        Get.offAll(BottomNavScreen());
      }
    } on DioException catch (e) {
      EasyLoading.dismiss();

      _logger.e(
        '❌ Login request failed with status: ${e.response?.statusCode}',
      );

      // Check if this is a 400 error with pending account data
      if (e.response?.statusCode == 400 && e.response?.data != null) {
        final responseData = e.response!.data;

        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('status') &&
            responseData['status'] == 'pending') {
          _logger.i(
            '⏳ Account not verified yet, redirecting to OTP verification',
          );

          // Parse pending response to get userId
          final pendingResponse = PendingLoginResponse.fromJson(responseData);

          // Store userId for OTP verification
          setUserId(pendingResponse.userId);

          // Store email for display in OTP screen
          emailController.text = email;

          // Show message about account verification
          ApiCaller.showInfo(pendingResponse.message);

          // Navigate to OTP method selection screen (same as registration flow)
          Future.delayed(const Duration(seconds: 1), () {
            Get.toNamed(AppRoute.otpSendingScreen);
          });

          return;
        }
      }

      // Handle other errors
      String errorMessage = 'Login failed. Please try again.';

      // Try to extract error message from response
      if (e.response?.data != null) {
        final responseData = e.response!.data;
        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('message')) {
          errorMessage = responseData['message'].toString();
        }
      }

      _logger.e('❌ Login failed: $errorMessage');
      EasyLoading.showError(errorMessage);
    } catch (e) {
      EasyLoading.dismiss();
      _logger.e('❌ Unexpected error during login: $e');
      EasyLoading.showError('Login failed. Please try again.');
    }
  }
  //!========================================================================

  // Set new password
  void resetPassword() {
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (password.isEmpty || confirmPassword.isEmpty) {
      EasyLoading.showError("Please fill both password fields");
      return;
    }

    if (password == confirmPassword) {
      // Add actual password reset logic
      // EasyLoading.showSuccess("Password has been reset");
      // Get.toNamed('/login');
      EasyLoading.showSuccess("Password has been reset");
      Future.delayed(Duration(seconds: 2), () {
        //Get.offAllNamed('/login');
        isLogin.value = true; // ✅ Ensure login selected
        Get.offAllNamed(AppRoute.authScreen); // ✅ Navigate to login screen
      });
    } else {
      EasyLoading.showError("Passwords do not match");
    }
  }

  void resetForm() {
    // Cancel any running timer
    _countdownTimer?.cancel();

    // Don't clear email/password if they are saved credentials
    if (!StorageService.hasRememberedCredentials) {
      emailController.clear();
      passwordController.clear();
      rememberMe.value = false;
    } else {
      // Keep saved credentials but reset remember me state
      _loadSavedCredentials();
    }

    confirmPasswordController.clear();
    fullNameController.clear();
    phoneController.clear();
    fullPhoneNumber.value = '';
    agreedToTerms.value = false;
    obscurePassword.value = true;
    isPasswordVisible.value = false;
    isConfirmPasswordVisible.value = false;
    isLogin.value = true; // default to login screen
    otpCode.value = List.filled(4, '');
    selectedOTPMethod.value = 'email'; // Reset to default
    resendCountdown.value = 0;
    canResendOTP.value = true;
  }

  //!==============================Logout====================================
  Future<void> logout() async {
    try {
      _logger.i('🚪 Logging out user');

      // Always clear auth data
      await StorageService.logoutUser();

      // Clear saved credentials if user didn't want to be remembered
      if (!rememberMe.value) {
        await StorageService.clearLoginCredentials();
        _logger.i('🗑️ Cleared saved login credentials');
      }

      // Reset form
      resetForm();

      EasyLoading.showSuccess('Logged out successfully');

      // Navigate to splash screen to properly check authentication state
      Get.offAllNamed(AppRoute.splashScreen);
    } catch (e) {
      _logger.e('❌ Logout failed: $e');
      EasyLoading.showError('Logout failed');
    }
  }

  @override
  void onInit() {
    super.onInit();
    _loadSavedCredentials();
  }

  /// Load saved credentials if remember me was enabled
  void _loadSavedCredentials() {
    if (StorageService.hasRememberedCredentials) {
      final credentials = StorageService.getSavedCredentials();
      emailController.text = credentials['email'] ?? '';
      passwordController.text = credentials['password'] ?? '';
      rememberMe.value = true;
      _logger.i('📂 Loaded saved login credentials');
    }
  }

  @override
  void onClose() {
    // Cancel timer if running
    _countdownTimer?.cancel();

    // Dispose all controllers
    for (final node in focusNodes) {
      node.dispose();
    }

    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    fullNameController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
