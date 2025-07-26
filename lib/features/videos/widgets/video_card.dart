import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:prince1025/core/common/styles/global_text_style.dart';
import 'package:prince1025/core/utils/constants/svg_path.dart';
import '../models/video_content_model.dart';

class VideoCard extends StatelessWidget {
  final VideoContent video;
  final bool isDarkTheme;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;
  final bool isFavorite;
  final bool isHomeScreen;
  final bool isFavButtonVisible;

  const VideoCard({
    super.key,
    required this.video,
    required this.isDarkTheme,
    required this.onTap,
    required this.onFavoriteTap,
    required this.isFavorite,
    this.isHomeScreen = false,
    this.isFavButtonVisible = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDarkTheme ? const Color(0xFF071123) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border:
              isDarkTheme ? Border.all(color: const Color(0xFF133663)) : null,
          boxShadow:
              isDarkTheme
                  ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                  : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: isHomeScreen ? 120 : 100,
                    width: double.infinity,
                    child: CachedNetworkImage(
                      imageUrl: video.thumbnailUrl,
                      fit: BoxFit.cover,
                      placeholder:
                          (context, url) => Container(
                            color:
                                isDarkTheme
                                    ? Colors.grey[800]
                                    : Colors.grey[300],
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                      errorWidget:
                          (context, url, error) => Container(
                            color:
                                isDarkTheme
                                    ? Colors.grey[800]
                                    : Colors.grey[300],
                            child: const Icon(
                              Icons.broken_image,
                              color: Colors.grey,
                              size: 40,
                            ),
                          ),
                    ),
                  ),
                  // Gradient color
                  Container(
                    height: isHomeScreen ? 120 : 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.4),
                        ],
                      ),
                    ),
                  ),

                  // Duration
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        video.duration,
                        style: getDMTextStyle(
                          fontSize: 12,

                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  // Favorite Button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: onFavoriteTap,
                      child:
                          isFavButtonVisible
                              ? Icon(
                                Icons.favorite,
                                color:
                                    isFavorite
                                        ? const Color(0xFFEF4444)
                                        : Colors.white,
                                size: 18,
                              )
                              : const SizedBox(),
                    ),
                  ),

                  // Play Button
                  SvgPicture.asset(
                    SvgPath.playButtonSvg,
                    width: 32,
                    height: 32,
                  ),
                ],
              ),

              // Title + Views + Published Date
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Title
                      Text(
                        video.title,
                        style: getDMTextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isDarkTheme ? Colors.white : Colors.black,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // Views + Published Date
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            video.publishedDate,
                            style: getDMTextStyle(
                              fontSize: 12,
                              color:
                                  isDarkTheme
                                      ? const Color(0xFFBEBEBE)
                                      : const Color(0xFF939393),
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.visibility_outlined,
                                size: 14,
                                color:
                                    isDarkTheme
                                        ? const Color(0xFFBEBEBE)
                                        : const Color(0xFF939393),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                video.formattedViews,
                                style: getDMTextStyle(
                                  fontSize: 12,
                                  color:
                                      isDarkTheme
                                          ? const Color(0xFFBEBEBE)
                                          : const Color(0xFF939393),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
