import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:prince1025/core/services/api_caller.dart';
import 'package:prince1025/core/utils/constants/api_constants.dart';
import 'package:prince1025/features/profile/models/contact_support_response.dart';
import 'package:prince1025/features/profile/views/send_success_screen.dart';

class ContactSupportController extends GetxController {
  final Logger _logger = Logger();

  // Text editing controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final messageController = TextEditingController();

  // Form key
  final formKey = GlobalKey<FormState>();

  // Loading state
  final RxBool isLoading = false.obs;

  /// Submit contact support form
  /// Calls the contact support API with user's information
  void submitForm() {
    if (formKey.currentState!.validate()) {
      _submitContactSupport();
    }
  }

  //!================== Submit contact support to API====================
  Future<void> _submitContactSupport() async {
    try {
      isLoading.value = true;

      // Create request model
      final request = ContactSupportRequest(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        opinion: messageController.text.trim(),
      );

      _logger.i('Submitting contact support: ${request.toJson()}');

      // Call API
      final response = await ApiCaller.post<ContactSupportResponse>(
        endpoint: ApiConstants.contactSupport,
        data: request.toJson(),
        loadingMessage: 'Sending message...',
        onSuccess: (data) {
          if (data != null && data is Map<String, dynamic>) {
            return ContactSupportResponse.fromJson(data);
          }
          return null;
        },
        onError: (error) {
          _logger.e('Contact support error: $error');
          EasyLoading.showError('Failed to send message. Please try again.');
        },
      );

      if (response != null && response.id.isNotEmpty) {
        _logger.i(
          'Contact support success: Message sent with ID ${response.id}',
        );

        // Navigate to success screen
        Get.to(() => const SendSuccessScreen());

        // Clear form
        clearForm();

        // Show success message
        EasyLoading.showSuccess(
          'Message sent successfully! We\'ll get back to you soon.',
        );
      } else {
        // Handle unsuccessful response
        _logger.w('Contact support unsuccessful: No valid response received');
        EasyLoading.showError('Failed to send message. Please try again.');
      }
    } catch (e) {
      _logger.e('Contact support exception: $e');
      EasyLoading.showError('An unexpected error occurred. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  /// Clear form data
  void clearForm() {
    nameController.clear();
    emailController.clear();
    messageController.clear();
  }

  // Validate email
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  // Validate name
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  /// Validate opinion/message field
  String? validateOpinion(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your opinion';
    }
    if (value.length < 10) {
      return 'Opinion must be at least 10 characters';
    }
    return null;
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    messageController.dispose();
    super.onClose();
  }
}
