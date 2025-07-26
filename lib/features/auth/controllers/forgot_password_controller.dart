import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:prince1025/core/models/forgot_password_response.dart';
import 'package:prince1025/core/models/reset_forgot_password_response.dart';
import 'package:prince1025/core/models/verify_forgot_password_otp_response.dart';
import 'package:prince1025/core/services/api_caller.dart';
import 'package:prince1025/core/utils/constants/api_constants.dart';
import 'package:prince1025/features/auth/controllers/auth_controller.dart';
import 'package:prince1025/features/auth/screens/verification_code_screen.dart';
import 'package:prince1025/routes/app_routes.dart';

/// Controller for handling forgot password flow
/// Separates forgot password logic from main AuthController
class ForgotPasswordController extends GetxController {
  final Logger _logger = Logger();

  // Controllers for form inputs
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Store user ID for the forgot password flow
  String? _userId;

  // OTP code management
  final otpCode = List.filled(4, '').obs;

  // Countdown timer for OTP resend
  final resendCountdown = 0.obs;
  final canResendOTP = true.obs;
  Timer? _countdownTimer;

  /// Set user ID for forgot password flow
  void setUserId(String userId) {
    _userId = userId;
    _logger.i('🆔 UserId set for forgot password flow: $userId');
  }

  /// Update a single digit of the OTP code
  void updateOTPCode(int index, String value) {
    if (index >= 0 && index < otpCode.length) {
      otpCode[index] = value;
      _logger.d('📱 OTP code updated at index $index: $value');
    }
  }

