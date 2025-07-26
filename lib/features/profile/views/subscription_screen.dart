import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prince1025/core/common/widgets/custom_app_bar.dart';
import 'package:prince1025/core/utils/constants/colors.dart';
import 'package:prince1025/features/profile/controllers/profile_controller.dart';
import 'package:prince1025/features/profile/controllers/subscription_controller.dart';
import 'package:prince1025/features/profile/widgets/custom_ev_button.dart';
import 'package:prince1025/features/profile/widgets/subscription_header_section.dart';
import 'package:prince1025/features/profile/widgets/subscription_plan_card.dart';
import 'package:prince1025/features/profile/widgets/subscribed_view_header.dart';
import 'package:prince1025/features/profile/widgets/current_plan_details_widget.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SubscriptionController());
    // profiile controller
    final profileController = Get.find<ProfileController>();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? const Color(0xFF1C0C35) : Colors.white;
    final textColor =
        isDarkMode ? AppColors.textdarkmode : AppColors.textlightmode;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(
        title: 'Subscription',
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        elevation: 0,
      ),
      body: Obx(
        () =>
            profileController.isPremium.value
                ? _buildSubscribedView(context, controller)
                : _buildUnsubscribedView(textColor, context, controller),
      ),
    );
  }

  Widget _buildUnsubscribedView(
    Color textColor,
    BuildContext context,
    SubscriptionController controller,
  ) {
    return RefreshIndicator(
      onRefresh: controller.refreshSubscriptionPlans,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Obx(() {
            // Show loading indicator while fetching plans
            if (controller.isLoadingPlans.value && !controller.hasPlansData) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Center(
                  child: CircularProgressIndicator(
                    color:
                        Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.blue,
                  ),
                ),
              );
            }

            // Show empty state if no plans available
            if (!controller.hasPlansData) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.credit_card_off,
                        size: 64,
                        color: textColor.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No Subscription Plans Available',
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

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                SubscriptionHeaderSection(textColor: textColor),

                // Monthly Plan Card (if available)
                if (controller.monthlyPlan != null)
                  Obx(
                    () => SubscriptionPlanCard(
                      isSelected: controller.selectedPlan.value == 'monthly',
                      title: controller.monthlyPlan!.name,
                      price: controller.monthlyPlan!.formattedPrice,
                      period: controller.monthlyPlan!.periodSuffix,
                      features: controller.monthlyPlan!.features,
                      onTap: () => controller.selectPlan('monthly'),
                    ),
                  ),

                if (controller.monthlyPlan != null &&
                    controller.yearlyPlan != null)
                  const SizedBox(height: 16),

                // Yearly Plan Card (if available)
                if (controller.yearlyPlan != null)
                  Obx(
                    () => SubscriptionPlanCard(
                      isSelected: controller.selectedPlan.value == 'yearly',
                      title: controller.yearlyPlan!.name,
                      price: controller.yearlyPlan!.formattedPrice,
                      period: controller.yearlyPlan!.periodSuffix,
                      features: controller.yearlyPlan!.features,
                      onTap: () => controller.selectPlan('yearly'),
                      isBestValue: true,
                      savingsText: controller.yearlyPlanSavingsText,
                    ),
                  ),

                const SizedBox(height: 32),

                CustomEVButton(
                  onPressed: () => controller.processPayment(),
                  text: 'Proceed',
                ),
                const SizedBox(height: 20),
              ],
            );
          }),
        ),
      ),
    );
  }

  // Subscribed View
  Widget _buildSubscribedView(
    BuildContext context,
    SubscriptionController subscriptionController,
  ) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final profileController = Get.find<ProfileController>();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subscription Status Badge
            _buildSubscriptionStatusBadge(isDarkTheme),
            const SizedBox(height: 16),

            // Header
            SubscribedViewHeader(isDarkTheme: isDarkTheme),

            // Current Plan Details
            CurrentPlanDetailsWidget(isDarkTheme: isDarkTheme),
            const SizedBox(height: 24),

            // Plan Features Section
            Obx(() {
              final currentSubscription =
                  profileController.userModel.value?.currentSubscription;
              final features = currentSubscription?.plan?.features ?? [];

              if (features.isNotEmpty) {
                return _buildPlanFeaturesSection(features, isDarkTheme);
              }
              return const SizedBox.shrink();
            }),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// Build subscription status badge
  Widget _buildSubscriptionStatusBadge(bool isDarkTheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Active Subscription',
            style: TextStyle(
              fontFamily: 'Enwallowify',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  /// Build plan features section with beautiful design
  Widget _buildPlanFeaturesSection(List<String> features, bool isDarkTheme) {
    final backgroundColor =
        isDarkTheme ? const Color(0xFF2A1A4A) : const Color(0xFFF8F9FA);
    final textColor =
        isDarkTheme ? AppColors.textdarkmode : AppColors.textlightmode;
    final borderColor =
        isDarkTheme
            ? Colors.purple.withValues(alpha: 0.3)
            : Colors.grey.withValues(alpha: 0.2);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Features Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.verified, color: Colors.green, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                'Your Plan Features',
                style: TextStyle(
                  fontFamily: 'Enwallowify',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Features List
          ...features.map((feature) => _buildFeatureItem(feature, textColor)),

          const SizedBox(height: 8),

          // Enjoy message
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.celebration, color: Colors.orange, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Enjoy all premium features with your active subscription!',
                    style: TextStyle(
                      fontFamily: 'Enwallowify',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: textColor.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build individual feature item
  Widget _buildFeatureItem(String feature, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 2),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.check_circle, color: Colors.green, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              feature,
              style: TextStyle(
                fontFamily: 'Enwallowify',
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: textColor,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
