import 'package:flutter/material.dart';

class FAQSectionHeader extends StatelessWidget {
  final String title;
  final bool isDarkTheme;
  final Color textColor;

  const FAQSectionHeader({
    super.key,
    required this.title,
    required this.isDarkTheme,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 20,
        color: textColor,
      ),
    );
  }
}
