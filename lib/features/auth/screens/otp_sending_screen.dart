import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prince1025/core/common/widgets/custom_gradient_elevated_button.dart';
import 'package:prince1025/core/utils/constants/colors.dart';
import 'package:prince1025/core/utils/constants/image_path.dart';
import 'package:prince1025/features/auth/controllers/auth_controller.dart';

class OTPSendingScreen extends StatelessWidget {
  //final AuthController authController = Get.put(AuthController());
  final AuthController authController = Get.find<AuthController>();
  OTPSendingScreen({super.key});

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

  /// Mask phone number for display (e.g., +1234567890 -> +123****890)
  String _maskPhoneNumber(String phone) {
    if (phone.length < 4) return phone;

    final start = phone.substring(0, 3);
    final end = phone.substring(phone.length - 3);
    final masked = '*' * (phone.length - 6);

    return '$start$masked$end';
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final String backgroundImage =
        isDark
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.20),

              Image.asset(ImagePath.authLogo),
              SizedBox(height: screenHeight * 0.15),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color:
                      isDark
                          ? Colors.transparent
                          : Colors.white.withValues(alpha: 0.25),
                  border: Border.all(
                    color: AppColors.primaryWhite.withValues(alpha: 0.25),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Send Code To Complete The Verification Process',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    SizedBox(height: 12),

                    // Email and Number Radio Toogle
                    Text(
                      'An authentication code has been sent to',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Obx(
                      () => Column(
                        children: [
                          // Email option - always enabled
                          RadioListTile(
                            title: Text(
                              authController.emailController.text.isNotEmpty
                                  ? _maskEmail(
                                    authController.emailController.text,
                                  )
                                  : 'Email not available',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            value: 'email',
                            groupValue: authController.selectedOTPMethod.value,
                            activeColor: AppColors.primaryDarkBlue,
                            onChanged:
                                (value) => authController.setOTPMethod(value!),
                          ),

                          // Phone option - disabled for now
                          RadioListTile(
                            title: Text(
                              authController.phoneController.text.isNotEmpty
                                  ? _maskPhoneNumber(
                                    authController.phoneController.text,
                                  )
                                  : 'Phone not available',
                              style: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.copyWith(
                                color: Colors.grey, // Show as disabled
                              ),
                            ),
                            subtitle: Text(
                              'Coming soon',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            value: 'phone',
                            groupValue: null, // Always unselected
                            activeColor: AppColors.primaryDarkBlue,
                            onChanged: null, // Disabled
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),

                    isDark
                        ? CustomGradientButton(
                          onPressed: authController.sendOTPCode,
                          gradient: AppColors.primaryGradient,
                          child: const Text('Send Code'),
                        )
                        : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: authController.sendOTPCode,
                            child: const Text('Send Code'),
                          ),
                        ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
