import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prince1025/core/common/widgets/custom_gradient_elevated_button.dart';
import 'package:prince1025/core/utils/constants/colors.dart';
import 'package:prince1025/core/utils/constants/image_path.dart';
import 'package:prince1025/features/auth/controllers/forgot_password_controller.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final ForgotPasswordController forgotPasswordController = Get.put(
    ForgotPasswordController(),
  );

  ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final String backgroundImage =
        isDark
            ? ImagePath.darkforgotPasswordScreenBackground
            : ImagePath.lightforgotPasswordScreenBackground;
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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // const Spacer(),
                SizedBox(
                  height: screenHeight * 0.14, // 14% of screen height
                ),
                Image.asset(ImagePath.authLogo),
                const Spacer(),

                // Forgot Password Card
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color:
                        isDark
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
                        "Forgot Password?",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "We will send a mail to the mail address you registered to regain your password.",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 24),

                      Text(
                        "Email",
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      SizedBox(height: 8),

                      TextFormField(
                        controller: forgotPasswordController.emailController,
                        decoration: const InputDecoration(
                          hintText: "Enter your email or phone number",
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Continue Button
                      // isDarkTheme
                      //     ? CustomGradientButton(
                      //       onPressed: () async {
                      //         EasyLoading.show(status: "Sending...");
                      //         final success =
                      //             await authController.sendResetLink();
                      //         EasyLoading.dismiss();

                      //         if (success) {
                      //           //Get.to(() => VerificationCodeScreen());
                      //           Get.to(
                      //             () => VerificationCodeScreen(
                      //               origin: VerificationOrigin.forgotPassword,
                      //             ),
                      //           );
                      //         } else {
                      //           // Optionally show an error if sending the link failed
                      //           EasyLoading.showError(
                      //             "Failed to send reset link.",
                      //           );
                      //         }
                      //       },
                      //       gradient: AppColors.primaryGradient,
                      //       child: const Text('Continue'),
                      //     )
                      //     : SizedBox(
                      //       width: double.infinity,
                      //       child: ElevatedButton(
                      //         onPressed: () async {
                      //           final success =
                      //               await authController.sendResetLink();
                      //           if (success) {
                      //             //Get.to(() => VerificationCodeScreen());
                      //             Get.to(
                      //               () => VerificationCodeScreen(
                      //                 origin: VerificationOrigin.forgotPassword,
                      //               ),
                      //             );
                      //           } else {
                      //             // Optionally show an error if sending the link failed
                      //             // Get.snackbar(
                      //             //   "Error",
                      //             //   "Failed to send reset link.",
                      //             // );
                      //           }
                      //         },
                      //         child: const Text('Continue'),
                      //       ),
                      //     ),
                      isDark
                          ? CustomGradientButton(
                            onPressed:
                                forgotPasswordController.sendForgotPasswordOtp,
                            gradient: AppColors.primaryGradient,
                            child: const Text('Send Code'),
                          )
                          : SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed:
                                  forgotPasswordController
                                      .sendForgotPasswordOtp,
                              child: const Text('Send Code'),
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
      ),
    );
  }
}
