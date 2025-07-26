import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:prince1025/core/common/styles/global_text_style.dart';
import 'package:prince1025/core/utils/constants/svg_path.dart';
import '../models/video_content_model.dart';

class FeaturedVideoWidget extends StatelessWidget {
  final VideoContent video;
  final bool isDarkTheme;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;
  final bool isFavorite;

  const FeaturedVideoWidget({
    super.key,
    required this.video,
    required this.isDarkTheme,
    required this.onTap,
    required this.onFavoriteTap,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 240,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow:
              isDarkTheme
                  ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ]
                  : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              // Background Image with gradient overlay
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: video.thumbnailUrl,
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) => Container(
                        color:
                            isDarkTheme ? Colors.grey[800] : Colors.grey[300],
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                  errorWidget:
                      (context, url, error) => Container(
                        color:
                            isDarkTheme ? Colors.grey[800] : Colors.grey[300],
                        child: const Icon(
                          Icons.broken_image,
                          color: Colors.grey,
                          size: 50,
                        ),
                      ),
                ),
              ),
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.1),
                      Colors.black.withValues(alpha: 0.3),
                      Colors.black.withValues(alpha: 0.7),
                    ],
                  ),
                ),
              ),

              // Featured Badge
              if (video.isFeatured)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isDarkTheme
                              ? const Color(0xFF210065)
                              : const Color(0xFF005E89),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Featured',
                      style: getDMTextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

              // Play Button
              Center(
                child: SvgPicture.asset(
                  SvgPath.playButtonSvg,
                  width: 48,
                  height: 48,
                ),
              ),

              // Bottom Content
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video.title,
                      style: TextStyle(
                        fontFamily: 'Enwallowify',
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        //icon
                        Icon(
                          Icons.remove_red_eye_outlined,
                          size: 18,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${video.formattedViews} views',
                          style: getDMTextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 16),

                        //date
                        Text(
                          video.publishedDate,
                          style: getDMTextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),

                        //duration
                        Icon(
                          Icons.play_circle_outline,
                          size: 16,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          video.duration,
                          style: getDMTextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Favorite Button
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.favorite, size: 16, color: Colors.red),
                      const SizedBox(width: 4),
                      Text(
                        video.totalFavorites.toString(),
                        style: getDMTextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Positioned(
              //   top: 16,
              //   left: 16,
              //   child: GestureDetector(
              //     onTap: onFavoriteTap,
              //     child: Container(
              //       padding: const EdgeInsets.all(8),
              //       decoration: BoxDecoration(
              //         color: Colors.black.withValues(alpha: 0.5),
              //         shape: BoxShape.circle,
              //       ),
              //       child: Icon(
              //         isFavorite ? Icons.favorite : Icons.favorite_border,
              //         color:
              //             isFavorite ? const Color(0xFFEF4444) : Colors.white,
              //         size: 24,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
