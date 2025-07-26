import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:prince1025/core/common/styles/global_text_style.dart';
import 'package:prince1025/core/utils/constants/colors.dart';
import 'package:prince1025/core/utils/constants/svg_path.dart';

class PlanFeatureRow extends StatelessWidget {
  final String feature;
  final bool isDarkTheme;

  const PlanFeatureRow({
    super.key,
    required this.feature,
    required this.isDarkTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SvgPicture.asset(
            isDarkTheme ? SvgPath.checkDarkSvg : SvgPath.checkLightSvg,
            width: 20,
            height: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              feature,
              style: getDMTextStyle(
                color:
                    isDarkTheme
                        ? AppColors.textdarkmode
                        : AppColors.textlightmode,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
