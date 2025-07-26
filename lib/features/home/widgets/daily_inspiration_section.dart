import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prince1025/core/common/styles/global_text_style.dart';
import 'package:prince1025/core/utils/constants/colors.dart';
import 'package:prince1025/core/utils/constants/svg_path.dart';
import 'package:prince1025/features/bottom_nav/controllers/bottom_nav_controller.dart';
import 'package:prince1025/features/home/controllers/home_controller.dart';

class DailyInspirationSection extends StatelessWidget {
  final HomeController controller;
  final bool isDarkTheme;
  final Color textColor;

  const DailyInspirationSection({
    super.key,
    required this.controller,
    required this.isDarkTheme,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final BottomNavController bottomNavController = Get.put(
      BottomNavController(),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Daily Inspiration',
              style: TextStyle(
                fontFamily: 'Enwallowify',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            GestureDetector(
              onTap: () => bottomNavController.changeIndex(3),
              child: Text(
                'More Quotes',
                style: getDMTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color:
                      isDarkTheme
                          ? const Color(0xFFC7B0F5)
                          : const Color(0xFF005E89),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Quote Card
        _buildQuoteCard(),
      ],
    );
  }

  Widget _buildQuoteCard() {
    final quote =
        'The only limit to our realization of tomorrow will be our doubts of today';
    final author = 'Franklin D. Roosevelt';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkTheme ? const Color(0xFF071123) : Colors.white,
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
              ),
              // const Icon(Icons.favorite, color: Colors.red, size: 20),
            ],
          ),
          const SizedBox(height: 16),

          // Quote Text
          Text(
            '"$quote"',
            style: GoogleFonts.dmSans(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isDarkTheme ? const Color(0xFFBEBEBE) : AppColors.primaryDarkBlue,
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
                color:
                    isDarkTheme
                        ? const Color(0xFFBEBEBE)
                        : const Color(0xFF2E2E2E),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
