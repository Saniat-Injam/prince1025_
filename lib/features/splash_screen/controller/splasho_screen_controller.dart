import 'package:get/get.dart';
import 'dart:async';
import 'package:prince1025/core/services/storage_service.dart';
import 'package:prince1025/features/bottom_nav/views/bottom_nav_screen.dart';
import 'package:prince1025/routes/app_routes.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    Timer(const Duration(seconds: 3), () {
      _checkAuthenticationAndNavigate();
    });
  }

  /// Check if user is authenticated and navigate accordingly
  void _checkAuthenticationAndNavigate() {
    if (StorageService.isLoggedIn) {
      // User is logged in with valid access token, navigate to home screen
      Get.offAll(() => const BottomNavScreen());
    } else {
      // User is not logged in, navigate to auth screen
      Get.offAllNamed(AppRoute.authScreen);
    }
  }
}
