import 'package:flutter/material.dart';
import 'package:prince1025/core/common/styles/global_text_style.dart';
import 'package:prince1025/features/home/controllers/home_controller.dart';
import 'package:prince1025/features/profile/widgets/custom_ev_button.dart';

class ComingSoonSection extends StatelessWidget {
  final HomeController controller;
  final bool isDarkTheme;
  final Color textColor;
  final VoidCallback onTap;

  const ComingSoonSection({
    super.key,
    required this.controller,
    required this.isDarkTheme,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Coming Soon',
              style: TextStyle(
                fontFamily: 'Enwallowify',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            // time count down section
            const SizedBox(width: 8),
            Text(
              '2d : 16h : 39m',
              style: getDMTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color:
                    isDarkTheme
                        ? const Color(0xFFC7B0F5)
                        : const Color(0xFF005E89),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Coming Soon Card
        _buildComingSoonCard(),
      ],
    );
  }

  Widget _buildComingSoonCard() {
    final course = controller.upcomingCourse;

    return Container(
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
          // Course Image with countdown overlay
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              course.imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF4E91FF).withValues(alpha: 0.8),
                        const Color(0xFF1448CF).withValues(alpha: 0.8),
                      ],
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.play_circle_filled,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
          ),

          // Course Title and Subtitle on image
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.title,
                  style: TextStyle(
                    fontFamily: 'Enwallowify',
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: isDarkTheme ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  course.subtitle,
                  style: getDMTextStyle(
                    fontSize: 14,
                    color:
                        isDarkTheme
                            ? const Color(0xFFBEBEBE)
                            : const Color(0xFF939393),
                  ),
                ),
                const SizedBox(height: 4),
                CustomEVButton(onPressed: onTap, text: 'Get Notified'),
              ],
            ),
          ),

          // Get Notified Button
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
