import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:prince1025/core/common/styles/global_text_style.dart';
import 'package:prince1025/core/utils/constants/svg_path.dart';
import 'package:prince1025/features/profile/controllers/profile_controller.dart';

class ActionButtonsSection extends StatelessWidget {
  final ProfileController controller;
  final Color textColor;
  final Color? iconColor;
  final Color dividerColor;

  const ActionButtonsSection({
    required this.controller,
    required this.textColor,
    required this.iconColor,
    required this.dividerColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildActionRow(
          icon: SvgPath.faqSvg,
          label: 'FAQ',
          onTap: () {
            // Navigate to FAQ screen
            Get.toNamed('/faq');
          },
        ),
        _buildDivider(dividerColor),
        _buildActionRow(
          icon: SvgPath.contactSvg,
          label: 'Contact Support',
          onTap: () {
            // Navigate to Support screen
            Get.toNamed('/support');
          },
        ),
        _buildDivider(dividerColor),
        _buildActionRow(
          icon: SvgPath.termAndConditionSvg,
          label: 'Terms & Conditions',
          onTap: () {
            // Navigate to Terms screen
            Get.toNamed('/terms');
          },
        ),
      ],
    );
  }

  Widget _buildActionRow({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Row(
        children: [
          // svg icon
          SvgPicture.asset(
            icon,
            width: 20,
            height: 20,
            colorFilter:
                iconColor != null
                    ? ColorFilter.mode(iconColor!, BlendMode.srcIn)
                    : null,
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: getDMTextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
          const Spacer(),
          SvgPicture.asset(
            SvgPath.rightArrowSvg,
            width: 20,
            height: 20,
            colorFilter:
                iconColor != null
                    ? ColorFilter.mode(iconColor!, BlendMode.srcIn)
                    : null,
          ),
        ],
      ),
    );
  }

  Divider _buildDivider(Color dividerColor) {
    return Divider(color: dividerColor, thickness: 0.8, height: 8);
  }
}
