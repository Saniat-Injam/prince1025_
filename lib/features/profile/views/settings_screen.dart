import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:prince1025/core/common/styles/global_text_style.dart';
import 'package:prince1025/core/common/widgets/custom_app_bar.dart';
import 'package:prince1025/core/common/widgets/custom_container.dart';
import 'package:prince1025/core/models/user_model.dart';
import 'package:prince1025/core/utils/constants/colors.dart';
import 'package:prince1025/core/utils/constants/image_path.dart';
import 'package:prince1025/core/utils/constants/svg_path.dart';
import 'package:prince1025/features/profile/controllers/profile_controller.dart';
import 'package:prince1025/features/profile/widgets/action_buttons_section.dart';
import 'package:prince1025/features/profile/widgets/change_name_section.dart';
import 'package:prince1025/features/profile/widgets/change_password_section.dart';
import 'package:prince1025/features/profile/widgets/profile_header.dart';
import 'package:prince1025/features/profile/widgets/subscription_section.dart';
import 'package:prince1025/features/profile/widgets/theme_selection_section.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final profilController = Get.put(ProfileController());

    // Track expanded sections
    final RxBool isNameExpanded = false.obs;
    final RxBool isPasswordExpanded = false.obs;

    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final String? backgroundImage =
        isDarkTheme ? ImagePath.darkSettingScreenbackground : null;

    final textColor = isDarkTheme ? Color(0xFFF5F5F5) : Colors.black87;
    final iconColor =
        isDarkTheme ? Color(0xFFF5F5F5) : AppColors.primaryDarkBlue;
    final dividerColor = isDarkTheme ? Color(0xFF635C6E) : Color(0xffD1EFFB);
    final containerColor =
        isDarkTheme ? Colors.black.withValues(alpha: 0.1) : Color(0xFFFFFFFF);
    final shadowColor =
        isDarkTheme
            ? Colors.black.withValues(alpha: 0.2)
            : Color(0xFF323131).withValues(alpha: 0.12);

    return Container(
      decoration: BoxDecoration(
        image:
            isDarkTheme && backgroundImage != null
                ? DecorationImage(
                  image: AssetImage(backgroundImage),
                  fit: BoxFit.cover,
                )
                : null,
      ),
      child: Scaffold(
        backgroundColor: isDarkTheme ? Colors.transparent : Colors.white,
        appBar: CustomAppBar(
          title: 'Settings',
          backgroundColor: isDarkTheme ? Colors.transparent : Colors.white,
          foregroundColor: isDarkTheme ? Colors.white : null,
          elevation: isDarkTheme ? 0 : 0,
        ),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () => profilController.refreshUserProfileFromApi(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Profile Header
                    const SizedBox(height: 16),
                    ProfileHeader(
                      profileController: profilController,
                      isDarkTheme: isDarkTheme,
                      containerColor: containerColor,
                      shadowColor: shadowColor,
                      textColor: textColor,
                    ),
                    const SizedBox(height: 16),

                    // Account Settings
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,

                      children: [
                        CustomContainer(
                          isDarkTheme: isDarkTheme,
                          borderRadius: 12,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Account Settings Label
                                Text(
                                  'Account Settings',
                                  style: TextStyle(
                                    fontFamily: 'Enwallowify',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: textColor,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                _buildDivider(dividerColor),
                                // Change Name Section
                                Obx(
                                  () => ChangeNameSection(
                                    controller: profilController,
                                    isExpanded: isNameExpanded.value,
                                    textColor: textColor,
                                    iconColor: iconColor,
                                    onTap:
                                        () =>
                                            isNameExpanded.value =
                                                !isNameExpanded.value,
                                  ),
                                ),
                                _buildDivider(dividerColor),

                                // Change Password Section
                                Obx(
                                  () => ChangePasswordSection(
                                    controller: profilController,
                                    isExpanded: isPasswordExpanded.value,
                                    textColor: textColor,
                                    iconColor: iconColor,
                                    onTap:
                                        () =>
                                            isPasswordExpanded.value =
                                                !isPasswordExpanded.value,
                                  ),
                                ),
                                _buildDivider(dividerColor),

                                // Theme Selection Section
                                ThemeSelectionSection(
                                  textColor: textColor,
                                  iconColor: iconColor,
                                  isDarkTheme: isDarkTheme,
                                ),
                                _buildDivider(dividerColor),

                                // Action Buttons Section faq, contact support, terms and conditions
                                ActionButtonsSection(
                                  textColor: textColor,
                                  iconColor: iconColor,
                                  dividerColor: dividerColor,
                                  controller: profilController,
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),
                        
                        if (profilController.isPremium.value)
                          // Subscription Section
                          SubscriptionSection(
                            controller: profilController,
                            textColor: textColor,
                            isDarkTheme: isDarkTheme,
                          ),
                        const SizedBox(height: 16),

                        // Log Out Button
                        Container(
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: isDarkTheme ? Color(0xFFC30F43) : Colors.red,
                            boxShadow:
                                isDarkTheme
                                    ? null
                                    : [
                                      BoxShadow(
                                        color: shadowColor,
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                          ),
                          child: TextButton.icon(
                            icon: SvgPicture.asset(SvgPath.logoutSvg),
                            label: Text(
                              'Log Out',
                              style: getDMTextStyle(
                                color:
                                    isDarkTheme
                                        ? Color(0xFFF5F5F5)
                                        : Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            onPressed: () {
                              profilController.logOut();
                            },
                          ),
                        ),
                        // Bottom padding
                        const SizedBox(height: 16),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Divider _buildDivider(Color dividerColor) {
    return Divider(color: dividerColor, thickness: 0.8, height: 14);
  }
}
