import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prince1025/core/common/widgets/custom_app_bar.dart';
import 'package:prince1025/core/utils/constants/image_path.dart';
import 'package:prince1025/features/profile/controllers/faq_controller.dart';
import 'package:prince1025/features/profile/widgets/faq_list.dart';
import 'package:prince1025/features/profile/widgets/faq_tab_bar.dart';
import 'package:prince1025/features/profile/widgets/grouped_faq_list.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FAQController());
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final String? backgroundImage =
        isDarkTheme ? ImagePath.darkSettingScreenbackground : null;
    final textColor = isDarkTheme ? const Color(0xFFF5F5F5) : Colors.black87;

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
        appBar: CustomAppBar(title: 'FAQ'),
        body: Column(
          children: [
            // Custom Tab Bar
            Obx(
              () => FAQTabBar(
                tabs: controller.tabs,
                selectedIndex: controller.selectedTabIndex.value,
                onTabSelected: controller.selectTab,
                isDarkTheme: isDarkTheme,
              ),
            ),
            // FAQ List with RefreshIndicator
            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.refreshFAQData,
                child: Obx(() {
                  // Show loading indicator while fetching data
                  if (controller.isLoading.value &&
                      controller.allFAQItems.isEmpty) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: isDarkTheme ? Colors.white : Colors.blue,
                      ),
                    );
                  }

                  // Show empty state if no FAQs available
                  if (controller.allFAQItems.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.help_outline,
                              size: 64,
                              color: textColor.withValues(alpha: 0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No FAQs Available',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: textColor,
                                fontFamily: 'Enwallowify',
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Pull down to refresh and try again',
                              style: TextStyle(
                                fontSize: 14,
                                color: textColor.withValues(alpha: 0.7),
                                fontFamily: 'Enwallowify',
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // Show FAQ content
                  return controller.isAllTabSelected
                      ? GroupedFAQList(
                        groupedFAQs: controller.groupedFAQs,
                        isDarkTheme: isDarkTheme,
                        textColor: textColor,
                        onFAQToggle: controller.toggleFAQExpansion,
                        isFAQExpanded: controller.isFAQExpanded,
                      )
                      : FAQList(
                        faqs: controller.getCurrentFAQs(),
                        isDarkTheme: isDarkTheme,
                        textColor: textColor,
                        onFAQToggle: controller.toggleFAQExpansion,
                        isFAQExpanded: controller.isFAQExpanded,
                      );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
