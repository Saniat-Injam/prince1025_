import 'package:flutter/material.dart';
import 'package:prince1025/core/common/styles/global_text_style.dart';
import 'package:prince1025/core/utils/constants/colors.dart';
import 'package:prince1025/core/common/widgets/custom_container.dart';

class FAQItem extends StatelessWidget {
  final String question;
  final String answer;
  final bool isExpanded;
  final VoidCallback onTap;
  final bool isDarkTheme;
  final Color textColor;

  const FAQItem({
    super.key,
    required this.question,
    required this.answer,
    required this.isExpanded,
    required this.onTap,
    required this.isDarkTheme,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: CustomContainer(
        isDarkTheme: isDarkTheme,
        child: ExpansionTile(
          title: Text(
            question,
            style: getDMTextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDarkTheme ? AppColors.textdarkmode : Colors.black,
            ),
          ),
          trailing: Icon(
            isExpanded ? Icons.remove : Icons.add,
            color: isDarkTheme ? Colors.white : null,
          ),
          onExpansionChanged: (expanded) => onTap(),
          initiallyExpanded: isExpanded,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(
                answer,
                style: getDMTextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isDarkTheme ? Color(0xFFBEBEBE) : Color(0xFF939393),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
