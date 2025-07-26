import 'package:flutter/material.dart';
import 'package:prince1025/core/common/styles/global_text_style.dart';

class IssueTypeDropdown extends StatelessWidget {
  final String selectedIssue;
  final List<String> issueTypes;
  final Function(String?) onChanged;
  final bool isDarkTheme;
  final Color textColor;

  const IssueTypeDropdown({
    super.key,
    required this.selectedIssue,
    required this.issueTypes,
    required this.onChanged,
    required this.isDarkTheme,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Issue Type',
          style: getDMTextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color:
                isDarkTheme
                    ? Colors.black.withValues(alpha: 0.1)
                    : Colors.white,
            border: Border.all(
              color:
                  isDarkTheme
                      ? Colors.white.withValues(alpha: 0.5)
                      : Colors.grey.shade400,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedIssue,
              isExpanded: true,
              dropdownColor: isDarkTheme ? Colors.grey[900] : Colors.white,
              style: getDMTextStyle(color: textColor),
              items:
                  issueTypes
                      .map(
                        (type) =>
                            DropdownMenuItem(value: type, child: Text(type)),
                      )
                      .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
