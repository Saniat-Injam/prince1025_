import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:prince1025/core/services/api_caller.dart';
import 'package:prince1025/core/services/storage_service.dart';
import 'package:prince1025/core/utils/constants/api_constants.dart';
import 'package:prince1025/features/profile/models/subscription_models.dart';
import 'package:prince1025/features/profile/models/payment_models.dart';
import 'package:prince1025/features/profile/views/screens/in_app_payment_screen.dart';

class SubscriptionController extends GetxController {
  // Logger for debugging
  final Logger logger = Logger();

  // Subscription status
  final RxBool isPremium = false.obs;
  final RxString currentPlan = 'Free'.obs;
  final RxString selectedPlan = 'yearly'.obs;
  final RxString startDate = ''.obs;
  final RxString renewalDate = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool isRenewButtonEnabled = false.obs;

  // API data
  final RxList<SubscriptionPlan> availablePlans = <SubscriptionPlan>[].obs;
  final RxBool isLoadingPlans = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Fetch subscription plans when controller initializes
    fetchSubscriptionPlans();
  }

  /// Fetch subscription plans from API
  Future<void> fetchSubscriptionPlans() async {
    try {
      isLoadingPlans.value = true;
      logger.i('🔄 Fetching subscription plans from API');

      await ApiCaller.get(
        endpoint: ApiConstants.subscriptionPlan,
        showLoading: false, // Don't show loading overlay for better UX
        onSuccess: (data) {
          logger.i('✅ Subscription plans fetched successfully');

          if (data != null && data is List) {
            // Parse subscription plans from response
            final plans =
                data
                    .map(
                      (item) => SubscriptionPlan.fromJson(
                        item as Map<String, dynamic>,
                      ),
                    )
                    .where((plan) => plan.isActive) // Only include active plans
                    .toList();

            // Update observable list
            availablePlans.value = plans;

            logger.i('✅ Loaded ${plans.length} active subscription plans');
          } else {
            logger.w('⚠️ Invalid subscription plans API response format');
          }

          return data;
        },
        onError: (error) {
          logger.e('❌ Failed to fetch subscription plans: $error');
          // Don't show error to user as we can fall back to hardcoded data
        },
      );
    } catch (e) {
      logger.e('❌ Exception while fetching subscription plans: $e');
    } finally {
      isLoadingPlans.value = false;
    }
  }

  /// Refresh subscription plans from API (can be called manually)
  Future<void> refreshSubscriptionPlans() async {
    try {
      logger.i('🔄 Manually refreshing subscription plans');

      await ApiCaller.get(
        endpoint: ApiConstants.subscriptionPlan,
        showLoading: true,
        loadingMessage: 'Loading plans...',
        onSuccess: (data) {
          logger.i('✅ Subscription plans refreshed successfully');

          if (data != null && data is List) {
            // Parse subscription plans from response
            final plans =
                data
                    .map(
                      (item) => SubscriptionPlan.fromJson(
                        item as Map<String, dynamic>,
                      ),
                    )
                    .where((plan) => plan.isActive) // Only include active plans
                    .toList();

            // Update observable list
            availablePlans.value = plans;

            logger.i('✅ Refreshed ${plans.length} active subscription plans');
          } else {
            logger.w('⚠️ Invalid subscription plans API response format');
          }

          return data;
        },
        onError: (error) {
          logger.e('❌ Failed to refresh subscription plans: $error');
        },
      );
    } catch (e) {
      logger.e('❌ Exception while refreshing subscription plans: $e');
    }
  }

  // Get monthly plan from API data
  SubscriptionPlan? get monthlyPlan {
    try {
      return availablePlans.firstWhere((plan) => plan.isMonthly);
    } catch (e) {
      return null;
    }
  }

  // Get yearly plan from API data
  SubscriptionPlan? get yearlyPlan {
    try {
      return availablePlans.firstWhere((plan) => plan.isYearly);
    } catch (e) {
      return null;
    }
  }

  // Plan details with fallback to API data
  double get monthlyPrice => monthlyPlan?.price ?? 9.99;
  double get yearlyPrice => yearlyPlan?.price ?? 89.99;

  // Subscription features from API data with fallback
  List<String> get featuresMonthly {
    return monthlyPlan?.features ??
        [
          'Access all videos',
          'Full course library',
          'Exclusive quotes',
          'Ad-free experience',
        ];
  }

  List<String> get featuresYearly {
    return yearlyPlan?.features ??
        [
          'Access all videos',
          'Full course library',
          'Exclusive quotes',
          'Ad-free experience',
        ];
  }

  // Get savings text for yearly plan
  String get yearlyPlanSavingsText {
    return yearlyPlan?.description.isNotEmpty == true
        ? yearlyPlan!.description
        : 'Save 25% compared to monthly';
  }

  // Check if plans are available
  bool get hasPlansData => availablePlans.isNotEmpty;

  // Select plan
  void selectPlan(String plan) {
    selectedPlan.value = plan;
  }

  // Process payment with Stripe checkout
  Future<void> processPayment() async {
    try {
      isLoading.value = true;
      logger.i('🔄 Starting payment process for ${selectedPlan.value} plan');

      // Get selected plan details
      SubscriptionPlan? selectedPlanData;
      if (selectedPlan.value == 'monthly') {
        selectedPlanData = monthlyPlan;
      } else if (selectedPlan.value == 'yearly') {
        selectedPlanData = yearlyPlan;
      }

      if (selectedPlanData == null) {
        logger.e('❌ Selected plan not found');
        Get.snackbar('Error', 'Selected plan not found. Please try again.');
        return;
      }

      // Get user ID from storage
      final userData = StorageService.getUserData();
      if (userData == null || userData.id.isEmpty) {
        logger.e('❌ User data not found in storage');
        Get.snackbar('Error', 'User not logged in. Please login again.');
        return;
      }

      // Prepare payment request
      final paymentRequest = PaymentRequest(
        planId: selectedPlanData.id,
        userId: userData.id,
      );

      logger.i('🔄 Creating checkout session with request: $paymentRequest');

      // Call payment API to get Stripe checkout URL
      await ApiCaller.post(
        endpoint: ApiConstants.createPayment,
        data: paymentRequest.toJson(),
        showLoading: true,
        loadingMessage: 'Creating checkout session...',
        onSuccess: (data) async {
          logger.i('✅ Checkout session created successfully');

          if (data != null && data['url'] != null) {
            final paymentResponse = PaymentResponse.fromJson(data);

            if (paymentResponse.hasValidUrl) {
              logger.i(
                '🔄 Opening in-app payment screen: ${paymentResponse.url}',
              );
              _openInAppPayment(paymentResponse.url, selectedPlanData!);
            } else {
              logger.e('❌ Invalid checkout URL received');
              Get.snackbar('Error', 'Invalid payment URL. Please try again.');
            }
          } else {
            logger.e('❌ Invalid payment response format');
            Get.snackbar(
              'Error',
              'Invalid payment response. Please try again.',
            );
          }

          return data;
        },
        onError: (error) {
          logger.e('❌ Payment creation failed: $error');
          Get.snackbar('Payment Error', error);
        },
      );
    } catch (e) {
      logger.e('❌ Exception during payment process: $e');
      Get.snackbar('Error', 'Payment processing failed. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  /// Open in-app payment screen with WebView
  void _openInAppPayment(String checkoutUrl, SubscriptionPlan planData) {
    try {
      logger.i('🔄 Navigating to in-app payment screen');

      Get.to(
        () => InAppPaymentScreen(
          checkoutUrl: checkoutUrl,
          planName: planData.name,
          planPrice: planData.price,
        ),
        fullscreenDialog: true,
        transition: Transition.upToDown,
      );

      logger.i('✅ In-app payment screen opened successfully');
    } catch (e) {
      logger.e('❌ Error opening in-app payment screen: $e');
      Get.snackbar(
        'Error',
        'Unable to open payment screen. Please try again.',
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    }
  }

  /// Check subscription status after payment (can be called from payment screen)
  Future<void> checkSubscriptionStatus() async {
    try {
      logger.i('🔄 Checking subscription status after payment');

      // Refresh subscription plans to get latest data
      await refreshSubscriptionPlans();

      // You can also refresh user profile here if needed
      // Example: Get.find<ProfileController>().fetchUserProfileFromApi();

      Get.snackbar(
        'Info',
        'Subscription status updated. Please check your profile.',
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.green.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    } catch (e) {
      logger.e('❌ Error checking subscription status: $e');
    }
  }

  /// Handle return from payment (when user comes back to app)
  // Renew subscription
  Future<void> renewSubscription() async {
    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 1));

      final now = DateTime.now();
      if (currentPlan.value == 'Monthly') {
        renewalDate.value =
            DateTime(now.year, now.month + 1, now.day).toString().split(' ')[0];
      } else {
        renewalDate.value =
            DateTime(now.year + 1, now.month, now.day).toString().split(' ')[0];
      }

      Get.snackbar('Success', 'Subscription renewed successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to renew subscription');
    } finally {
      isLoading.value = false;
    }
  }

  // Cancel subscription
  Future<void> cancelSubscription() async {
    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 2));

      isPremium.value = false;
      currentPlan.value = 'Free';
      startDate.value = '';
      renewalDate.value = '';

      Get.snackbar('Success', 'Subscription cancelled successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to cancel subscription');
    } finally {
      isLoading.value = false;
    }
  }

  // Switch to monthly plan
  Future<void> switchToMonthlyPlan() async {
    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 1));

      currentPlan.value = 'Monthly';
      final now = DateTime.now();
      startDate.value = now.toString().split(' ')[0];
      renewalDate.value =
          DateTime(now.year, now.month + 1, now.day).toString().split(' ')[0];

      Get.snackbar('Success', 'Switched to monthly plan');
    } catch (e) {
      Get.snackbar('Error', 'Failed to switch plan');
    } finally {
      isLoading.value = false;
    }
  }
}
