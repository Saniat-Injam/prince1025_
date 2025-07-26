import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prince1025/features/profile/widgets/faq_item.dart';

class FAQList extends StatelessWidget {
  final List<Map<String, String>> faqs;
  final bool isDarkTheme;
  final Color textColor;
  final Function(String) onFAQToggle;
  final bool Function(String) isFAQExpanded;

  const FAQList({
    super.key,
    required this.faqs,
    required this.isDarkTheme,
    required this.textColor,
    required this.onFAQToggle,
    required this.isFAQExpanded,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: faqs.length,
      itemBuilder: (context, index) {
        final faq = faqs[index];
        final question = faq['question'] ?? '';
        final answer = faq['answer'] ?? '';

        return Obx(() => FAQItem(
          question: question,
          answer: answer,
          isExpanded: isFAQExpanded(question),
          onTap: () => onFAQToggle(question),
          isDarkTheme: isDarkTheme,
          textColor: textColor,
        ));
      },
    );
  }
}
