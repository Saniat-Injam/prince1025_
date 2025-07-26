import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prince1025/core/common/styles/global_text_style.dart';
import 'package:prince1025/core/common/widgets/custom_container.dart';
import 'package:prince1025/core/utils/constants/colors.dart';
import 'package:prince1025/core/utils/constants/svg_path.dart';

class QuoteItem extends StatelessWidget {
  final String quote;
  final String author;
  final bool isLiked;
  final VoidCallback onLikeTap;
  final bool isDarkTheme;
  final Color textColor;

  const QuoteItem({
    super.key,
    required this.quote,
    required this.author,
    required this.isLiked,
    required this.onLikeTap,
    required this.isDarkTheme,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      isDarkTheme: isDarkTheme,
      borderRadius: 12,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quote icon and heart
            Row(
              children: [
                SvgPicture.asset(
                  isDarkTheme
                      ? SvgPath.saveQuotesDarkSvg
                      : SvgPath.saveQuotesLightSvg,
                  width: 32,
                  height: 32,
                ),
                const Spacer(),
                GestureDetector(
                  onTap: onLikeTap,
                  child: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color:
                        isLiked
                            ? Colors.red
                            : (isDarkTheme ? Colors.white70 : Colors.grey),
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Quote text
            Text(
              '"$quote"',
              style: GoogleFonts.dmSans(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDarkTheme ? Colors.white : AppColors.primaryDarkBlue,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 12),

            // Author
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(width: 8),
                Text(
                  '- $author',
                  style: getDMTextStyle(
                    fontSize: 12,
                    color: isDarkTheme ? Colors.white : Color(0xFF2E2E2E),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
