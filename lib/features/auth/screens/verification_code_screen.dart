import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prince1025/core/common/widgets/custom_gradient_elevated_button.dart';
import 'package:prince1025/core/utils/constants/colors.dart';
import 'package:prince1025/core/utils/constants/image_path.dart';
import 'package:prince1025/features/auth/controllers/auth_controller.dart';
import 'package:prince1025/features/auth/controllers/forgot_password_controller.dart';

enum VerificationOrigin { otpSending, forgotPassword }

class VerificationCodeScreen extends StatelessWidget {
  final VerificationOrigin origin;
  final AuthController authController = Get.find<AuthController>();

  VerificationCodeScreen({super.key, required this.origin});

  /// Mask email for display (e.g., test@example.com -> t***@example.com)
  String _maskEmail(String email) {
    if (email.isEmpty) return email;

    final parts = email.split('@');
    if (parts.length != 2) return email;

    final username = parts[0];
    final domain = parts[1];

    if (username.length <= 2) return email;

    final maskedUsername =
        username[0] +
        '*' * (username.length - 2) +
        username[username.length - 1];
    return '$maskedUsername@$domain';
  }

  void _handleVerification(BuildContext context) {
    // Call different verification methods based on the origin
    if (origin == VerificationOrigin.forgotPassword) {
      // For forgot password flow, use ForgotPasswordController
      final forgotPasswordController = Get.find<ForgotPasswordController>();
      forgotPasswordController.verifyForgotPasswordOtp();
    } else {
      // For registration/login OTP verification flow, use AuthController
      authController.verifyOTPCode();
    }
  }

  void _handleResendOTP() {
    if (origin == VerificationOrigin.forgotPassword) {
      // For forgot password flow, use ForgotPasswordController
      final forgotPasswordController = Get.find<ForgotPasswordController>();
      forgotPasswordController.resendForgotPasswordOtp();
    } else {
      // For registration/login OTP verification flow, use AuthController
      authController.resendOTPCode();
    }
  }

  Widget _buildOTPInputField(int index) {
    // Determine which controller to use based on origin
    final focusNodes = authController.focusNodes;

    return SizedBox(
      width: 50,
      height: 50,
      child: Builder(
        builder:
            (context) => TextField(
              focusNode: focusNodes[index],
              onChanged: (value) {
                // Update OTP code based on origin
                if (origin == VerificationOrigin.forgotPassword) {
                  final forgotPasswordController =
                      Get.find<ForgotPasswordController>();
                  forgotPasswordController.updateOTPCode(index, value);
                } else {
                  authController.updateOTPCode(index, value);
                }

                // Handle focus navigation
                if (value.isNotEmpty) {
                  if (index < focusNodes.length - 1) {
                    FocusScope.of(context).requestFocus(focusNodes[index + 1]);
                  } else {
                    FocusScope.of(context).unfocus();
                  }
                } else if (value.isEmpty && index > 0) {
                  FocusScope.of(context).requestFocus(focusNodes[index - 1]);
                }
              },
              textAlign: TextAlign.center,
              maxLength: 1,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                counterText: '',
                border: OutlineInputBorder(),
              ),
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final String backgroundImage =
        isDark
            ? ImagePath.darkOtpSendingScreenbackground
            : ImagePath.lightOtpSendingScreenbackground;

    // Start countdown when screen loads (only if not already counting)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (origin == VerificationOrigin.forgotPassword) {
        final forgotPasswordController = Get.find<ForgotPasswordController>();
        if (forgotPasswordController.resendCountdown.value == 0 &&
            forgotPasswordController.canResendOTP.value) {
          forgotPasswordController.startResendCountdown();
        }
      } else {
        if (authController.resendCountdown.value == 0 &&
            authController.canResendOTP.value) {
          authController.startResendCountdown();
        }
      }
    });

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.15),
                Image.asset(ImagePath.authLogo),
                SizedBox(height: screenHeight * 0.06),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color:
                        isDark
                            ? Colors.transparent
                            : Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.primaryWhite.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Verification Code',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      SizedBox(height: 8),
                      Text('Enter the 4-Digit Code Sent to Your Email'),
                      SizedBox(height: 24),
                      Text(
                        authController.emailController.text.isNotEmpty
                            ? _maskEmail(authController.emailController.text)
                            : 'Email not available',
                        style: TextStyle(
                          color: isDark ? Color(0xFFF5F5F5) : Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                          4,
                          (index) => _buildOTPInputField(index),
                        ),
                      ),
                      SizedBox(height: 24),

                      // Verify Button
                      isDark
                          ? CustomGradientButton(
                            onPressed: () => _handleVerification(context),
                            gradient: AppColors.primaryGradient,
                            child: const Text("Verify"),
                          )
                          : SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => _handleVerification(context),
                              child: const Text("Verify"),
                            ),
                          ),
                      const SizedBox(height: 24),

                      SizedBox(height: 8),
                      Text(
                        "Haven't received the code?",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      SizedBox(height: 4),

                      Obx(() {
                        // Get the appropriate controller based on origin
                        final canResend =
                            origin == VerificationOrigin.forgotPassword
                                ? Get.find<ForgotPasswordController>()
                                    .canResendOTP
                                    .value
                                : authController.canResendOTP.value;

                        final countdown =
                            origin == VerificationOrigin.forgotPassword
                                ? Get.find<ForgotPasswordController>()
                                    .resendCountdown
                                    .value
                                : authController.resendCountdown.value;

                        return canResend
                            ? GestureDetector(
                              onTap: () => _handleResendOTP(),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Resend OTP',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.displaySmall?.copyWith(
                                    color:
                                        isDark
                                            ? AppColors.primaryWhite
                                            : Colors.white,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            )
                            : Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Resend OTP in ${countdown}s',
                                style: Theme.of(
                                  context,
                                ).textTheme.displaySmall?.copyWith(
                                  color:
                                      isDark
                                          ? AppColors.primaryWhite
                                          : Colors.white,
                                ),
                              ),
                            );
                      }),
                      SizedBox(height: 12),
                      Obx(() {
                        final canResend =
                            origin == VerificationOrigin.forgotPassword
                                ? Get.find<ForgotPasswordController>()
                                    .canResendOTP
                                    .value
                                : authController.canResendOTP.value;

                        return Text(
                          canResend
                              ? "You can now request a new code"
                              : "Please wait before requesting a new code",
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(
                            color: isDark ? Colors.white54 : Colors.white,
                          ),
                        );
                      }),
                      SizedBox(height: 24),
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.arrow_back,
                              color:
                                  isDark
                                      ? AppColors.secondaryWhite
                                      : AppColors.primaryWhite,
                            ),
                            SizedBox(width: 8),
                            Text(
                              origin == VerificationOrigin.otpSending
                                  ? 'Back to registration'
                                  : 'Back to login',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
