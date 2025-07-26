import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prince1025/features/profile/widgets/faq_item.dart';
import 'package:prince1025/features/profile/widgets/faq_section_header.dart';

class GroupedFAQList extends StatelessWidget {
  final List<Map<String, dynamic>> groupedFAQs;
  final bool isDarkTheme;
  final Color textColor;
  final Function(String) onFAQToggle;
  final bool Function(String) isFAQExpanded;

  const GroupedFAQList({
    super.key,
    required this.groupedFAQs,
    required this.isDarkTheme,
    required this.textColor,
    required this.onFAQToggle,
    required this.isFAQExpanded,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: _getTotalItemCount(),
      itemBuilder: (context, index) {
        return _buildItem(index);
      },
    );
  }

  int _getTotalItemCount() {
    int count = 0;
    for (var section in groupedFAQs) {
      count++; // Section header
      count += (section['faqs'] as List<Map<String, String>>).length; // FAQs
    }
    return count;
  }

  Widget _buildItem(int index) {
    int currentIndex = 0;

    for (var section in groupedFAQs) {
      // Check if this is the section header
      if (currentIndex == index) {
        return Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
          child: FAQSectionHeader(
            title: section['title'] as String,
            isDarkTheme: isDarkTheme,
            textColor: textColor,
          ),
        );
      }
      currentIndex++;

      // Check if this is one of the FAQs in this section
      final faqs = section['faqs'] as List<Map<String, String>>;
      for (var faq in faqs) {
        if (currentIndex == index) {
          final question = faq['question'] ?? '';
          final answer = faq['answer'] ?? '';

          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Obx(
              () => FAQItem(
                question: question,
                answer: answer,
                isExpanded: isFAQExpanded(question),
                onTap: () => onFAQToggle(question),
                isDarkTheme: isDarkTheme,
                textColor: textColor,
              ),
            ),
          );
        }
        currentIndex++;
      }
    }

    return const SizedBox.shrink();
  }
}
