import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:prince1025/core/common/widgets/custom_app_bar.dart';
import 'package:prince1025/core/common/styles/global_text_style.dart';
import 'package:prince1025/core/utils/constants/colors.dart';
import 'package:prince1025/core/utils/constants/image_path.dart';
import 'package:prince1025/core/utils/constants/svg_path.dart';
import 'package:prince1025/features/videos/controllers/videos_controller.dart';
import 'package:prince1025/features/videos/models/video_content_model.dart';
import 'package:prince1025/features/videos/widgets/empty_state_widget.dart';
import 'package:prince1025/features/videos/widgets/featured_video_widget.dart';
import 'package:prince1025/features/videos/widgets/video_card.dart';
import 'package:prince1025/routes/app_routes.dart';

class VideosScreen extends StatelessWidget {
  const VideosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VideosController());
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final String? backgroundImage =
        isDarkTheme ? ImagePath.darkSettingScreenbackground : null;
    final textColor = isDarkTheme ? const Color(0xFFF5F5F5) : Colors.black87;
    final backgroundColor =
        isDarkTheme ? const Color(0xFF121212) : const Color(0xFFF8F9FA);

    return Container(
      decoration: BoxDecoration(
        image:
            isDarkTheme && backgroundImage != null
                ? DecorationImage(
                  image: AssetImage(backgroundImage),
                  fit: BoxFit.cover,
                )
                : null,
      ),
      child: Scaffold(
        backgroundColor: isDarkTheme ? Colors.transparent : backgroundColor,
        appBar: CustomAppBar(
          showBackButton: false,
          automaticallyImplyLeading: false,
          title: 'Videos',
          actions: [
            IconButton(
              icon: SvgPicture.asset(
                SvgPath.searchSvg,
                colorFilter: ColorFilter.mode(
                  isDarkTheme ? Colors.white : Colors.black,
                  BlendMode.srcIn,
                ),
              ),
              onPressed: () => Get.toNamed(AppRoute.getVideoSearchScreen()),
            ),
          ],
        ),

        body: SafeArea(
          child: Obx(() {
            if (controller.isLoading.value &&
                controller.allVideos.isEmpty &&
                controller.featuredVideo.value == null) {
              return Center(
                child: CircularProgressIndicator(
                  color: isDarkTheme ? Colors.white : AppColors.primaryDarkBlue,
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () async => controller.loadVideos(),
              color: isDarkTheme ? Colors.white : AppColors.primaryDarkBlue,
              backgroundColor:
                  isDarkTheme ? const Color(0xFF1F2937) : Colors.white,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // Featured Video
                  SliverToBoxAdapter(
                    child: Obx(() {
                      final featuredVideo = controller.featuredVideo.value;
                      if (featuredVideo != null) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 20,
                          ),
                          child: FeaturedVideoWidget(
                            video: featuredVideo,
                            isDarkTheme: isDarkTheme,
                            onTap: () => controller.playVideo(featuredVideo),
                            onFavoriteTap:
                                () => controller.toggleVideoFavorite(
                                  featuredVideo.id,
                                ),
                            isFavorite: controller.isVideoFavorite(
                              featuredVideo.id,
                            ),
                          ),
                        );
                      } else if (controller.isLoading.value &&
                          controller.allVideos.isEmpty) {
                        // Show loader if all videos are still loading
                        return SizedBox(
                          height: 240,
                          child: Center(
                            child: CircularProgressIndicator(
                              color:
                                  isDarkTheme
                                      ? Colors.white
                                      : AppColors.primaryDarkBlue,
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                  ),

                  // Video sections
                  Obx(() {
                    // Display Sections
                    return _buildSectionsSlivers(
                      controller,
                      controller.sectionCategories,
                      isDarkTheme,
                      textColor,
                    );
                  }),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 20),
                  ), // Bottom padding
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildSectionsSlivers(
    VideosController controller,
    List<String> sectionCategories,
    bool isDarkTheme,
    Color textColor,
  ) {
    List<Widget> sectionWidgets =
        []; // Renamed from sectionSlivers to sectionWidgets
    bool hasContentOverall = false;

    for (String categoryName in sectionCategories) {
      final List<VideoContent> categoryVideos = controller.getVideosForCategory(
        categoryName,
      );

      if (categoryVideos.isNotEmpty) {
        hasContentOverall = true;
        // Each section is a Column (a box widget)
        sectionWidgets.add(
          Padding(
            // Add some vertical spacing between sections if desired
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    16,
                    0,
                    16,
                    8,
                  ), // Adjusted padding
                  child: Text(
                    categoryName,
                    style: getDMTextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 16, right: 4),
                    itemCount: categoryVideos.length,
                    itemBuilder: (context, index) {
                      final video = categoryVideos[index];
                      return Padding(
                        padding: const EdgeInsets.only(
                          right: 12.0,
                        ), // Spacing between cards
                        child: SizedBox(
                          width: 182,
                          child: VideoCard(
                            video: video,
                            isDarkTheme: isDarkTheme,
                            onTap: () => controller.playVideo(video),
                            onFavoriteTap:
                                () => controller.toggleVideoFavorite(video.id),
                            isFavorite: controller.isVideoFavorite(video.id),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }

    if (!hasContentOverall && !controller.isLoading.value) {
      return SliverToBoxAdapter(
        // Return a sliver for empty state
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: EmptyStateWidget(
            title: 'No Videos Available',
            subtitle: 'Check back later for new content.',
            icon: Icons.video_library_outlined,
            isDarkTheme: isDarkTheme,
          ),
        ),
      );
    }

    if (sectionWidgets.isEmpty && controller.isLoading.value) {
      return const SliverToBoxAdapter(
        child: Center(
          child: Padding(
            // Return a sliver for loading
            padding: EdgeInsets.all(32.0),
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (sectionWidgets.isEmpty) {
      return const SliverToBoxAdapter(
        child: SizedBox.shrink(),
      ); // Return a sliver for no content
    }
    return SliverList(delegate: SliverChildListDelegate(sectionWidgets));
  }
}
