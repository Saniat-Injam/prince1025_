import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:prince1025/core/common/styles/global_text_style.dart';
import 'package:prince1025/core/utils/constants/colors.dart';
import 'package:prince1025/features/profile/widgets/custom_ev_button.dart';
import 'package:prince1025/features/profile/widgets/plan_feature_row.dart';

class ChangePlanSection extends StatelessWidget {
  final bool isDarkTheme;
  final VoidCallback onGoToMonthlyPlan;

  const ChangePlanSection({
    super.key,
    required this.isDarkTheme,
    required this.onGoToMonthlyPlan,
  });

  @override
  Widget build(BuildContext context) {
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
              color:
                  isDarkTheme
                      ? const Color(0xFFFFFFFF).withValues(alpha: 0.01)
                      : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    isDarkTheme
                        ? const Color(0xFFFFFFFF).withValues(alpha: 0.35)
                        : Colors.transparent,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Change Your Plan',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Get access to additional features and benefits with our monthly plan.',
                  style: getDMTextStyle(
                    fontSize: 16,
                    color:
                        isDarkTheme
                            ? AppColors.textdarkmode
                            : AppColors.textlightmode,
                  ),
                ),
                const SizedBox(height: 20),
                PlanFeatureRow(
                  feature: 'Access to all premium courses and workshops',
                  isDarkTheme: isDarkTheme,
                ),
                PlanFeatureRow(
                  feature: 'Exclusive meditation and manifestation videos',
                  isDarkTheme: isDarkTheme,
                ),
                PlanFeatureRow(
                  feature: 'Personal growth tracker and journal features',
                  isDarkTheme: isDarkTheme,
                ),
                const SizedBox(height: 20),
                CustomEVButton(
                  onPressed: onGoToMonthlyPlan,
                  text: 'Go To Monthly Plan',
                ),
                const SizedBox(height: 6),
                Center(
                  child: Text(
                    'Starting at \$${9.99.toStringAsFixed(2)}/month. Cancel anytime.',
                    style: getDMTextStyle(
                      fontSize: 12,
                      color:
                          isDarkTheme
                              ? AppColors.textdarkmode
                              : AppColors.textlightmode,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
