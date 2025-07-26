import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:prince1025/features/profile/controllers/profile_controller.dart';
import 'package:share_plus/share_plus.dart';
import '../models/video_content_model.dart';
import '../views/video_detail_screen.dart';

class VideosController extends GetxController {
  // Current selected category
  final RxInt selectedCategoryIndex = 0.obs;
  // For expanding lesson description
  final RxBool isDescriptionExpanded = false.obs;

  // Categories - extended as per user request
  final List<String> categories = [
    'All',
    'Recent',
    'Trending',
    'Motivational',
    'Guided Meditations',
    'Workshops',
  ];

  // Define the order of categories to display as sections
  final List<String> sectionCategories = [
    'Recent',
    'Trending',
    'Motivational',
    'Guided Meditations',
    'Workshops',
  ];

  // All videos list (will be fetched or defined locally)
  final RxList<VideoContent> _allVideos = <VideoContent>[].obs;

  // Featured video (displayed at top)
  final Rx<VideoContent?> featuredVideo = Rx<VideoContent?>(null);

  // Filtered videos list based on category and search
  final RxList<VideoContent> filteredVideos = <VideoContent>[].obs;

  // Map to track favorite state of each video
  final RxMap<String, bool> favoriteVideos = <String, bool>{}.obs;

  // Loading states
  final RxBool isLoading = false.obs;

  // Search query
  final RxString searchQuery = ''.obs;

  // User subscription status (assuming you have a ProfileController or similar)
  final RxBool isUserSubscribed = false.obs;

  // Getter for all videos to be used by the UI
  List<VideoContent> get allVideos => _allVideos.toList();

  @override
  void onInit() {
    super.onInit();
    try {
      final profileController = Get.find<ProfileController>();
      isUserSubscribed.value =
          profileController.isPremium.value; // Corrected to use isPremium
      ever(profileController.isPremium, (bool subscribed) {
        // Corrected to listen to isPremium
        isUserSubscribed.value = subscribed;
        _filterAndCategorizeVideos();
      });
    } catch (e) {
      if (kDebugMode) {
        print(
          "ProfileController not found or isPremium field missing, defaulting to unsubscribed. Error: $e",
        );
      }
      isUserSubscribed.value = false;
    }
    loadVideos();
  }

