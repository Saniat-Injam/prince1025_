import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:prince1025/core/services/api_caller.dart';
import 'package:prince1025/core/utils/constants/api_constants.dart';
import 'package:prince1025/features/profile/models/faq_models.dart';

class FAQController extends GetxController {
  // Logger for debugging
  final Logger logger = Logger();

  // Loading state
  final RxBool isLoading = false.obs;

  // FAQ data from API
  final RxList<FAQItem> allFAQItems = <FAQItem>[].obs;
  final RxList<String> availableCategories = <String>[].obs;

  // Current selected tab
  final RxInt selectedTabIndex = 0.obs;

  // Map to track expanded state of each FAQ
  final RxMap<String, bool> expandedItems = <String, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    // Fetch FAQ data when controller initializes
    fetchFAQData();
  }

  /// Fetch FAQ data from API
  Future<void> fetchFAQData() async {
    try {
      isLoading.value = true;
      logger.i('🔄 Fetching FAQ data from API');

      await ApiCaller.get(
        endpoint: ApiConstants.faq,
        showLoading: false, // Don't show loading overlay for better UX
        onSuccess: (data) {
          logger.i('✅ FAQ data fetched successfully');

          if (data != null && data is List) {
            // Parse FAQ items from response
            final faqItems =
                data
                    .map(
                      (item) => FAQItem.fromJson(item as Map<String, dynamic>),
                    )
                    .toList();

            // Update observable list
            allFAQItems.value = faqItems;

            // Extract unique categories and update tabs
            final categories =
                faqItems.map((item) => item.category.name).toSet().toList();

            availableCategories.value = categories;

            logger.i(
              '✅ Loaded ${faqItems.length} FAQ items with ${categories.length} categories',
            );
          } else {
            logger.w('⚠️ Invalid FAQ API response format');
          }

          return data;
        },
        onError: (error) {
          logger.e('❌ Failed to fetch FAQ data: $error');
          // Don't show error to user as we can fall back to cached data
        },
      );
    } catch (e) {
      logger.e('❌ Exception while fetching FAQ data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh FAQ data from API (can be called manually)
  Future<void> refreshFAQData() async {
    try {
      logger.i('🔄 Manually refreshing FAQ data');

      await ApiCaller.get(
        endpoint: ApiConstants.faq,
        showLoading: true,
        loadingMessage: 'Loading FAQs...',
        onSuccess: (data) {
          logger.i('✅ FAQ data refreshed successfully');

          if (data != null && data is List) {
            // Parse FAQ items from response
            final faqItems =
                data
                    .map(
                      (item) => FAQItem.fromJson(item as Map<String, dynamic>),
                    )
                    .toList();

            // Update observable list
            allFAQItems.value = faqItems;

            // Extract unique categories and update tabs
            final categories =
                faqItems.map((item) => item.category.name).toSet().toList();

            availableCategories.value = categories;

            logger.i(
              '✅ Refreshed ${faqItems.length} FAQ items with ${categories.length} categories',
            );
          } else {
            logger.w('⚠️ Invalid FAQ API response format');
          }

          return data;
        },
        onError: (error) {
          logger.e('❌ Failed to refresh FAQ data: $error');
        },
      );
    } catch (e) {
      logger.e('❌ Exception while refreshing FAQ data: $e');
    }
  }

  // Dynamic tab titles based on available categories
  List<String> get tabs {
    final baseTabs = ['All'];
    baseTabs.addAll(availableCategories);
    return baseTabs;
  }

  // Select tab
  void selectTab(int index) {
    selectedTabIndex.value = index;
  }

  // Toggle FAQ expansion
  void toggleFAQExpansion(String question) {
    expandedItems[question] = !(expandedItems[question] ?? false);
  }

  // Check if FAQ is expanded
  bool isFAQExpanded(String question) {
    return expandedItems[question] ?? false;
  }

  // Get FAQs for a specific category
  List<FAQItem> getFAQsByCategory(String categoryName) {
    return allFAQItems
        .where(
          (item) =>
              item.category.name.toLowerCase() == categoryName.toLowerCase(),
        )
        .toList();
  }

  // Convert FAQItem list to legacy format for existing widgets
  List<Map<String, String>> _convertToLegacyFormat(List<FAQItem> faqItems) {
    return faqItems
        .map((item) => {'question': item.question, 'answer': item.answer})
        .toList();
  }

  // Get FAQs based on selected tab (legacy format for existing widgets)
  List<Map<String, String>> getCurrentFAQs() {
    if (selectedTabIndex.value == 0) {
      // All FAQs
      return _convertToLegacyFormat(allFAQItems);
    } else {
      // Specific category
      final categoryIndex =
          selectedTabIndex.value - 1; // Subtract 1 for "All" tab
      if (categoryIndex < availableCategories.length) {
        final categoryName = availableCategories[categoryIndex];
        final categoryFAQs = getFAQsByCategory(categoryName);
        return _convertToLegacyFormat(categoryFAQs);
      }
    }
    return [];
  }

  // Get grouped FAQs for "All" tab with section titles (legacy format for existing widgets)
  List<Map<String, dynamic>> get groupedFAQs {
    final grouped = <Map<String, dynamic>>[];

    for (final category in availableCategories) {
      final categoryFAQs = getFAQsByCategory(category);
      if (categoryFAQs.isNotEmpty) {
        grouped.add({
          'type': 'section',
          'title': category,
          'faqs': _convertToLegacyFormat(categoryFAQs),
        });
      }
    }

    return grouped;
  }

  // Check if current tab is "All" tab
  bool get isAllTabSelected => selectedTabIndex.value == 0;
}
