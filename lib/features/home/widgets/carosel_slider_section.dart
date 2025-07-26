import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:prince1025/core/common/styles/global_text_style.dart';
import 'package:prince1025/features/home/controllers/home_controller.dart';
import 'package:prince1025/features/profile/widgets/custom_ev_button.dart';

class CaroselSliderSection extends StatelessWidget {
  final HomeController controller;
  final bool isDarkTheme;
  final Color textColor;

  const CaroselSliderSection({
    super.key,
    required this.controller,
    required this.isDarkTheme,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200.0,
        viewportFraction: 1,
        aspectRatio: 16 / 9,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.linear,
        enlargeCenterPage: true,
        enlargeFactor: 0.4,
        scrollDirection: Axis.horizontal,
        onPageChanged: (page, reason) {
          controller.updatePage(page);
        },
      ),
      items:
          controller.carosels.map((carosel) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(carosel.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.3),
                            ],
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              carosel.title,
                              style: TextStyle(
                                fontFamily: 'Enwallowify',
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),

                            Text(
                              carosel.subtitle,
                              style: getDMTextStyle(
                                fontSize: 14.0,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            SizedBox(
                              width: 140,
                              height: 44,
                              child: CustomEVButton(
                                text: 'Watch Now',
                                onPressed: () {
                                  // Get the current carousel index
                                  final currentIndex = controller.carosels
                                      .indexOf(carosel);
                                  controller.playCarouselVideo(currentIndex);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }).toList(),
    );
  }
}
