import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:prince1025/core/services/api_caller.dart';
import 'package:prince1025/core/utils/constants/api_constants.dart';
import 'package:prince1025/features/profile/models/terms_models.dart';

/// Controller for Terms & Conditions screen
/// Manages API calls and data state for terms and conditions
class TermsConditionsController extends GetxController {
  // Logger for debugging
  final Logger logger = Logger();

  // Loading state
  final RxBool isLoading = false.obs;

  // Terms and Conditions data from API
  final RxList<TermsCategory> termsCategories = <TermsCategory>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Fetch terms data when controller initializes
    fetchTermsData();
  }

  /// Fetch Terms & Conditions data from API
  Future<void> fetchTermsData() async {
    try {
      isLoading.value = true;
      logger.i('🔄 Fetching Terms & Conditions data from API');

      await ApiCaller.get(
        endpoint: ApiConstants.termsAndConditions,
        showLoading: false, // Don't show loading overlay for better UX
        onSuccess: (data) {
          logger.i('✅ Terms & Conditions data fetched successfully');

          if (data != null && data is List) {
            // Parse terms categories from response
            final categories =
                data
                    .map(
                      (item) =>
                          TermsCategory.fromJson(item as Map<String, dynamic>),
                    )
                    .toList();

            // Update observable list
            termsCategories.value = categories;

            logger.i('✅ Loaded ${categories.length} terms categories');
          } else {
            logger.w('⚠️ Invalid Terms & Conditions API response format');
          }

          return data;
        },
        onError: (error) {
          logger.e('❌ Failed to fetch Terms & Conditions data: $error');
          // Don't show error to user as we can fall back to cached data
        },
      );
    } catch (e) {
      logger.e('❌ Exception while fetching Terms & Conditions data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh Terms & Conditions data from API (can be called manually)
  Future<void> refreshTermsData() async {
    try {
      logger.i('🔄 Manually refreshing Terms & Conditions data');

      await ApiCaller.get(
        endpoint: ApiConstants.termsAndConditions,
        showLoading: true,
        loadingMessage: 'Loading Terms & Conditions...',
        onSuccess: (data) {
          logger.i('✅ Terms & Conditions data refreshed successfully');

          if (data != null && data is List) {
            // Parse terms categories from response
            final categories =
                data
                    .map(
                      (item) =>
                          TermsCategory.fromJson(item as Map<String, dynamic>),
                    )
                    .toList();

            // Update observable list
            termsCategories.value = categories;

            logger.i('✅ Refreshed ${categories.length} terms categories');
          } else {
            logger.w('⚠️ Invalid Terms & Conditions API response format');
          }

          return data;
        },
        onError: (error) {
          logger.e('❌ Failed to refresh Terms & Conditions data: $error');
        },
      );
    } catch (e) {
      logger.e('❌ Exception while refreshing Terms & Conditions data: $e');
    }
  }

  /// Check if terms data is available
  bool get hasTermsData => termsCategories.isNotEmpty;

  /// Get terms category by index
  TermsCategory? getTermsCategoryByIndex(int index) {
    if (index >= 0 && index < termsCategories.length) {
      return termsCategories[index];
    }
    return null;
  }

  /// Get terms category by ID
  TermsCategory? getTermsCategoryById(String id) {
    try {
      return termsCategories.firstWhere((category) => category.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get total number of terms categories
  int get totalCategories => termsCategories.length;
}
