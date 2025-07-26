import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prince1025/features/home/models/carosels_models.dart';
import 'package:prince1025/features/videos/models/video_content_model.dart';
import 'package:prince1025/features/videos/views/video_detail_screen.dart';
import 'package:prince1025/features/courses/models/course_model.dart';
import 'package:prince1025/features/courses/views/course_details_screen.dart';
import 'package:prince1025/routes/app_routes.dart';
import 'package:prince1025/core/utils/constants/flutter_toast.dart';

class HomeController extends GetxController {
  // Observable for current carousel page
  final currentPage = 0.obs;

  // Update current page (called by CarouselSlider)
  void updatePage(int page) {
    currentPage.value = page;
  }

  void playVideo(VideoContent video) {
    Get.to(() => VideoDetailScreen(video: video));
  }

  // shows toast message
  void showToast(String msg, bool isDarkTheme) {
    CustomToast.showToast(
      msg: msg,
      backgroundColor:
          isDarkTheme
              ? Colors.white.withValues(alpha: 0.8)
              : Colors.black.withValues(alpha: 0.8),
      textColor: isDarkTheme ? Colors.black : Colors.white,
    );
  }

  // Navigate to video detail screen from carousel
  void playCarouselVideo(int carouselIndex) {
    final carousel = carosels[carouselIndex];
    final video = VideoContent(
      id: 'carousel_$carouselIndex',
      title: carousel.title,
      category: 'Featured',
      duration: '10:30',
      thumbnailUrl: carousel.image,
      videoUrl: carousel.videoUrl,
      views: 120500,
      publishedDate: 'Today',
      description: carousel.description,
      isFeatured: true,
      isPremium: false,
      totalFavorites: 500,
    );
    playVideo(video);
  }

  // Navigate to courses screen
  void navigateToCourses() {
    Get.toNamed(AppRoute.coursesScreen);
  }

  // Navigate to videos screen
  void navigateToVideos() {
    Get.toNamed(AppRoute.videosScreen);
  }

  // Navigate to quotes screen
  void navigateToQuotes() {
    Get.toNamed(AppRoute.quotesScreen);
  }

  // Navigate to subscription screen
  void navigateToSubscription() {
    Get.toNamed(AppRoute.subscriptionScreen);
  }

  // Navigate to course details
  void navigateToCourseDetails(Course course) {
    Get.to(() => CourseDetailsScreen(course: course));
  }

  // Sample courses data for home page
  List<Course> get manifestationCourses => [
    Course(
      id: '1',
      title: 'Abundance Mindset',
      subtitle: 'Transform your relationship with money',
      imageUrl: 'https://images.pexels.com/photos/4048182/pexels-photo-4048182.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
      totalLessons: 8,
      currentLesson: 0,
      progress: 0.0,
      category: 'Manifestation',
      isLocked: false,
      hasPreview: true,
    ),
    Course(
      id: '2',
      title: 'Visualization Magic',
      subtitle: 'Master the art of creative visualization',
      imageUrl: 'https://images.pexels.com/photos/1933239/pexels-photo-1933239.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
      totalLessons: 6,
      currentLesson: 0,
      progress: 0.0,
      category: 'Manifestation',
      isLocked: false,
      hasPreview: true,
    ),
  ];

  // Sample latest videos for home page
  List<VideoContent> get latestVideos => [
    VideoContent(
      id: 'latest_1',
      title: 'Daily Affirmations for Success',
      category: 'Recent',
      duration: '10:32',
      thumbnailUrl:
          'https://images.pexels.com/photos/715134/pexels-photo-715134.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
      videoUrl: 'assets/videos/lessone1.mp4',
      views: 25000,
      publishedDate: '2 days ago',
      description:
          'Powerful daily affirmations to boost your confidence and success',
      isPremium: false,
      totalFavorites: 120,
    ),
    VideoContent(
      id: 'latest_2',
      title: 'Scripting for Manifestation',
      category: 'Recent',
      duration: '15:45',
      thumbnailUrl:
          'https://images.pexels.com/photos/3094211/pexels-photo-3094211.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
      videoUrl: 'assets/videos/lessone2.mp4',
      views: 34000,
      publishedDate: '1 day ago',
      description: 'Learn powerful scripting techniques for manifestation',
      isPremium: false,
      totalFavorites: 180,
    ),
  ];

  // Sample upcoming course
  Course get upcomingCourse => Course(
    id: 'upcoming_1',
    title: 'Advanced Manifestation Workshop',
    subtitle: 'Learn powerful techniques to manifest your desires faster',
    imageUrl: 'assets/images/advanced_manifestation_workshop.png',
    totalLessons: 12,
    currentLesson: 0,
    progress: 0.0,
    category: 'Workshop',
    isLocked: true,
    hasPreview: false,
  );

  final List<CaroselModel> carosels = [
    CaroselModel(
      image:
          'https://images.pexels.com/photos/715134/pexels-photo-715134.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
      title: 'Morning Meditation',
      subtitle: 'Start your day with peace and clarity',
      description: 'Manifestation',
      videoUrl: 'assets/videos/lessone1.mp4',
    ),
    CaroselModel(
      image:
          'https://images.pexels.com/photos/2541310/pexels-photo-2541310.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
      title: 'Manifestation',
      subtitle: 'Manifestion is the power of your mind to create reality',
      description: 'Manifestation',
      videoUrl: 'assets/videos/lessone2.mp4',
    ),
    CaroselModel(
      image:
          'https://images.pexels.com/photos/715194/pexels-photo-715194.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
      title: 'Daily Quotes',
      subtitle:
          'Daily Quotes will inspire you to be the best version of yourself',
      description:
          'Daily Quotes will inspire you to be the best version of yourself',
      videoUrl: 'assets/videos/lesson5.mp4',
    ),
  ];
}