  // Load video data
  void loadVideos() {
    isLoading.value = true;

    // Sample video data - replace with your actual data source (API, local DB, etc.)
    // Using network URLs for thumbnails as requested
    _allVideos.value = [
      VideoContent(
        id: '1',
        title: 'The Power of Positive Affirmations',
        category: 'Motivational',
        duration: '10:30',
        thumbnailUrl:
            'https://images.pexels.com/photos/715134/pexels-photo-715134.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
        videoUrl: 'assets/videos/lessone1.mp4',
        views: 120500,
        publishedDate: 'May 15, 2025',
        isFeatured: true,
        isPremium: false,
        totalFavorites: 500,
        description:
            'Discover how positive affirmations can change your mindset and life. This video explores the science and practice of daily affirmations for success and happiness.',
      ),
      VideoContent(
        id: '2',
        title: 'Guided Meditation for Inner Peace',
        category: 'Guided Meditations',
        duration: '15:45',
        thumbnailUrl:
            'https://images.pexels.com/photos/3094211/pexels-photo-3094211.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
        videoUrl: 'assets/videos/lessone2.mp4',
        views: 250000,
        publishedDate: 'May 14, 2025',
        isPremium: true,
        totalFavorites: 320,
        description:
            'A soothing guided meditation to help you find inner peace and tranquility. Perfect for beginners and experienced meditators alike. Find a quiet space and relax.',
      ),
      VideoContent(
        id: '3',
        title: 'Journaling for Clarity and Growth',
        category: 'Workshops',
        duration: '30:12',
        thumbnailUrl:
            'https://images.pexels.com/photos/4144923/pexels-photo-4144923.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
        videoUrl: 'assets/videos/lessone3.mp4',
        views: 85000,
        publishedDate: 'May 12, 2025',
        isPremium: false,
        totalFavorites: 120,
        description:
            'Learn effective journaling techniques to gain clarity, foster personal growth, and track your progress. This workshop provides practical tips and prompts.',
      ),
      VideoContent(
        id: '4',
        title: 'Morning Rituals for a Productive Day',
        category: 'Recent',
        duration: '08:55',
        thumbnailUrl:
            'https://images.pexels.com/photos/3771089/pexels-photo-3771089.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
        videoUrl: 'assets/videos/lessone4.mp4',
        views: 312000,
        publishedDate: 'May 10, 2025',
        isPremium: true,
        totalFavorites: 600,
        description:
            'Start your day right with these powerful morning rituals designed to boost productivity, energy, and focus. Simple steps for a transformative morning.',
      ),
      VideoContent(
        id: '5',
        title: 'Vision Board Magic: Manifest Your Dreams',
        category: 'Trending',
        duration: '18:20',
        thumbnailUrl:
            'https://images.pexels.com/photos/1906658/pexels-photo-1906658.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
        videoUrl: 'assets/videos/lessone1.mp4',
        views: 4500000, // High views for trending
        publishedDate: 'May 11, 2025',
        isPremium: false,
        totalFavorites: 120,
        description:
            'Unlock the secrets of creating a powerful vision board that helps you manifest your dreams. This video guides you through the process step-by-step.',
      ),
      VideoContent(
        id: '6',
        title: 'Overcome Limiting Beliefs Masterclass',
        category: 'Motivational',
        duration: '22:50',
        thumbnailUrl:
            'https://images.pexels.com/photos/3184418/pexels-photo-3184418.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
        videoUrl: 'assets/videos/lessone2.mp4',
        views: 2156000,
        publishedDate: 'May 9, 2025',
        isFeatured: true,
        isPremium: true,
        totalFavorites: 600,
        description:
            'A deep dive into identifying and overcoming limiting beliefs that hold you back. This masterclass provides tools and strategies for a mindset shift.',
      ),
      VideoContent(
        id: '7',
        title: '5-Minute Morning Manifestation Ritual',
        category: 'Guided Meditations',
        duration: '05:00',
        thumbnailUrl:
            'https://images.pexels.com/photos/768474/pexels-photo-768474.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
        videoUrl: 'assets/videos/lessone3.mp4',
        views: 196700,
        publishedDate: 'May 8, 2025',
        isPremium: false,
        totalFavorites: 600,
        description:
            'A quick and effective 5-minute morning ritual to set your intentions and manifest a positive day. Easy to incorporate into any morning routine.',
      ),
      // Add more sample videos for 'Trending' and other categories
      VideoContent(
        id: '8',
        title: 'Trending Now: Mindfulness in Minutes',
        category: 'Trending',
        duration: '08:20',
        thumbnailUrl:
            'https://images.pexels.com/photos/3768870/pexels-photo-3768870.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
        videoUrl: 'assets/videos/lessone4.mp4',
        views: 5000000, // High views for trending
        publishedDate: 'June 15, 2025',
        isPremium: false,
        totalFavorites: 900,
        description:
            'Explore the benefits of mindfulness and learn simple techniques to practice it in just a few minutes a day. Stay present and reduce stress with this trending guide.',
      ),
      VideoContent(
        id: '9',
        title: 'Advanced Manifestation Workshop',
        category: 'Workshops',
        duration: '45:00',
        thumbnailUrl:
            'https://images.pexels.com/photos/1181298/pexels-photo-1181298.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
        videoUrl: 'assets/videos/lessone1.mp4',
        views: 75000,
        publishedDate: 'June 10, 2025',
        isPremium: true,
        totalFavorites: 600,
        description:
            'Take your manifestation skills to the next level with this advanced workshop. Learn powerful techniques and strategies for achieving your biggest goals.',
      ),
      VideoContent(
        id: '10',
        title: 'Unlock Your Potential: A Motivational Talk',
        category: 'Motivational',
        duration: '30:10',
        thumbnailUrl:
            'https://images.pexels.com/photos/2102416/pexels-photo-2102416.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
        videoUrl: 'assets/videos/lessone2.mp4',
        views: 3200000, // High views for trending
        publishedDate: 'June 1, 2025',
        isFeatured: true,
        isPremium: false,
        totalFavorites: 600,
        description:
            'An inspiring motivational talk to help you unlock your full potential and live a more fulfilling life. Get ready to be motivated and take action!',
      ),
    ];

    _filterAndCategorizeVideos();
    addSampleFavorites(); // Add some sample favorites for testing
    isLoading.value = false;
  }

