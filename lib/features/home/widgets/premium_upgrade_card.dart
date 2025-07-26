import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:prince1025/core/common/styles/global_text_style.dart';
import 'package:prince1025/core/utils/constants/colors.dart';
import 'package:prince1025/core/utils/constants/svg_path.dart';
import 'package:prince1025/features/home/controllers/home_controller.dart';
import 'package:prince1025/features/profile/widgets/custom_ev_button.dart';

class PremiumUpgradeCard extends StatelessWidget {
  final HomeController controller;
  final bool isDarkTheme;
  final Color textColor;

  const PremiumUpgradeCard({
    super.key,
    required this.controller,
    required this.isDarkTheme,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Premium Content Card
        _buildPremiumCard(),
      ],
    );
  }

  Widget _buildPremiumCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
      decoration: BoxDecoration(
        color: isDarkTheme ? Color(0xFF071123) : Colors.white,
        gradient:
            !isDarkTheme
                ? LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [const Color(0xFFDDF5FF), Colors.white],
                )
                : null,
        borderRadius: BorderRadius.circular(12),
        boxShadow:
            !isDarkTheme
                ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    offset: const Offset(0, 4),
                    blurRadius: 8,
                  ),
                ]
                : null,
        border:
            isDarkTheme
                ? Border.all(color: const Color(0xFF133663), width: 0.8)
                : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Crown icon and title
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Semantics(
                label: 'Crown icon - Premium Membership',
                child: SvgPicture.asset(SvgPath.crownSvg),
              ),
              const SizedBox(width: 12),
              Text(
                'Premium Membership',
                style: TextStyle(
                  fontFamily: 'Enwallowify',
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: isDarkTheme ? Colors.white : AppColors.primaryDarkBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Premium features list
          _buildFeatureItem('Access to all premium courses and workshops'),
          const SizedBox(height: 12),
          _buildFeatureItem('Exclusive meditation and manifestation videos'),
          const SizedBox(height: 12),
          _buildFeatureItem('Personal growth tracker and journal features'),
          const SizedBox(height: 24),

          // Subscribe button
          CustomEVButton(
            onPressed: () => controller.navigateToSubscription(),
            text: 'Subscribe Now',
          ),
          const SizedBox(height: 8),

          // Pricing info
          Center(
            child: Text(
              'Starting at \$9.99/month. Cancel anytime.',
              style: getDMTextStyle(
                fontSize: 12,
                color:
                    isDarkTheme
                        ? const Color(0xFFBEBEBE)
                        : const Color(0xFF2E2E2E),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          isDarkTheme ? SvgPath.checkDarkSvg : SvgPath.checkLightSvg,
          width: 24,
          height: 24,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: getDMTextStyle(
              fontSize: 14,
              color:
                  isDarkTheme
                      ? Colors.white.withValues(alpha: 0.9)
                      : Colors.black.withValues(alpha: 0.9),
            ),
          ),
        ),
      ],
    );
  }
}
