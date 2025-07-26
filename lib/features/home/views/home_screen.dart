import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:prince1025/core/common/widgets/custom_app_bar.dart';
import 'package:prince1025/core/utils/constants/image_path.dart';
import 'package:prince1025/core/utils/constants/svg_path.dart';
import 'package:prince1025/features/home/controllers/home_controller.dart';
import 'package:prince1025/features/home/widgets/carosel_slider_section.dart';
import 'package:prince1025/features/home/widgets/custom_carosel_indicator.dart';
import 'package:prince1025/features/home/widgets/manifestation_courses_section.dart';
import 'package:prince1025/features/home/widgets/latest_videos_section.dart';
import 'package:prince1025/features/home/widgets/daily_inspiration_section.dart';
import 'package:prince1025/features/home/widgets/coming_soon_section.dart';
import 'package:prince1025/features/home/widgets/premium_upgrade_card.dart';
import 'package:prince1025/routes/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.put(HomeController());

    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final String? backgroundImage =
        isDarkTheme ? ImagePath.darkSettingScreenbackground : null;
    final textColor = isDarkTheme ? const Color(0xFFF5F5F5) : Colors.black87;
    final backgroundColor =
        isDarkTheme ? const Color(0xFF121212) : const Color(0xFFF8F9FA);
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
        backgroundColor: isDarkTheme ? Colors.transparent : backgroundColor,
        appBar: CustomAppBar(
          title: 'Home',
          showBackButton: false,
          actions: [
            IconButton(
              icon: SvgPicture.asset(
                SvgPath.notificationSvg,
                colorFilter: ColorFilter.mode(
                  isDarkTheme ? Colors.white : Colors.black,
                  BlendMode.srcIn,
                ),
              ),
              onPressed: () {
                Get.toNamed(AppRoute.notificationScreen);
              },
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  SizedBox(height: 24),

                  // carousel Section
                  CaroselSliderSection(
                    controller: homeController,
                    isDarkTheme: isDarkTheme,
                    textColor: textColor,
                  ),
                  // indicator
                  const SizedBox(height: 12),

                  CustomCaroselIndicator(
                    homeController: homeController,
                    isDarkTheme: isDarkTheme,
                  ),
                  const SizedBox(height: 24),

                  // Manifestation Courses section
                  ManifestationCoursesSection(
                    controller: homeController,
                    isDarkTheme: isDarkTheme,
                    textColor: textColor,
                  ),
                  const SizedBox(height: 24),

                  // Latest Videos section
                  LatestVideosSection(
                    homeController: homeController,
                    isDarkTheme: isDarkTheme,
                    textColor: textColor,
                  ),

                  const SizedBox(height: 24),

                  // Daily Inspiration section
                  DailyInspirationSection(
                    controller: homeController,
                    isDarkTheme: isDarkTheme,
                    textColor: textColor,
                  ),
                  const SizedBox(height: 24),

                  // Coming Soon section
                  ComingSoonSection(
                    controller: homeController,
                    isDarkTheme: isDarkTheme,
                    textColor: textColor,
                    onTap: () {
                      homeController.showToast(
                        'Coming soon feature is not available yet',
                        isDarkTheme,
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Unlock Premium Content section
                  PremiumUpgradeCard(
                    controller: homeController,
                    isDarkTheme: isDarkTheme,
                    textColor: textColor,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
