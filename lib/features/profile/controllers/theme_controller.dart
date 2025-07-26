import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prince1025/core/utils/constants/colors.dart';
import 'package:logger/logger.dart';

class ThemeController extends GetxController {
  final RxString currentTheme = 'system'.obs;
  final RxBool isThemeExpanded = false.obs;

  final List<String> themeOptions = ['system', 'light', 'dark'];

  final Logger logger = Logger();

  @override
  void onInit() {
    super.onInit();
    _loadTheme();
  }

  // Load theme from SharedPreferences
  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      currentTheme.value = prefs.getString('theme') ?? 'system';
      _applyTheme(currentTheme.value);
    } catch (e) {
      logger.e('Error loading theme: $e');
    }
  }

  // Save theme to SharedPreferences
  Future<void> _saveTheme(String theme) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('theme', theme);
    } catch (e) {
      logger.e('Error saving theme: $e');
    }
  }

  // Toggle theme expansion
  void toggleThemeExpansion() {
    isThemeExpanded.value = !isThemeExpanded.value;
  }

  // Change theme
  void changeTheme(String theme) {
    currentTheme.value = theme;
    _applyTheme(theme);
    _saveTheme(theme);
    isThemeExpanded.value = false;

    Get.snackbar(
      'Theme Changed',
      'Theme switched to ${_getThemeDisplayName(theme)}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.primaryDarkBlue,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  // Apply theme to the app
  void _applyTheme(String theme) {
    switch (theme) {
      case 'light':
        Get.changeThemeMode(ThemeMode.light);
        break;
      case 'dark':
        Get.changeThemeMode(ThemeMode.dark);
        break;
      case 'system':
      default:
        Get.changeThemeMode(ThemeMode.system);
        break;
    }
  }

  // Get theme display name
  String _getThemeDisplayName(String theme) {
    switch (theme) {
      case 'light':
        return 'Light Mode';
      case 'dark':
        return 'Dark Mode';
      case 'system':
      default:
        return 'System Default';
    }
  }

  // Get current theme display name
  String get currentThemeDisplayName =>
      _getThemeDisplayName(currentTheme.value);

  // Get theme icon
  IconData getThemeIcon(String theme) {
    switch (theme) {
      case 'light':
        return Icons.light_mode;
      case 'dark':
        return Icons.dark_mode;
      case 'system':
      default:
        return Icons.settings_brightness;
    }
  }

  // Get current theme icon
  IconData get currentThemeIcon => getThemeIcon(currentTheme.value);
}
