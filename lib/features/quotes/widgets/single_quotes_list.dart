import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:prince1025/features/quotes/widgets/quote_item.dart';
import 'package:prince1025/features/profile/widgets/custom_ev_button.dart';

class SingleQuotesList extends StatelessWidget {
  final List<Map<String, String>> quotes;
  final bool isDarkTheme;
  final Color textColor;
  final Function(String, String) onQuoteToggle;
  final bool Function(String, String) isQuoteLiked;
  final VoidCallback onPremiumButtonTap;

  const SingleQuotesList({
    super.key,
    required this.quotes,
    required this.isDarkTheme,
    required this.textColor,
    required this.onQuoteToggle,
    required this.isQuoteLiked,
    required this.onPremiumButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Show the single quote
          if (quotes.isNotEmpty)
            Obx(
              () => QuoteItem(
                quote: quotes[0]['quote'] ?? '',
                author: quotes[0]['author'] ?? '',
                isLiked: isQuoteLiked(
                  quotes[0]['quote'] ?? '',
                  quotes[0]['author'] ?? '',
                ),
                onLikeTap:
                    () => onQuoteToggle(
                      quotes[0]['quote'] ?? '',
                      quotes[0]['author'] ?? '',
                    ),
                isDarkTheme: isDarkTheme,
                textColor: textColor,
              ),
            ),

          const SizedBox(height: 24),

          // Premium button
          CustomEVButton(
            onPressed: onPremiumButtonTap,
            text: 'More Quotes With Premium',
          ),
        ],
      ),
    );
  }
}
