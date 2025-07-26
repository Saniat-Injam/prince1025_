import 'package:get/get.dart';
import 'package:prince1025/features/auth/screens/forgot_password_screen.dart';
import 'package:prince1025/features/auth/screens/set_new_password_screen.dart';
import 'package:prince1025/features/auth/screens/verification_code_screen.dart';

import 'package:prince1025/features/auth/screens/otp_sending_screen.dart';

import 'package:prince1025/features/profile/views/contact_support_screen.dart';
import 'package:prince1025/features/profile/views/faq_screen.dart';
import 'package:prince1025/features/profile/views/all_favorite_videos_screen.dart';
import 'package:prince1025/features/quotes/views/quotes_screen.dart';
import 'package:prince1025/features/courses/views/courses_screen.dart';
import 'package:prince1025/features/videos/views/videos_screen.dart';
import 'package:prince1025/features/profile/views/subscription_screen.dart';
import 'package:prince1025/features/profile/views/terms_conditions_screen.dart';
import 'package:prince1025/features/profile/views/settings_screen.dart';
import 'package:prince1025/features/auth/screens/auth_screen.dart';
import 'package:prince1025/features/notifications/views/notification_screen.dart';
import 'package:prince1025/features/videos/views/video_search_screen.dart';
import 'package:prince1025/features/courses/views/course_search_screen.dart';
import 'package:prince1025/features/courses/views/course_section_screen.dart';
import 'package:prince1025/features/home/views/home_screen.dart';

import 'package:prince1025/features/splash_screen/screen/splash_screen.dart';

class AppRoute {
  static String splashScreen = "/splash";
  static String homeScreen = "/home";
  static String authScreen = "/auth";
  static String otpSendingScreen = "/otpSending";
  static String verifyCodeScreen = "/verifyCode";
  static String forgotPasswordScreen = "/forgotPassword";
  static String setPasswordScreen = "/setPassword";

  static String faqScreen = "/faq";
  static String supportScreen = "/support";
  static String termsScreen = "/terms";
  static String settingsScreen = "/settings";
  static String notificationScreen = "/notification";
  static String quotesScreen = "/quotes";
  static String coursesScreen = "/courses";
  static String videosScreen = "/videos";
  static String subscriptionScreen = "/subscription";
  static String videoSearchScreen = "/videoSearch";
  static String courseSearchScreen = "/courseSearch";
  static String allFavoriteVideosScreen = "/allFavoriteVideos";
  static String courseContinueScreen = "/courseContinue";
  static String courseInProgressScreen = "/courseInProgress";
  static String courseAvailableScreen = "/courseAvailable";
  static String courseCompletedScreen = "/courseCompleted";

  static String getSplashScreen() => splashScreen;
  static String getHomeScreen() => homeScreen;
  static String getFAQScreen() => faqScreen;
  static String getSupportScreen() => supportScreen;
  static String getTermsScreen() => termsScreen;
  static String getSettingsScreen() => settingsScreen;
  static String getNotificationScreen() => notificationScreen;
  static String getQuotesScreen() => quotesScreen;
  static String getCoursesScreen() => coursesScreen;
  static String getVideosScreen() => videosScreen;
  static String getSubscriptionScreen() => subscriptionScreen;
  static String getVideoSearchScreen() => videoSearchScreen;
  static String getCourseSearchScreen() => courseSearchScreen;
  static String getAllFavoriteVideosScreen() => allFavoriteVideosScreen;
  static String getCourseContinueScreen() => courseContinueScreen;
  static String getCourseInProgressScreen() => courseInProgressScreen;
  static String getCourseAvailableScreen() => courseAvailableScreen;
  static String getCourseCompletedScreen() => courseCompletedScreen;

  static List<GetPage> routes = [
    GetPage(name: splashScreen, page: () => SplashScreen()),
    GetPage(name: homeScreen, page: () => const HomeScreen()),
    GetPage(name: authScreen, page: () => AuthScreen()),
    GetPage(name: forgotPasswordScreen, page: () => ForgotPasswordScreen()),
    GetPage(name: setPasswordScreen, page: () => SetPasswordScreen()),
    GetPage(name: otpSendingScreen, page: () => OTPSendingScreen()),
    //GetPage(name: verifyCodeScreen, page: () => VerificationCodeScreen()),
    GetPage(
      name: verifyCodeScreen,
      page: () => VerificationCodeScreen(origin: VerificationOrigin.otpSending),
    ),

    GetPage(name: faqScreen, page: () => const FAQScreen()),
    GetPage(name: supportScreen, page: () => const ContactSupportScreen()),
    GetPage(name: termsScreen, page: () => const TermsConditionsScreen()),
    GetPage(name: settingsScreen, page: () => const SettingsScreen()),
    GetPage(name: notificationScreen, page: () => const NotificationScreen()),
    GetPage(name: quotesScreen, page: () => const QuotesScreen()),
    GetPage(name: coursesScreen, page: () => const CoursesScreen()),
    GetPage(name: videosScreen, page: () => const VideosScreen()),
    GetPage(name: subscriptionScreen, page: () => const SubscriptionScreen()),
    GetPage(name: videoSearchScreen, page: () => const VideoSearchScreen()),
    GetPage(name: courseSearchScreen, page: () => const CourseSearchScreen()),
    GetPage(
      name: allFavoriteVideosScreen,
      page: () => const AllFavoriteVideosScreen(),
    ),
    GetPage(
      name: courseContinueScreen,
      page:
          () => const CourseSectionScreen(
            sectionTitle: 'Continue Where You Left',
            sectionType: 'continue',
          ),
    ),
    GetPage(
      name: courseInProgressScreen,
      page:
          () => const CourseSectionScreen(
            sectionTitle: 'In Progress',
            sectionType: 'in_progress',
          ),
    ),
    GetPage(
      name: courseAvailableScreen,
      page:
          () => const CourseSectionScreen(
            sectionTitle: 'Available Courses',
            sectionType: 'available',
          ),
    ),
    GetPage(
      name: courseCompletedScreen,
      page:
          () => const CourseSectionScreen(
            sectionTitle: 'Completed',
            sectionType: 'completed',
          ),
    ),
  ];
}
