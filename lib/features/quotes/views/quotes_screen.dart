import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prince1025/core/common/widgets/custom_app_bar.dart';
import 'package:prince1025/core/utils/constants/image_path.dart';
import 'package:prince1025/features/quotes/controllers/quotes_controller.dart';
import 'package:prince1025/features/quotes/widgets/quotes_tab_bar.dart';
import 'package:prince1025/features/quotes/widgets/grouped_quotes_list.dart';
import 'package:prince1025/features/quotes/widgets/single_quotes_list.dart';

class QuotesScreen extends StatelessWidget {
  const QuotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(QuotesController());
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
        appBar: CustomAppBar(
          showBackButton: false,
          automaticallyImplyLeading: false,
          title: 'Quotes',
          backgroundColor: isDarkTheme ? Colors.transparent : Colors.white,
          foregroundColor: isDarkTheme ? Colors.white : null,
          elevation: 0,
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Custom Tab Bar
              Obx(
                () => QuotesTabBar(
                  tabs: controller.tabs,
                  selectedIndex: controller.selectedTabIndex.value,
                  onTabSelected: controller.selectTab,
                  isDarkTheme: isDarkTheme,
                ),
              ),

              // Quotes List
              Expanded(
                child: Obx(
                  () =>
                      controller.isAllTabSelected
                          ? GroupedQuotesList(
                            groupedQuotes: controller.groupedQuotes,
                            isDarkTheme: isDarkTheme,
                            textColor: textColor,
                            onQuoteToggle: controller.toggleQuoteLike,
                            isQuoteLiked: controller.isQuoteLiked,
                            onPremiumButtonTap:
                                controller.navigateToSubscription,
                          )
                          : SingleQuotesList(
                            quotes: controller.getCurrentQuotes(),
                            isDarkTheme: isDarkTheme,
                            textColor: textColor,
                            onQuoteToggle: controller.toggleQuoteLike,
                            isQuoteLiked: controller.isQuoteLiked,
                            onPremiumButtonTap:
                                controller.navigateToSubscription,
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
