import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prince1025/core/common/styles/global_text_style.dart';
import 'package:prince1025/core/common/widgets/custom_gradient_elevated_button.dart';
import 'package:prince1025/core/utils/constants/colors.dart';
import 'package:prince1025/core/utils/constants/image_path.dart';
import 'package:prince1025/features/auth/controllers/otp_verification_controller.dart';

/// OTP Verification Screen for email verification
/// Shows OTP input fields with countdown timer and resend functionality
class OtpVerificationScreen extends StatelessWidget {
  final String userId;
  final String email;

  const OtpVerificationScreen({
    super.key,
    required this.userId,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OtpVerificationController());
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final double screenHeight = MediaQuery.of(context).size.height;

    // Initialize controller with user data
    controller.initializeData(userId, email);

    final String backgroundImage =
        isDarkTheme
            ? ImagePath.darkOtpSendingScreenbackground
            : ImagePath.lightOtpSendingScreenbackground;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.15),

                // Auth Logo
                Image.asset(ImagePath.authLogo),
                SizedBox(height: screenHeight * 0.06),

                // Main Content Container
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color:
                        isDarkTheme
                            ? Colors.black.withValues(alpha: 0.7)
                            : Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Title
                      Text(
                        'Verification Code',
                        style: getDMTextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isDarkTheme ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Subtitle
                      Text(
                        'We have sent a verification code to',
                        style: getDMTextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: isDarkTheme ? Colors.white70 : Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),

                      // Email display
                      Text(
                        email,
                        style: getDMTextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryDarkBlue,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),

                      // OTP Input Fields
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(4, (index) {
                          return _buildOtpField(controller, index, isDarkTheme);
                        }),
                      ),
                      const SizedBox(height: 32),

                      // Verify Button
                      Obx(
                        () =>
                            controller.isLoading.value
                                ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                                : isDarkTheme
                                ? CustomGradientButton(
                                  onPressed: controller.verifyOtp,
                                  gradient: AppColors.primaryGradient,
                                  child: const Text('Verify'),
                                )
                                : SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: controller.verifyOtp,
                                    child: const Text('Verify'),
                                  ),
                                ),
                      ),
                      const SizedBox(height: 24),

                      // Resend OTP Section
                      _buildResendSection(controller, isDarkTheme),
                    ],
                  ),
                ),

                const Spacer(),

                // Back to Login
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_back,
                        color: isDarkTheme ? Colors.white : Colors.black,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Back to Registration',
                        style: getDMTextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isDarkTheme ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build individual OTP input field
  Widget _buildOtpField(
    OtpVerificationController controller,
    int index,
    bool isDarkTheme,
  ) {
    return SizedBox(
      width: 50,
      height: 60,
      child: TextFormField(
        controller: controller.otpControllers[index],
        focusNode: controller.focusNodes[index],
        onChanged: (value) => controller.onOtpChanged(index, value),
        textAlign: TextAlign.center,
        maxLength: 1,
        keyboardType: TextInputType.number,
        style: getDMTextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: isDarkTheme ? Colors.white : Colors.black,
        ),
        decoration: InputDecoration(
          counterText: '',
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: isDarkTheme ? Colors.white30 : Colors.black26,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: isDarkTheme ? Colors.white30 : Colors.black26,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: AppColors.primaryDarkBlue,
              width: 2,
            ),
          ),
          filled: true,
          fillColor:
              isDarkTheme ? Colors.white.withValues(alpha: 0.1) : Colors.white,
        ),
      ),
    );
  }

  /// Build resend OTP section with countdown timer
  Widget _buildResendSection(
    OtpVerificationController controller,
    bool isDarkTheme,
  ) {
    return Column(
      children: [
        Text(
          "Didn't receive the code?",
          style: getDMTextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: isDarkTheme ? Colors.white70 : Colors.black54,
          ),
        ),
        const SizedBox(height: 8),

        Obx(() {
          if (controller.canResend.value) {
            return GestureDetector(
              onTap:
                  controller.isResendLoading.value
                      ? null
                      : controller.resendOtp,
              child:
                  controller.isResendLoading.value
                      ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : Text(
                        'Resend Code',
                        style: getDMTextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryDarkBlue,
                        ),
                      ),
            );
          } else {
            return Text(
              'Resend in ${controller.countdown.value}s',
              style: getDMTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDarkTheme ? Colors.white54 : Colors.black45,
              ),
            );
          }
        }),
      ],
    );
  }
}
