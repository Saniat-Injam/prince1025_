import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:prince1025/core/common/widgets/custom_gradient_elevated_button.dart';
import 'package:prince1025/core/utils/constants/colors.dart';
import 'package:prince1025/core/utils/constants/icon_path.dart';
import 'package:prince1025/features/auth/controllers/registration_controller.dart';

/// Enhanced Registration Form with UI matching registration_form_new.dart
/// Uses RegistrationController for business logic and API calls
class EnhancedRegistrationForm extends StatelessWidget {
  const EnhancedRegistrationForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RegistrationController());
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Form(
      key: controller.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          // Name
          TextFormField(
            controller: controller.fullNameController,
            validator: controller.validateFullName,
            decoration: InputDecoration(hintText: "Enter your full name"),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),

          // Email
          TextFormField(
            controller: controller.emailController,
            validator: controller.validateEmail,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(hintText: "Enter your email address"),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),

          // Phone Number
          IntlPhoneField(
            controller: controller.phoneController,
            initialCountryCode: 'US',
            dropdownIcon: Icon(
              CupertinoIcons.chevron_down,
              color: AppColors.primaryWhite,
              size: 16,
            ),
            dropdownIconPosition: IconPosition.trailing,
            decoration: InputDecoration(
              hintText: 'Your phone number',
              filled: true,
              counterText: "",
            ),
            flagsButtonPadding: const EdgeInsets.only(left: 12),
            validator: (phone) {
              if (phone == null || phone.completeNumber.isEmpty) {
                return 'Please enter your phone number';
              }
              // only digits are allowed
              if (!RegExp(r'^\d+$').hasMatch(phone.completeNumber)) {
                return 'Phone number can only contain digits';
              }
              if (phone.completeNumber.length < 8 ||
                  phone.completeNumber.length > 15) {
                return 'Please enter a valid phone number';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // New Password
          Obx(
            () => TextFormField(
              controller: controller.passwordController,
              validator: controller.validatePassword,
              obscureText: !controller.isPasswordVisible.value,
              decoration: InputDecoration(
                hintText: "New password",
                suffixIcon: IconButton(
                  icon:
                      controller.isPasswordVisible.value
                          ? SvgPicture.asset(IconPath.eyeVisible)
                          : SvgPicture.asset(IconPath.eyeVisibilityOff),
                  onPressed: controller.togglePasswordVisibility,
                ),
              ),
              textInputAction: TextInputAction.next,
            ),
          ),
          const SizedBox(height: 16),

          // Confirm Password
          Obx(
            () => TextFormField(
              controller: controller.confirmPasswordController,
              validator: controller.validateConfirmPassword,
              obscureText: !controller.isConfirmPasswordVisible.value,
              decoration: InputDecoration(
                hintText: "Confirm password",
                suffixIcon: IconButton(
                  icon:
                      !controller.isConfirmPasswordVisible.value
                          ? SvgPicture.asset(IconPath.eyeVisibilityOff)
                          : SvgPicture.asset(IconPath.eyeVisible),
                  onPressed: controller.toggleConfirmPasswordVisibility,
                ),
              ),
              textInputAction: TextInputAction.done,
            ),
          ),
          const SizedBox(height: 10),

          // CheckBox with Text
          Obx(
            () => CheckboxListTile(
              value: controller.agreedToTerms.value,
              onChanged: controller.toggleTermsAgreement,
              title: Text(
                "By creating an account, you agree to continue our terms and conditions.",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              contentPadding: EdgeInsets.zero, // removes default padding
              controlAffinity:
                  ListTileControlAffinity.leading, // checkbox on the left
              dense: true,
              visualDensity: VisualDensity(horizontal: -4, vertical: -4),
              activeColor: AppColors.primaryDarkBlue,
              checkColor: AppColors.primaryWhite,
              side: const BorderSide(color: AppColors.primaryWhite),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              fillColor: WidgetStateProperty.resolveWith<Color>((
                Set<WidgetState> states,
              ) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.primaryDarkBlue;
                }
                return Colors.transparent;
              }),
            ),
          ),

          SizedBox(height: 10),

          // Register Button
            isDark
              ? CustomGradientButton(
                onPressed: controller.register,
                gradient: AppColors.primaryGradient,
                child: const Text('Register'),
              )
              : SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                onPressed: controller.register,
                child: const Text('Register'),
                ),
              ),
          const SizedBox(height: 16),

          // ---- Or Continue With ----
          Row(
            children: [
              Expanded(child: Divider(color: AppColors.primaryWhite)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  "Or Continue With",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              Expanded(child: Divider(color: AppColors.primaryWhite)),
            ],
          ),
          const SizedBox(height: 16),

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
      ),
    );
  }
}
