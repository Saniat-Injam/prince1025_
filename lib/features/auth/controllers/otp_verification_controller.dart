import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:prince1025/core/models/api_response.dart';
import 'package:prince1025/core/models/otp_verification_response.dart';
import 'package:prince1025/core/services/auth_api_service.dart';
import 'package:prince1025/core/services/storage_service.dart';
import 'package:prince1025/core/utils/constants/api_constants.dart';
import 'package:prince1025/features/bottom_nav/views/bottom_nav_screen.dart';

/// OTP verification controller for handling OTP related operations
/// Manages OTP input, countdown timer, and verification
class OtpVerificationController extends GetxController {
  final Logger _logger = Logger();
  final Dio _dio = AuthApiService.getDio();

  // OTP input controllers for 4 digit code
  final List<TextEditingController> otpControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );

  // Focus nodes for OTP fields
  final List<FocusNode> focusNodes = List.generate(4, (_) => FocusNode());

  // Observable variables
  final isLoading = false.obs;
  final isResendLoading = false.obs;
  final canResend = false.obs;
  final countdown = 60.obs;

  // Timer for countdown
  Timer? _countdownTimer;

  // User data
  late String userId;
  late String email;
  final otpMethod = 'email'.obs; // Only email supported as requested

  @override
  void onInit() {
    super.onInit();
    // Start countdown immediately when screen loads
    startCountdown();
  }

  /// Initialize with user data
  void initializeData(String userIdParam, String emailParam) {
    userId = userIdParam;
    email = emailParam;
    _logger.i('📱 OTP screen initialized for user: $userId');

    // Send OTP automatically when screen loads
    sendOtp();
  }

  /// Start countdown timer for resend OTP
  void startCountdown() {
    canResend.value = false;
    countdown.value = 60;

    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown.value > 0) {
        countdown.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  /// Handle OTP input field changes
  void onOtpChanged(int index, String value) {
    if (value.isNotEmpty) {
      // Move to next field if not last field
      if (index < 3) {
        FocusScope.of(Get.context!).requestFocus(focusNodes[index + 1]);
      } else {
        // Last field, unfocus
        FocusScope.of(Get.context!).unfocus();
      }
    } else if (value.isEmpty && index > 0) {
      // Move to previous field if current field is empty
      FocusScope.of(Get.context!).requestFocus(focusNodes[index - 1]);
    }
  }

  /// Get complete OTP code
  String get otpCode {
    return otpControllers.map((controller) => controller.text).join();
  }

  /// Check if OTP is complete
  bool get isOtpComplete {
    return otpCode.length == 4 && otpCode.isNotEmpty;
  }

  /// Send OTP to user
  Future<void> sendOtp() async {
    try {
      _logger.i('📤 Sending OTP to user: $userId');

      final response = await _dio.post(
        ApiConstants.sendOtp,
        data: {'userId': userId, 'method': otpMethod.value},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final apiResponse = ApiResponse.fromJson(response.data);
        _logger.i('✅ ${apiResponse.message}');
        EasyLoading.showSuccess(apiResponse.message);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Send OTP failed with status: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      _logger.e('❌ Send OTP failed: ${e.message}');
      EasyLoading.showError(AuthApiService.handleApiError(e));
    } catch (e) {
      _logger.e('❌ Unexpected error sending OTP: $e');
      EasyLoading.showError('Failed to send OTP. Please try again.');
    }
  }

  /// Resend OTP to user
  Future<void> resendOtp() async {
    if (!canResend.value) {
      EasyLoading.showInfo('Please wait ${countdown.value}s before resending');
      return;
    }

    try {
      isResendLoading.value = true;
      _logger.i('📤 Resending OTP to user: $userId');

      final response = await _dio.post(
        ApiConstants.resendOtp,
        data: {'userId': userId, 'method': otpMethod.value},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final apiResponse = ApiResponse.fromJson(response.data);
        _logger.i('✅ ${apiResponse.message}');
        EasyLoading.showSuccess(apiResponse.message);

        // Start countdown again
        startCountdown();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Resend OTP failed with status: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      _logger.e('❌ Resend OTP failed: ${e.message}');
      EasyLoading.showError(AuthApiService.handleApiError(e));
    } catch (e) {
      _logger.e('❌ Unexpected error resending OTP: $e');
      EasyLoading.showError('Failed to resend OTP. Please try again.');
    } finally {
      isResendLoading.value = false;
    }
  }

  /// Verify OTP code
  Future<void> verifyOtp() async {
    if (!isOtpComplete) {
      EasyLoading.showError('Please enter complete OTP code');
      return;
    }

    try {
      isLoading.value = true;
      EasyLoading.show(status: 'Verifying OTP...');

      _logger.i('📤 Verifying OTP for user: $userId');

      final response = await _dio.post(
        ApiConstants.verifyOtp,
        data: {'userId': userId, 'otp': otpCode},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _logger.i('✅ OTP verified successfully');

        final verificationResponse = OtpVerificationResponse.fromJson(
          response.data,
        );

        // Save user data and token to storage
        await StorageService.saveAuthData(
          verificationResponse.accessToken,
          verificationResponse.user,
        );

        EasyLoading.dismiss();
        EasyLoading.showSuccess('Account verified successfully!');

        // Navigate to main app
        _logger.i('🎉 User logged in, navigating to main app');
        Get.offAll(() => const BottomNavScreen());
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message:
              'OTP verification failed with status: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      _logger.e('❌ OTP verification failed: ${e.message}');
      EasyLoading.dismiss();
      EasyLoading.showError(AuthApiService.handleApiError(e));
    } catch (e) {
      _logger.e('❌ Unexpected error verifying OTP: $e');
      EasyLoading.dismiss();
      EasyLoading.showError('Failed to verify OTP. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  /// Clear OTP fields
  void clearOtp() {
    for (final controller in otpControllers) {
      controller.clear();
    }
    if (focusNodes.isNotEmpty) {
      FocusScope.of(Get.context!).requestFocus(focusNodes[0]);
    }
  }

  @override
  void onClose() {
    // Cancel timer
    _countdownTimer?.cancel();

    // Dispose controllers and focus nodes
    for (final controller in otpControllers) {
      controller.dispose();
    }
    for (final node in focusNodes) {
      node.dispose();
    }
    super.onClose();
  }
}
