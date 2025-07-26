import 'package:flutter/material.dart';
import 'package:prince1025/features/profile/widgets/custom_tab_button.dart';

class FAQTabBar extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final Function(int) onTabSelected;
  final bool isDarkTheme;

  const FAQTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.isDarkTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children:
              tabs.asMap().entries.map((entry) {
                final index = entry.key;
                final title = entry.value;

                return Padding(
                  padding: EdgeInsets.only(
                    right: index < tabs.length - 1 ? 8.0 : 0,
                  ),
                  child: CustomTabButton(
                    title: title,
                    isSelected: selectedIndex == index,
                    onTap: () => onTabSelected(index),
                    isDarkTheme: isDarkTheme,
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }
}
