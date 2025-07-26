import 'package:flutter/material.dart';
import 'package:prince1025/features/quotes/widgets/quote_item.dart';

class QuotesList extends StatelessWidget {
  final List<Map<String, String>> quotes;
  final bool isDarkTheme;
  final Color textColor;
  final Function(String, String) onQuoteToggle;
  final bool Function(String, String) isQuoteLiked;

  const QuotesList({
    super.key,
    required this.quotes,
    required this.isDarkTheme,
    required this.textColor,
    required this.onQuoteToggle,
    required this.isQuoteLiked,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: quotes.length,
      itemBuilder: (context, index) {
        final quote = quotes[index];
        final quoteText = quote['quote'] ?? '';
        final author = quote['author'] ?? '';

        return QuoteItem(
          quote: quoteText,
          author: author,
          isLiked: isQuoteLiked(quoteText, author),
          onLikeTap: () => onQuoteToggle(quoteText, author),
          isDarkTheme: isDarkTheme,
          textColor: textColor,
        );
      },
    );
  }
}