  void _filterAndCategorizeVideos() {
    // Set featured video (can be dynamic, e.g., most recent featured or specific ID)
    featuredVideo.value = _allVideos.firstWhereOrNull(
      (v) => v.isFeatured && (!v.isPremium || isUserSubscribed.value),
    );
    if (featuredVideo.value == null) {
      // Fallback if no featured premium video is available for subscribed user or no non-premium featured
      featuredVideo.value = _allVideos.firstWhereOrNull((v) => v.isFeatured);
    }
    if (featuredVideo.value == null && _allVideos.isNotEmpty) {
      // Fallback to the first video if no featured video is found
      featuredVideo.value = _allVideos.firstWhereOrNull(
        (v) => !v.isPremium || isUserSubscribed.value,
      );
    }

    final String currentCategory = categories[selectedCategoryIndex.value];
    List<VideoContent> videosToShow = [];

    if (currentCategory == 'All') {
      videosToShow =
          _allVideos
              .where(
                (v) =>
                    v.id != featuredVideo.value?.id &&
                    (!v.isPremium || isUserSubscribed.value),
              )
              .toList();
    } else if (currentCategory == 'Recent') {
      // Sort by published date (assuming date format is parsable or use a proper DateTime object)
      // This is a simplified sort, for robust sorting, convert publishedDate to DateTime
      var recent =
          _allVideos
              .where(
                (v) =>
                    v.id != featuredVideo.value?.id &&
                    (!v.isPremium || isUserSubscribed.value),
              )
              .toList();
      recent.sort(
        (a, b) => b.publishedDate.compareTo(a.publishedDate),
      ); // Descending for recent
      videosToShow = recent;
    } else if (currentCategory == 'Trending') {
      // Sort by views for trending
      var trending =
          _allVideos
              .where(
                (v) =>
                    v.id != featuredVideo.value?.id &&
                    (!v.isPremium || isUserSubscribed.value),
              )
              .toList();
      trending.sort(
        (a, b) => b.views.compareTo(a.views),
      ); // Descending for trending
      videosToShow = trending;
    } else {
      videosToShow =
          _allVideos
              .where(
                (video) =>
                    video.category == currentCategory &&
                    video.id != featuredVideo.value?.id &&
                    (!video.isPremium || isUserSubscribed.value),
              )
              .toList();
    }
    filteredVideos.value = videosToShow;
  }

  // Select category
  void selectCategory(int index) {
    selectedCategoryIndex.value = index;
    _filterAndCategorizeVideos();
  }

  void toggleDescriptionExpansion() {
    isDescriptionExpanded.value = !isDescriptionExpanded.value;
  }

  // Toggle video favorite status
  void toggleVideoFavorite(String videoId) {
    final isCurrentlyFavorite = favoriteVideos[videoId] ?? false;
    favoriteVideos[videoId] = !isCurrentlyFavorite;

    // Update the video objects in _allVideos list
    final videoIndexInAll = _allVideos.indexWhere((v) => v.id == videoId);
    if (videoIndexInAll != -1) {
      _allVideos[videoIndexInAll] = _allVideos[videoIndexInAll].copyWith(
        isFavorite: !isCurrentlyFavorite,
      );
    }
    // Refresh the filtered list to reflect the change if the video is in the current view
    _filterAndCategorizeVideos();
  }

  bool isVideoFavorite(String videoId) {
    return favoriteVideos[videoId] ?? false;
  }

  // Method to share video
  void shareVideo(VideoContent? video) {
    if (video == null) return;
    final String videoUrl = "https://example.com/video/${video.id}";
    final String shareText =
        "Check out this lesson: ${video.title}\\n${video.description ?? ''}\\nWatch it here: $videoUrl";
    SharePlus.instance.share(ShareParams(text: shareText));
  }

  void searchVideos(String query) {
    searchQuery.value = query.toLowerCase();
    if (query.isEmpty) {
      _filterAndCategorizeVideos(); // Reset to category filter if search is cleared
    } else {
      final String currentCategory = categories[selectedCategoryIndex.value];
      List<VideoContent> searchedVideos =
          _allVideos.where((video) {
            final titleMatch = video.title.toLowerCase().contains(
              searchQuery.value,
            );
            final categoryMatch =
                (currentCategory == 'All' || video.category == currentCategory);
            final accessibilityMatch =
                !video.isPremium || isUserSubscribed.value;
            return titleMatch &&
                categoryMatch &&
                accessibilityMatch &&
                video.id != featuredVideo.value?.id;
          }).toList();
      filteredVideos.value = searchedVideos;
    }
  }

  void playVideo(VideoContent video) {
    Get.to(() => VideoDetailScreen(video: video));
  }

  // Method to get videos for a specific category, respecting subscription status
  List<VideoContent> getVideosForCategory(String category) {
    return _allVideos.where((video) {
      bool matchesCategory =
          video.category.toLowerCase() == category.toLowerCase();
      bool canAccess = !video.isPremium || isUserSubscribed.value;
      // Optionally, exclude featured video if it should not appear in regular category lists
      // bool notFeatured = video.id != featuredVideo.value?.id;
      return matchesCategory && canAccess; // && notFeatured;
    }).toList();
  }

  // Method to get favorite videos
  List<VideoContent> get favoriteVideosList {
    return _allVideos.where((video) {
      return favoriteVideos[video.id] == true;
    }).toList();
  }

  // Method to add sample favorites for testing (can be removed in production)
  void addSampleFavorites() {
    if (_allVideos.isNotEmpty) {
      // Add first few videos as favorites for testing
      for (int i = 0; i < 3 && i < _allVideos.length; i++) {
        favoriteVideos[_allVideos[i].id] = true;
      }
    }
  }
}
