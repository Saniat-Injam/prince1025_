import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prince1025/core/common/widgets/custom_gradient_elevated_button.dart';
import 'package:prince1025/core/utils/constants/colors.dart';
import 'package:prince1025/core/utils/constants/image_path.dart';
import 'package:prince1025/features/auth/controllers/forgot_password_controller.dart';

class SetPasswordScreen extends StatelessWidget {
  final ForgotPasswordController forgotPasswordController =
      Get.find<ForgotPasswordController>();

  SetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final String backgroundImage =
        isDarkTheme
            ? ImagePath.darkSetNewPasswordScreenBackground
            : ImagePath.lightSetNewPasswordScreenBackground;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Image.asset(ImagePath.authLogo),
              const SizedBox(height: 56),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color:
                      isDarkTheme
                          ? Colors.transparent
                          : AppColors.primaryWhite.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primaryWhite.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Set New Password",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "We have verified your email. Please set your new password.",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 24),

                    // New Password
                    Text(
                      "New Password",
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: forgotPasswordController.passwordController,

                      decoration: const InputDecoration(
                        hintText: "Set new password",
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Confirm Password
                    Text(
                      "Confirm Password",
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller:
                          forgotPasswordController.confirmPasswordController,
                      decoration: const InputDecoration(
                        hintText: "Set new password",
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Continue Button
                    isDarkTheme
                        ? CustomGradientButton(
                          onPressed:
                              forgotPasswordController.resetForgotPassword,
                          gradient: AppColors.primaryGradient,
                          child: const Text('Set New Password'),
                        )
                        : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed:
                                forgotPasswordController.resetForgotPassword,
                            child: const Text('Set New password'),
                          ),
                        ),
                    SizedBox(height: 24),
                    Text(
                      "Don't Have an Account",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(height: 8),
                    // TextButton(
                    //   onPressed: () {},
                    //   child: Text("Create Account"),
                    // ),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        "Create Account",
                        style: Theme.of(context).textTheme.displaySmall,
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
