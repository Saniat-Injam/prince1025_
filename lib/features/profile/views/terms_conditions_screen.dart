import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prince1025/core/common/widgets/custom_app_bar.dart';
import 'package:prince1025/core/common/styles/global_text_style.dart';
import 'package:prince1025/core/utils/constants/image_path.dart';
import 'package:prince1025/core/common/widgets/custom_container.dart';
import 'package:prince1025/features/profile/controllers/terms_conditions_controller.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TermsConditionsController());
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final String? backgroundImage =
        isDarkTheme ? ImagePath.darkSettingScreenbackground : null;

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
        appBar: CustomAppBar(title: 'Terms & Conditions'),
        body: RefreshIndicator(
          onRefresh: controller.refreshTermsData,
          child: Obx(() {
            // Show loading indicator while fetching data
            if (controller.isLoading.value && !controller.hasTermsData) {
              return Center(
                child: CircularProgressIndicator(
                  color: isDarkTheme ? Colors.white : Colors.blue,
                ),
              );
            }

            // Show empty state if no terms data available
            if (!controller.hasTermsData) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.description_outlined,
                        size: 64,
                        color: (isDarkTheme ? Colors.white : Colors.black87)
                            .withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No Terms & Conditions Available',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: isDarkTheme ? Colors.white : Colors.black87,
                          fontFamily: 'Enwallowify',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Pull down to refresh and try again',
                        style: TextStyle(
                          fontSize: 14,
                          color: (isDarkTheme ? Colors.white : Colors.black87)
                              .withValues(alpha: 0.7),
                          fontFamily: 'Enwallowify',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            // Show terms content
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dynamic terms sections from API
                  ...controller.termsCategories
                      .map(
                        (category) => Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: _buildTermsSection(
                            context: context,
                            title: category.title,
                            content: category.combinedContent,
                            lastUpdate: category.formattedLastUpdated,
                          ),
                        ),
                      )
                      .toList(),

                  // Adding some bottom padding
                  const SizedBox(height: 50),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildTermsSection({
    required BuildContext context,
    required String title,
    required String content,
    required String lastUpdate,
  }) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return CustomContainer(
      isDarkTheme: isDarkTheme,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Enwallowify',
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: isDarkTheme ? const Color(0xFFF5F5F5) : Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Last Update: ',
                    style: getDMTextStyle(
                      fontSize: 12,
                      color:
                          isDarkTheme
                              ? const Color(0xff4A00E0)
                              : const Color(0xff005E89),
                    ),
                  ),
                  TextSpan(
                    text: lastUpdate,
                    style: getDMTextStyle(
                      fontSize: 12,
                      color:
                          isDarkTheme
                              ? const Color(0xffBEBEBE)
                              : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              content,
              style: getDMTextStyle(
                fontSize: 16,
                color:
                    isDarkTheme
                        ? Color(0xFFF5F5F5)
                        : Colors.black.withValues(alpha: 0.8),
              ).copyWith(height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
