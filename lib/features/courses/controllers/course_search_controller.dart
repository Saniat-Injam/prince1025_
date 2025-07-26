import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:prince1025/features/courses/controllers/courses_controller.dart';
import 'package:prince1025/features/courses/models/course_model.dart';
import 'package:prince1025/features/courses/views/course_details_screen.dart';

class CourseSearchController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final CoursesController _coursesController = Get.find<CoursesController>();

  // Observable variables
  final RxList<Course> searchResults = <Course>[].obs;
  final RxBool isSearching = false.obs;
  final RxString searchQuery = ''.obs;

  // Popular search suggestions
  final List<String> popularSearches = [
    'Meditation',
    'Manifestation',
    'Abundance',
    'Self Love',
    'Mindfulness',
    'Gratitude',
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
          _coursesController.allCourses.where((course) {
            return course.title.toLowerCase().contains(query.toLowerCase()) ||
                course.subtitle.toLowerCase().contains(query.toLowerCase()) ||
                course.category.toLowerCase().contains(query.toLowerCase());
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

  // Navigate to course details
  void navigateToCourseDetails(Course course) {
    Get.to(() => CourseDetailsScreen(course: course));
  }

  // Toggle course favorite
  void toggleCourseFavorite(String courseId) {
    _coursesController.toggleCourseFavorite(courseId);
  }

  // Check if course is favorite
  bool isCourseFavorite(String courseId) {
    return _coursesController.isCourseFavorite(courseId);
  }

  // Get recent courses (for suggestions)
  List<Course> get recentCourses =>
      _coursesController.allCourses.take(5).toList();
}
