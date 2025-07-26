import 'package:get/get.dart';
import '../models/course_model.dart';

class CoursesController extends GetxController {
  // Current selected tab
  final RxInt selectedTabIndex = 0.obs;

  // Tab titles
  final List<String> tabs = ['All', 'In Progress', 'Available', 'Completed'];

  // Map to track favorite state of each course
  final RxMap<String, bool> favoriteCourses = <String, bool>{}.obs;

  // Getter for all courses to be used by the UI
  List<Course> get allCourses => _allCourses.toList();

  // Sample course data
  final List<Course> _allCourses = [
    Course(
      id: '1',
      title: 'Morning Meditation',
      subtitle: 'Start your day with peace and clarity',
      imageUrl: 'https://images.pexels.com/photos/14880276/pexels-photo-14880276.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
      totalLessons: 10,
      currentLesson: 3,
      progress: 0.42,
      category: 'Meditation',
      isLocked: false,
      hasPreview: false,
    ),
    Course(
      id: '2',
      title: 'Manifestation Mastery',
      subtitle: 'Create your dream reality',
      imageUrl: 'https://picsum.photos/400/300?random=2',
      totalLessons: 8,
      currentLesson: 2,
      progress: 0.25,
      category: 'Manifestation',
      isLocked: false,
      hasPreview: false,
    ),
    Course(
      id: '3',
      title: 'Self Love Journey',
      subtitle: 'Embrace your authentic self',
      imageUrl: 'https://picsum.photos/400/300?random=3',
      totalLessons: 12,
      currentLesson: 5,
      progress: 0.41,
      category: 'Self Development',
      isLocked: false,
      hasPreview: true,
    ),
    Course(
      id: '4',
      title: 'Advanced Manifestation',
      subtitle: 'Master the law of attraction',
      imageUrl: 'https://picsum.photos/400/300?random=4',
      totalLessons: 15,
      currentLesson: 0,
      progress: 0.0,
      category: 'Manifestation',
      isLocked: false,
      hasPreview: true,
    ),
    Course(
      id: '5',
      title: 'Gratitude Practice',
      subtitle: 'Transform your mindset',
      imageUrl: 'https://picsum.photos/400/300?random=5',
      totalLessons: 7,
      currentLesson: 0,
      progress: 0.0,
      category: 'Mindfulness',
      isLocked: true,
      hasPreview: false,
    ),
    Course(
      id: '6',
      title: 'Abundance Mindset',
      subtitle: 'Attract prosperity and success',
      imageUrl: 'https://picsum.photos/400/300?random=6',
      totalLessons: 20,
      currentLesson: 20,
      progress: 1.0,
      category: 'Abundance',
      isLocked: false,
      hasPreview: false,
    ),
  ];

  // Get grouped courses for "All" tab
  List<Map<String, dynamic>> get groupedCourses {
    final inProgressCourses =
        _allCourses.where((c) => c.progress > 0 && c.progress < 1.0).toList();
    final availableCourses = _allCourses.where((c) => c.progress == 0).toList();
    final completedCourses =
        _allCourses.where((c) => c.progress == 1.0).toList();

    List<Map<String, dynamic>> sections = [];

    if (inProgressCourses.isNotEmpty) {
      sections.add({
        'title': 'Continue Where You Left',
        'courses':
            inProgressCourses
                .take(1)
                .toList(), // Show only one for continue section
      });

      if (inProgressCourses.length > 1) {
        sections.add({
          'title': 'In Progress',
          'courses': inProgressCourses.skip(1).toList(),
        });
      }
    }

    if (availableCourses.isNotEmpty) {
      sections.add({'title': 'Available Courses', 'courses': availableCourses});
    }

    if (completedCourses.isNotEmpty) {
      sections.add({'title': 'Completed', 'courses': completedCourses});
    }

    return sections;
  }

  // Get courses by tab name
  List<Course> getCoursesByTab(String tabName) {
    switch (tabName) {
      case 'In Progress':
        return _allCourses
            .where((c) => c.progress > 0 && c.progress < 1.0)
            .toList();
      case 'Available':
        return _allCourses.where((c) => c.progress == 0).toList();
      case 'Completed':
        return _allCourses.where((c) => c.progress == 1.0).toList();
      default:
        return _allCourses;
    }
  }

  // Select tab
  void selectTab(int index) {
    selectedTabIndex.value = index;
  }

  // Toggle course favorite
  void toggleCourseFavorite(String courseId) {
    favoriteCourses[courseId] = !(favoriteCourses[courseId] ?? false);
    update();
  }

  // Check if course is favorite
  bool isCourseFavorite(String courseId) {
    return favoriteCourses[courseId] ?? false;
  }

  // Check if current tab is "All" tab
  bool get isAllTabSelected => selectedTabIndex.value == 0;

  // Navigate to subscription screen
  void navigateToSubscription() {
    Get.toNamed('/subscription');
  }

  // Navigate to course details
  void navigateToCourseDetails(String courseId) {
    Get.snackbar('Course Details', 'Opening course: $courseId');
  }

  // Resume learning
  void resumeLearning(String courseId) {
    Get.snackbar('Resume Learning', 'Resuming course: $courseId');
  }
}
