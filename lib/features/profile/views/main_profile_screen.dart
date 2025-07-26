import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:prince1025/core/common/styles/global_text_style.dart';
import 'package:prince1025/core/common/widgets/custom_app_bar.dart';
import 'package:prince1025/core/utils/constants/image_path.dart';
import 'package:prince1025/core/utils/constants/svg_path.dart';
import 'package:prince1025/features/profile/controllers/profile_controller.dart';
import 'package:prince1025/features/profile/widgets/profile_header.dart';
import 'package:prince1025/features/profile/widgets/saved_quotes_section.dart';
import 'package:prince1025/features/profile/widgets/subscription_section.dart';
import 'package:prince1025/features/profile/widgets/favorite_videos_section.dart';
import 'package:prince1025/features/profile/widgets/my_contents_section.dart';
import 'package:prince1025/features/profile/views/settings_screen.dart';

class MainProfileScreen extends StatelessWidget {
  const MainProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final profileController = Get.put(ProfileController());

    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final String? backgroundImage =
        isDarkTheme ? ImagePath.darkSettingScreenbackground : null;

    final textColor = isDarkTheme ? Color(0xFFF5F5F5) : Colors.black87;
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
          showBackButton: false,
          automaticallyImplyLeading: false,
          title: 'Profile',
          backgroundColor: isDarkTheme ? Colors.transparent : Colors.white,
          foregroundColor: isDarkTheme ? Colors.white : null,
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(
                Icons.settings,
                color: isDarkTheme ? Colors.white : Colors.black87,
              ),
              onPressed: () {
                Get.to(() => const SettingsScreen());
              },
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Profile Header (Reuse existing)
                  ProfileHeader(
                    profileController: profileController,
                    isDarkTheme: isDarkTheme,
                    containerColor: containerColor,
                    shadowColor: shadowColor,
                    textColor: textColor,
                  ),
                  const SizedBox(height: 16),

                  // Subscription Section - Only show if user is premium
                  Obx(() {
                    if (profileController.isPremium.value) {
                      return Column(
                        children: [
                          SubscriptionSection(
                            controller: profileController,
                            textColor: textColor,
                            isDarkTheme: isDarkTheme,
                          ),
                          const SizedBox(height: 16),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  }),

                  // Favorite Videos Section
                  FavoriteVideosSection(
                    textColor: textColor,
                    isDarkTheme: isDarkTheme,
                  ),
                  const SizedBox(height: 16),

                  // My Contents Section
                  MyContentsSection(
                    textColor: textColor,
                    isDarkTheme: isDarkTheme,
                  ),
                  const SizedBox(height: 16),

                  // Saved Quotes Section
                  SavedQuotesSection(
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
                    ),
                    child: TextButton.icon(
                      icon: SvgPicture.asset(
                        SvgPath.logoutSvg,
                        width: 20,
                        height: 20,
                      ),
                      label: Text(
                        'Log Out',
                        style: getDMTextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onPressed: () {
                        profileController.logOut();
                      },
                    ),
                  ),

                  // Bottom padding for navigation
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
