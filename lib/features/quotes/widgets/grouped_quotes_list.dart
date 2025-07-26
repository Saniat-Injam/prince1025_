import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:prince1025/features/quotes/widgets/quote_item.dart';
import 'package:prince1025/features/profile/widgets/custom_ev_button.dart';

class GroupedQuotesList extends StatelessWidget {
  final List<Map<String, dynamic>> groupedQuotes;
  final bool isDarkTheme;
  final Color textColor;
  final Function(String, String) onQuoteToggle;
  final bool Function(String, String) isQuoteLiked;
  final VoidCallback? onPremiumButtonTap;

  const GroupedQuotesList({
    super.key,
    required this.groupedQuotes,
    required this.isDarkTheme,
    required this.textColor,
    required this.onQuoteToggle,
    required this.isQuoteLiked,
    this.onPremiumButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount:
          groupedQuotes.length +
          (onPremiumButtonTap != null ? 1 : 0), // Add space for premium button
      itemBuilder: (context, index) {
        // Check if this is the premium button item
        if (index == groupedQuotes.length && onPremiumButtonTap != null) {
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: CustomEVButton(
              onPressed: onPremiumButtonTap!,
              text: 'More Quotes With Premium',
            ),
          );
        }

        final section = groupedQuotes[index];
        final title = section['title'] ?? '';
        final quotes = List<Map<String, String>>.from(section['quotes'] ?? []);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Title
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
              child: Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Enwallowify',
                ),
              ),
            ),

            // Show only first quote for free users
            Obx(
              () => QuoteItem(
                quote: quotes.isNotEmpty ? quotes[0]['quote'] ?? '' : '',
                author: quotes.isNotEmpty ? quotes[0]['author'] ?? '' : '',
                isLiked:
                    quotes.isNotEmpty
                        ? isQuoteLiked(
                          quotes[0]['quote'] ?? '',
                          quotes[0]['author'] ?? '',
                        )
                        : false,
                onLikeTap:
                    quotes.isNotEmpty
                        ? () => onQuoteToggle(
                          quotes[0]['quote'] ?? '',
                          quotes[0]['author'] ?? '',
                        )
                        : () {},
                isDarkTheme: isDarkTheme,
                textColor: textColor,
              ),
            ),

            const SizedBox(height: 24),
          ],
        );
      },
    );
  }
}
