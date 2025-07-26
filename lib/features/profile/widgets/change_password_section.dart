import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:prince1025/core/utils/constants/svg_path.dart';
import 'package:prince1025/features/profile/controllers/profile_controller.dart';
import 'package:prince1025/core/common/styles/global_text_style.dart';
import 'package:prince1025/features/profile/widgets/custom_Input_textfield.dart';
import 'package:prince1025/features/profile/widgets/custom_ev_button.dart';

class ChangePasswordSection extends StatelessWidget {
  final ProfileController controller;
  final bool isExpanded;
  final Function() onTap;
  final Color textColor;
  final Color? iconColor;

  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final RxBool currentPasswordVisible = false.obs;
  final RxBool newPasswordVisible = false.obs;
  final RxBool confirmPasswordVisible = false.obs;

  ChangePasswordSection({
    required this.controller,
    required this.isExpanded,
    required this.onTap,
    required this.textColor,
    required this.iconColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Change Password Header
        InkWell(
          onTap: onTap,
          child: Row(
            children: [
              SvgPicture.asset(
                SvgPath.passwordSvg,
                width: 20,
                height: 20,
                colorFilter:
                    iconColor != null
                        ? ColorFilter.mode(iconColor!, BlendMode.srcIn)
                        : null,
              ),
              const SizedBox(width: 8),
              Text(
                'Change Password',
                style: getDMTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
              const Spacer(),
              isExpanded
                  ? SvgPicture.asset(
                    SvgPath.arrowDownSvg,
                    width: 20,
                    height: 20,
                    colorFilter:
                        iconColor != null
                            ? ColorFilter.mode(iconColor!, BlendMode.srcIn)
                            : null,
                  )
                  : SvgPicture.asset(
                    SvgPath.rightArrowSvg,
                    width: 20,
                    height: 20,
                    colorFilter:
                        iconColor != null
                            ? ColorFilter.mode(iconColor!, BlendMode.srcIn)
                            : null,
                  ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Expandable content
        if (isExpanded)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Current Password
              Obx(
                () => CustomInputTextField(
                  controller: currentPasswordController,
                  obscureText: !currentPasswordVisible.value,
                  hint: 'Type Current Password',
                  suffixIcon: IconButton(
                    icon: SvgPicture.asset(
                      currentPasswordVisible.value
                          ? SvgPath.visibilityOffSvg
                          : SvgPath.visibilitySvg,
                      width: 20,
                      height: 20,
                      colorFilter:
                          iconColor != null
                              ? ColorFilter.mode(iconColor!, BlendMode.srcIn)
                              : null,
                    ),
                    onPressed:
                        () =>
                            currentPasswordVisible.value =
                                !currentPasswordVisible.value,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Forgot Password?',
                    style: getDMTextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color:
                          isDarkTheme ? Color(0xFFD9114A) : Color(0xFFFF004A),
                    ),
                  ),
                ),
              ),

              // New Password
              Obx(
                () => CustomInputTextField(
                  controller: newPasswordController,
                  obscureText: !newPasswordVisible.value,
                  hint: 'Type New Password',
                  suffixIcon: IconButton(
                    icon: SvgPicture.asset(
                      newPasswordVisible.value
                          ? SvgPath.visibilityOffSvg
                          : SvgPath.visibilitySvg,
                      width: 20,
                      height: 20,
                      colorFilter:
                          iconColor != null
                              ? ColorFilter.mode(iconColor!, BlendMode.srcIn)
                              : null,
                    ),
                    onPressed:
                        () =>
                            newPasswordVisible.value =
                                !newPasswordVisible.value,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Confirm Password
              Obx(
                () => CustomInputTextField(
                  controller: confirmPasswordController,
                  obscureText: !confirmPasswordVisible.value,
                  hint: 'Confirm Password',
                  suffixIcon: IconButton(
                    icon: SvgPicture.asset(
                      confirmPasswordVisible.value
                          ? SvgPath.visibilityOffSvg
                          : SvgPath.visibilitySvg,
                      width: 20,
                      height: 20,
                      colorFilter:
                          iconColor != null
                              ? ColorFilter.mode(iconColor!, BlendMode.srcIn)
                              : null,
                    ),
                    onPressed:
                        () =>
                            confirmPasswordVisible.value =
                                !confirmPasswordVisible.value,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Save Changes Button
              Obx(
                () => CustomEVButton(
                  onPressed: () async {
                    if (!controller.isLoading.value && _validatePasswords()) {
                      await controller.changePassword(
                        currentPasswordController.text,
                        newPasswordController.text,
                      );
                      // Clear form and close section after API call
                      _clearForm();
                      onTap();
                    }
                  },
                  text:
                      controller.isLoading.value
                          ? 'Changing...'
                          : 'Save Changes',
                ),
              ),
            ],
          ),
      ],
    );
  }

  bool _validatePasswords() {
    if (currentPasswordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your current password',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return false;
    }
    if (newPasswordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a new password',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return false;
    }
    if (confirmPasswordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please confirm your password',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return false;
    }
    if (newPasswordController.text != confirmPasswordController.text) {
      Get.snackbar(
        'Error',
        'New password and confirm password do not match',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return false;
    }
    if (newPasswordController.text.length < 6) {
      Get.snackbar(
        'Error',
        'New password must be at least 6 characters long',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return false;
    }
    return true;
  }

  void _clearForm() {
    currentPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
    currentPasswordVisible.value = false;
    newPasswordVisible.value = false;
    confirmPasswordVisible.value = false;
  }
}
