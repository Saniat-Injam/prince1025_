import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:prince1025/features/videos/controllers/videos_controller.dart';
import 'package:prince1025/features/videos/models/video_content_model.dart';

class VideoSearchController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final VideosController _videosController = Get.find<VideosController>();

  // Observable variables
  final RxList<VideoContent> searchResults = <VideoContent>[].obs;
  final RxBool isSearching = false.obs;
  final RxString searchQuery = ''.obs;

  // Popular search suggestions
  final List<String> popularSearches = [
    'Meditation',
    'Manifestation',
    'Abundance',
    'Vision Board',
    'Morning Ritual',
    'Affirmations',
  ];

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void onClose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.onClose();
  }

  // Search functionality
  void _onSearchChanged() {
    final query = searchController.text.trim();
    searchQuery.value = query;

    if (query.isEmpty) {
      searchResults.clear();
      isSearching.value = false;
      return;
    }

    isSearching.value = true;
    _performSearch(query);
  }

  // Perform search
  void _performSearch(String query) {
    // Simulate a slight delay for better UX
    Future.delayed(const Duration(milliseconds: 300), () {
      final results =
          _videosController.allVideos.where((video) {
            return video.title.toLowerCase().contains(query.toLowerCase()) ||
                (video.description?.toLowerCase().contains(
                      query.toLowerCase(),
                    ) ??
                    false);
          }).toList();

      searchResults.value = results;
      isSearching.value = false;
    });
  }

  // Clear search
  void clearSearch() {
    searchController.clear();
    searchResults.clear();
    isSearching.value = false;
    searchQuery.value = '';
  }

  // Select popular search
  void selectPopularSearch(String search) {
    searchController.text = search;
  }

  // Play video
  void playVideo(VideoContent video) {
    _videosController.playVideo(video);
  }

  // Toggle video favorite
  void toggleVideoFavorite(String videoId) {
    _videosController.toggleVideoFavorite(videoId);
  }

  // Check if video is favorite
  bool isVideoFavorite(String videoId) {
    return _videosController.isVideoFavorite(videoId);
  }

  // Get recent videos
  List<VideoContent> get recentVideos =>
      _videosController.allVideos.take(5).toList();
}