  /// Start countdown timer for OTP resend
  void startResendCountdown() {
    // Cancel existing timer if running
    _countdownTimer?.cancel();

    canResendOTP.value = false;
    resendCountdown.value = 60; // 60 seconds

    _logger.i('⏰ Starting resend countdown: 60 seconds');

    // Start countdown with proper Timer
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      resendCountdown.value--;

      if (resendCountdown.value <= 0) {
        canResendOTP.value = true;
        timer.cancel();
        _countdownTimer = null;
        _logger.i('✅ Resend countdown completed');
      }
    });
  }

  //!==============================Forgot Password Flow====================

  /// Step 1: Send forgot password OTP to user's email
  /// This is called from ForgotPasswordScreen
  Future<void> sendForgotPasswordOtp() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      EasyLoading.showError("Email cannot be empty");
      return;
    }

    _logger.i('📤 Sending forgot password OTP to: $email');

    await ApiCaller.post<ForgotPasswordResponse>(
      endpoint: ApiConstants.forgotPassword,
      data: {'email': email},
      loadingMessage: 'Sending OTP...',
      onSuccess: (data) {
        _logger.i('✅ Forgot password OTP sent successfully');

        final forgotPasswordResponse = ForgotPasswordResponse.fromJson(data);

        // Store userId for OTP verification
        setUserId(forgotPasswordResponse.userId);

        ApiCaller.showSuccess(forgotPasswordResponse.message);

        // Navigate to verification screen
        Get.to(
          () =>
              VerificationCodeScreen(origin: VerificationOrigin.forgotPassword),
        );

        // Start countdown timer for resend
        startResendCountdown();

        return forgotPasswordResponse;
      },
      onError: (error) {
        _logger.e('❌ Send forgot password OTP failed: $error');
        // Error is automatically shown by ApiCaller
      },
    );
  }

  /// Step 2: Verify forgot password OTP
  /// This is called from VerificationCodeScreen when origin is forgotPassword
  Future<void> verifyForgotPasswordOtp() async {
    if (_userId == null) {
      EasyLoading.showError('User ID not available');
      return;
    }

    final otpString = otpCode.join();
    if (otpString.length != 4) {
      EasyLoading.showError('Please enter complete OTP code');
      return;
    }

    _logger.i('📤 Verifying forgot password OTP for user: $_userId');

    await ApiCaller.post<VerifyForgotPasswordOtpResponse>(
      endpoint: ApiConstants.verifyForgotPasswordOtp,
      data: {'userId': _userId, 'otp': otpString},
      loadingMessage: "Verifying code...",
      onSuccess: (data) {
        _logger.i('✅ Forgot password OTP verified successfully');

        final verifyResponse = VerifyForgotPasswordOtpResponse.fromJson(data);

        // Keep userId for password reset
        setUserId(verifyResponse.userId);

        ApiCaller.showSuccess(verifyResponse.message);

        // Navigate to set new password screen
        Get.toNamed(AppRoute.setPasswordScreen);

        return verifyResponse;
      },
      onError: (error) {
        _logger.e('❌ Forgot password OTP verification failed: $error');
        // Error is automatically shown by ApiCaller
      },
    );
  }

  /// Step 3: Reset password with new password
  /// This is called from SetPasswordScreen
  Future<void> resetForgotPassword() async {
    if (_userId == null) {
      EasyLoading.showError('User ID not available');
      return;
    }

    final newPassword = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      EasyLoading.showError("Please fill both password fields");
      return;
    }

    if (newPassword != confirmPassword) {
      EasyLoading.showError("Passwords do not match");
      return;
    }

    _logger.i('📤 Resetting forgot password for user: $_userId');

    await ApiCaller.post<ResetForgotPasswordResponse>(
      endpoint: ApiConstants.resetForgotPassword,
      data: {'userId': _userId, 'newPassword': newPassword},
      loadingMessage: "Resetting password...",
      onSuccess: (data) {
        _logger.i('✅ Password reset successful');

        final resetResponse = ResetForgotPasswordResponse.fromJson(data);

        ApiCaller.showSuccess(resetResponse.message);

        // Clear form and reset state
        _clearForgotPasswordState();

        // Navigate back to auth screen with login selected
        Future.delayed(const Duration(seconds: 2), () {
          // Use Get.find to access AuthController and set login mode
          try {
            final authController = Get.find<AuthController>();
            authController.isLogin.value = true;
          } catch (e) {
            _logger.w('⚠️ Could not access AuthController: $e');
          }

          Get.offAllNamed(AppRoute.authScreen);
        });

        return resetResponse;
      },
      onError: (error) {
        _logger.e('❌ Password reset failed: $error');
        // Error is automatically shown by ApiCaller
      },
    );
  }

  /// Resend forgot password OTP
  Future<void> resendForgotPasswordOtp() async {
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

    _logger.i('📤 Resending forgot password OTP to user: $_userId');

    await ApiCaller.post(
      endpoint: ApiConstants.forgotPassword,
      data: {'email': emailController.text.trim()},
      loadingMessage: "Resending OTP...",
      onSuccess: (data) {
        _logger.i('✅ Forgot password OTP resent successfully');
        ApiCaller.showSuccess('Verification code resent to your email');

        // Start countdown timer again
        startResendCountdown();

        return null;
      },
      onError: (error) {
        _logger.e('❌ Resend forgot password OTP failed: $error');
        // Error is automatically shown by ApiCaller
      },
    );
  }

  /// Clear forgot password related state
  void _clearForgotPasswordState() {
    _logger.i('🧹 Clearing forgot password state...');

    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    otpCode.fillRange(0, 4, '');
    _userId = null;
    _countdownTimer?.cancel();
    canResendOTP.value = true;
    resendCountdown.value = 0;

    _logger.i('✅ Forgot password state cleared');
  }

  /// Reset only the form without clearing email (useful when user wants to retry)
  void resetForm() {
    _logger.i('🔄 Resetting forgot password form...');

    passwordController.clear();
    confirmPasswordController.clear();
    otpCode.fillRange(0, 4, '');

    _logger.i('✅ Form reset completed');
  }

  //!==============================Forgot Password Flow End================

  @override
  void onClose() {
    _logger.i('🔄 Disposing ForgotPasswordController...');

    // Cancel timer if running
    _countdownTimer?.cancel();

    // Dispose all controllers
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    _logger.i('✅ ForgotPasswordController disposed');
    super.onClose();
  }
}
