import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prince1025/core/common/widgets/custom_container.dart';
import 'package:prince1025/core/utils/constants/colors.dart';
import 'package:prince1025/features/profile/controllers/profile_controller.dart';

/// Profile image picker bottom sheet widget
/// Provides options to take photo or choose from gallery
/// Matches the settings screen design with proper theming
class ProfileImagePickerSheet extends StatelessWidget {
  final ProfileController controller;

  const ProfileImagePickerSheet({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkTheme ? Color(0xFFF5F5F5) : Colors.black87;
    final iconColor =
        isDarkTheme ? Color(0xFFF5F5F5) : AppColors.primaryDarkBlue;
    final dividerColor = isDarkTheme ? Color(0xFF635C6E) : Color(0xffD1EFFB);

    return Container(
      decoration: BoxDecoration(
        color: isDarkTheme ? Color(0xFF1E1E1E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 5,
            margin: const EdgeInsets.only(top: 12, bottom: 20),
            decoration: BoxDecoration(
              color: isDarkTheme ? Colors.grey.shade600 : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(5),
            ),
          ),

          // Content container matching settings screen style
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CustomContainer(
              isDarkTheme: isDarkTheme,
              borderRadius: 12,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      'Update Profile Photo',
                      style: TextStyle(
                        fontFamily: 'Enwallowify',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildDivider(dividerColor),

                    // Take photo option
                    _ProfileImageOption(
                      icon: Icons.camera_alt_rounded,
                      title: 'Take a photo',
                      subtitle: 'Use your camera',
                      textColor: textColor,
                      iconColor: iconColor,
                      onTap: () {
                        Get.back();
                        controller.pickImage(ImageSource.camera);
                      },
                    ),

                    _buildDivider(dividerColor),

                    // Choose from gallery option
                    _ProfileImageOption(
                      icon: Icons.photo_library_rounded,
                      title: 'Choose from gallery',
                      subtitle: 'Select a single image',
                      textColor: textColor,
                      iconColor: iconColor,
                      onTap: () {
                        Get.back();
                        controller.pickImage(ImageSource.gallery);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Cancel button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  foregroundColor:
                      isDarkTheme ? Colors.white : Colors.grey.shade700,
                  backgroundColor:
                      isDarkTheme ? Color(0xFF2D2D2D) : Colors.grey.shade200,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),

          // Bottom padding
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  /// Build divider matching settings screen style
  Widget _buildDivider(Color dividerColor) {
    return Divider(color: dividerColor, thickness: 0.8, height: 14);
  }
}

/// Individual option item for the profile image picker
class _ProfileImageOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color textColor;

  const _ProfileImageOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.textColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            // Icon container matching settings screen style
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: (iconColor ?? Colors.blue).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor ?? Colors.blue, size: 20),
            ),
            const SizedBox(width: 12),

            // Title and subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Enwallowify',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: 'Enwallowify',
                      fontSize: 14,
                      color: textColor.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),

            // Arrow icon
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: textColor.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}
