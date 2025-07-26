// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:intl_phone_field/intl_phone_field.dart';
// import 'package:prince1025/core/common/widgets/custom_gradient_elevated_button.dart';
// import 'package:prince1025/core/common/widgets/custom_text_field.dart';
// import 'package:prince1025/core/utils/constants/colors.dart';
// import 'package:prince1025/core/utils/constants/icon_path.dart';
// import 'package:prince1025/features/auth/controller/auth_controller.dart';

// class RegistrationForm extends StatelessWidget {
//   final AuthController authController;

//   const RegistrationForm({super.key, required this.authController});

//   @override
//   Widget build(BuildContext context) {
//     final bool isDark = Theme.of(context).brightness == Brightness.dark;
//     return Column(
//       children: [
//         // Name
//         TextFormField(
//           controller: authController.fullNameController,
//           decoration: InputDecoration(hintText: "Enter your full name"),
//         ),
//         const SizedBox(height: 16),

//         // Email
//         TextFormField(
//           controller: authController.emailController,
//           decoration: InputDecoration(hintText: "Enter your email address"),
//         ),
//         const SizedBox(height: 16),
//         // Phone Number
//         IntlPhoneField(
//           controller: authController.phoneController,
//           initialCountryCode: 'US',
//           dropdownIcon: Icon(
//             //Icons.arrow_drop_down,
//             CupertinoIcons.chevron_down,
//             color: AppColors.primaryWhite,
//             size: 16,
//           ),
//           dropdownIconPosition: IconPosition.trailing,
//           decoration: InputDecoration(
//             hintText: 'Your phone number',
//             filled: true,
//             counterText: "",
//           ),
//           flagsButtonPadding: const EdgeInsets.only(left: 12),
//           onChanged: (phone) {
//             debugPrint(phone.completeNumber);
//             authController.fullPhoneNumber.value = phone.completeNumber;
//           },
//         ),

//         const SizedBox(height: 16),

//         // New Password
//         Obx(
//           () => CustomTextField(
//             controller: authController.passwordController,
//             hint: "New password",
//             obscureText: !authController.isPasswordVisible.value,
//             suffixIcon: IconButton(
//               icon:
//                   authController.isPasswordVisible.value
//                       ? SvgPicture.asset(IconPath.eyeVisible)
//                       : SvgPicture.asset(IconPath.eyeVisibilityOff),
//               onPressed: authController.toggleRegisterPasswordVisibility,
//             ),
//           ),
//         ),
//         const SizedBox(height: 16),

//         // Confirm Password
//         Obx(
//           () => CustomTextField(
//             controller: authController.confirmPasswordController,
//             hint: "Confirm password",
//             obscureText: !authController.isConfirmPasswordVisible.value,
//             suffixIcon: IconButton(
//               icon:
//                   !authController.isConfirmPasswordVisible.value
//                       ? SvgPicture.asset(IconPath.eyeVisibilityOff)
//                       : SvgPicture.asset(IconPath.eyeVisible),
//               onPressed: authController.toggleConfirmPasswordVisibility,
//             ),
//           ),
//         ),
//         const SizedBox(height: 10),

//         // CheckBox with Text
//         Obx(
//           () => CheckboxListTile(
//             value: authController.agreedToTerms.value,
//             onChanged: authController.toggleTermsAgreement,
//             title: Text(
//               "By creating an account, you agree to continue our terms and conditions.",
//               style: Theme.of(context).textTheme.bodyMedium,
//             ),
//             contentPadding: EdgeInsets.zero, // removes default padding
//             controlAffinity:
//                 ListTileControlAffinity.leading, // checkbox on the left
//             dense: true,
//             visualDensity: VisualDensity(horizontal: -4, vertical: -4),
//             activeColor: AppColors.primaryDarkBlue,
//             checkColor: AppColors.primaryWhite,
//             side: const BorderSide(color: AppColors.primaryWhite),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(4),
//             ),
//             fillColor: WidgetStateProperty.resolveWith<Color>((
//               Set<WidgetState> states,
//             ) {
//               if (states.contains(WidgetState.selected)) {
//                 return AppColors.primaryDarkBlue;
//               }
//               return Colors.transparent;
//             }),
//           ),
//         ),

//         SizedBox(height: 10),

//         // Register Button
//         isDark
//             ? CustomGradientButton(
//               onPressed: authController.register,
//               gradient: AppColors.primaryGradient,
//               child: const Text('Register'),
//             )
//             : SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: authController.register,
//                 child: const Text('Register'),
//               ),
//             ),
//         const SizedBox(height: 16),

//         // ---- Or Continue With ----
//         Row(
//           children: [
//             Expanded(child: Divider(color: AppColors.primaryWhite)),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 8),
//               child: Text(
//                 "Or Continue With",
//                 style: Theme.of(context).textTheme.bodyLarge,
//               ),
//             ),
//             Expanded(child: Divider(color: AppColors.primaryWhite)),
//           ],
//         ),
//         const SizedBox(height: 16),

//         // Google and facebook button
//         Row(
//           children: [
//             Expanded(
//               child: SizedBox(
//                 height: 47,

//                 child: OutlinedButton.icon(
//                   icon: SvgPicture.asset(IconPath.google),
//                   label: Text(
//                     "Google",
//                     style: Theme.of(context).textTheme.bodyLarge,
//                   ),
//                   onPressed: () {},
//                   style: OutlinedButton.styleFrom(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     side: const BorderSide(color: AppColors.primaryWhite),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(width: 12),
//             Expanded(
//               child: SizedBox(
//                 height: 47,
//                 child: OutlinedButton.icon(
//                   icon: SvgPicture.asset(IconPath.facebook),
//                   label: Text(
//                     "Facebook",
//                     style: Theme.of(context).textTheme.bodyLarge,
//                   ),
//                   onPressed: () {},
//                   style: OutlinedButton.styleFrom(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     side: const BorderSide(color: AppColors.primaryWhite),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
