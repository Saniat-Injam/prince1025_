import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:prince1025/core/utils/constants/colors.dart';
import 'package:prince1025/core/utils/constants/svg_path.dart';
import 'package:prince1025/features/profile/controllers/profile_controller.dart';
import 'package:prince1025/features/profile/widgets/plan_detail_row.dart';

class CurrentPlanDetailsWidget extends StatelessWidget {
  final bool isDarkTheme;

  const CurrentPlanDetailsWidget({super.key, required this.isDarkTheme});

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find<ProfileController>();

    return Obx(() {
      final user = profileController.userModel.value;
      final currentSubscription = user?.currentSubscription;

      if (currentSubscription == null) {
        return _buildNoSubscriptionWidget();
      }

      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow:
              isDarkTheme
                  ? null
                  : [
                    BoxShadow(
                      color: Color(0xFF323131).withValues(alpha: 0.12),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDarkTheme ? const Color(0xFF071123) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color:
                      isDarkTheme
                          ? const Color(0xFF133663)
                          : Colors.transparent,
                  width: 1,
                ),
                boxShadow:
                    isDarkTheme
                        ? [
                          BoxShadow(
                            color: const Color(
                              0xFF323131,
                            ).withValues(alpha: 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 0),
                            spreadRadius: 0,
                          ),
                        ]
                        : null,
              ),
              child: Column(
                children: [
                  _buildPlanHeader(currentSubscription),
                  const SizedBox(height: 20),
                  PlanDetailRow(
                    label: 'Start Date',
                    value: currentSubscription.formattedStartDate,
                    isDarkTheme: isDarkTheme,
                  ),
                  PlanDetailRow(
                    label: 'Next Renewal',
                    value: currentSubscription.formattedEndDate,
                    isDarkTheme: isDarkTheme,
                  ),
                  PlanDetailRow(
                    label: 'Price',
                    value: currentSubscription.plan?.formattedPrice ?? 'N/A',
                    isDarkTheme: isDarkTheme,
                  ),
                  PlanDetailRow(
                    label: 'Billing cycle',
                    value: currentSubscription.plan?.planTypeDisplay ?? 'N/A',
                    isDarkTheme: isDarkTheme,
                  ),
                  PlanDetailRow(
                    label: 'Days Remaining',
                    value: '${currentSubscription.daysRemaining} days',
                    isDarkTheme: isDarkTheme,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildPlanHeader(currentSubscription) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            currentSubscription.plan?.name ?? 'Premium Plan',
            style: TextStyle(
              fontFamily: 'Enwallowify',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color:
                  isDarkTheme
                      ? AppColors.textdarkmode
                      : AppColors.textlightmode,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color:
                isDarkTheme
                    ? Colors.white
                    : Colors.green.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset(
            width: 16,
            height: 16,
            isDarkTheme ? SvgPath.checkDarkSvg : SvgPath.checkLightSvg,
            colorFilter: ColorFilter.mode(
              isDarkTheme ? Colors.black : Colors.green,
              BlendMode.srcIn,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNoSubscriptionWidget() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkTheme ? const Color(0xFF071123) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkTheme ? const Color(0xFF133663) : Colors.transparent,
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          'No active subscription found',
          style: TextStyle(
            fontFamily: 'Enwallowify',
            fontSize: 16,
            color:
                isDarkTheme ? AppColors.textdarkmode : AppColors.textlightmode,
          ),
        ),
      ),
    );
  }
}
