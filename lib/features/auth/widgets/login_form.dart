import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:prince1025/core/common/widgets/custom_gradient_elevated_button.dart';
import 'package:prince1025/core/utils/constants/colors.dart';
import 'package:prince1025/core/utils/constants/icon_path.dart';
import 'package:prince1025/features/auth/controllers/auth_controller.dart';
import 'package:prince1025/features/auth/screens/forgot_password_screen.dart';

class LoginForm extends StatelessWidget {
  final AuthController authController;

  const LoginForm({super.key, required this.authController});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Email label and Field
        Text("Email", style: Theme.of(context).textTheme.labelLarge),
        SizedBox(height: 8),
        // CustomTextField(
        //   hint: "Enter Email or user name",
        //   controller: authController.emailController,
        // ),
        TextFormField(
          controller: authController.emailController,
          decoration: InputDecoration(hintText: "Enter Email or user name"),
        ),
        const SizedBox(height: 15),

        // Password label and Field
        Text("Password", style: Theme.of(context).textTheme.labelLarge),
        SizedBox(height: 8),
        Obx(
          () => TextFormField(
            controller: authController.passwordController,
            obscureText: authController.obscurePassword.value,
            decoration: InputDecoration(
              hintText: "Enter password",
              suffixIcon: IconButton(
                icon:
                    authController.obscurePassword.value
                        ? SvgPicture.asset(IconPath.eyeVisibilityOff)
                        : SvgPicture.asset(IconPath.eyeVisible),
                onPressed: authController.togglePasswordVisibility,
              ),
            ),
          ),
        ),
        //const SizedBox(height: 2),

        // Remember Me and Forgot Password
        Row(
          children: [
            Obx(
              () => Checkbox(
                value: authController.rememberMe.value,
                onChanged: authController.toggleRememberMe,
                fillColor: WidgetStateProperty.resolveWith<Color>((
                  Set<WidgetState> states,
                ) {
                  if (states.contains(WidgetState.selected)) {
                    return AppColors.primaryDarkBlue;
                  }
                  return Colors.transparent;
                }),
                checkColor: AppColors.primaryWhite,
                side: const BorderSide(color: AppColors.primaryWhite),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                // 👇 This reduces the internal spacing
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity(horizontal: -4, vertical: -4),
              ),
            ),
            SizedBox(width: 6),
            Text(
              "Remember me",
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400),
            ),
            Spacer(),
            TextButton(
              onPressed: () {
                Get.to(() => ForgotPasswordScreen());
              },
              child: Text(
                "Forgot Password?",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Login Button
        isDark
            ? CustomGradientButton(
              onPressed: () => authController.login(),
              gradient: AppColors.primaryGradient,
              child: const Text('Login'),
            )
            : SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => authController.login(),
                child: const Text('Login'),
              ),
            ),
        const SizedBox(height: 20),

        // ---- Or Continue With ----
        Row(
          children: [
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                "Or Continue With",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 20),

        // Google and facebook button
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 47,

                child: OutlinedButton.icon(
                  icon: SvgPicture.asset(IconPath.google),
                  label: Text(
                    "Google",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    side: const BorderSide(color: AppColors.primaryWhite),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 47,
                child: OutlinedButton.icon(
                  icon: SvgPicture.asset(IconPath.facebook),
                  label: Text(
                    "Facebook",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    side: const BorderSide(color: AppColors.primaryWhite),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
