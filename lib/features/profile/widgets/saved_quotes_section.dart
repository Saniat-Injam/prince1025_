import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prince1025/core/common/styles/global_text_style.dart';
import 'package:prince1025/core/utils/constants/colors.dart';
import 'package:prince1025/core/utils/constants/svg_path.dart';
import 'package:prince1025/features/quotes/controllers/quotes_controller.dart';

class SavedQuotesSection extends StatelessWidget {
  final Color textColor;
  final bool isDarkTheme;

  const SavedQuotesSection({
    required this.textColor,
    required this.isDarkTheme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Get the quotes controller to check for favorite quotes
    final quotesController = Get.put(QuotesController());

    return Obx(() {
      final favoriteQuote = quotesController.latestFavoriteQuote;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Saved Quotes',
                style: TextStyle(
                  fontFamily: 'Enwallowify',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              GestureDetector(
                onTap: () => Get.toNamed('/quotes'),
                child: Text(
                  'See All',
                  style: getDMTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isDarkTheme ? Color(0xFFC7B0F5) : Color(0xFF005E89),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Quote Card - show favorite quote if available, otherwise default
          _buildQuoteCard(favoriteQuote),
        ],
      );
    });
  }

  Widget _buildQuoteCard(Map<String, String>? favoriteQuote) {
    final quote =
        favoriteQuote?['quote'] ??
        'The only limit to our realization of tomorrow will be our doubts of today';
    final author = favoriteQuote?['author'] ?? 'Franklin D. Roosevelt';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkTheme ? Color(0xFF071123) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow:
            !isDarkTheme
                ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    offset: const Offset(0, 4),
                    blurRadius: 8,
                  ),
                ]
                : null,
        border:
            isDarkTheme
                ? Border.all(color: const Color(0xFF133663), width: 0.8)
                : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quote Icon and Heart
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset(
                isDarkTheme
                    ? SvgPath.saveQuotesDarkSvg
                    : SvgPath.saveQuotesLightSvg,
                width: 32,
                height: 32,
              ),
              Icon(Icons.favorite, color: Colors.red, size: 20),
            ],
          ),
          const SizedBox(height: 16),

          // Quote Text
          Text(
            '"$quote"',
            style: GoogleFonts.dmSans(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color:
                  isDarkTheme ? Color(0xFFBEBEBE) : AppColors.primaryDarkBlue,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 12),

          // Author
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '- $author',
              style: getDMTextStyle(
                fontSize: 12,
                color: isDarkTheme ? Color(0xFFBEBEBE) : Color(0xFF2E2E2E),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
