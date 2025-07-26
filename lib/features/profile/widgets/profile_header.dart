import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prince1025/core/common/styles/global_text_style.dart';
import 'package:prince1025/features/profile/controllers/profile_controller.dart';
import 'package:flutter_svg/svg.dart';
import 'package:prince1025/core/utils/constants/svg_path.dart';
import 'package:prince1025/core/common/widgets/custom_container.dart';

class ProfileHeader extends StatelessWidget {
  final ProfileController profileController;
  final bool isDarkTheme;
  final Color containerColor;
  final Color shadowColor;
  final Color textColor;

  const ProfileHeader({
    required this.profileController,
    required this.isDarkTheme,
    required this.containerColor,
    required this.shadowColor,
    required this.textColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // User profile section
        CustomContainer(
          isDarkTheme: isDarkTheme,
          borderRadius: 12,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 16.0,
            ),
            child: Row(
              children: [
                // Profile Image
                Stack(
                  children: [
                    Obx(() {
                      String imagePath = profileController.profileImage.value;
                      return Stack(
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundColor: Colors.grey.shade200,
                            backgroundImage: _getImageProvider(imagePath),
                            // Add error handling for network images
                            onBackgroundImageError: (exception, stackTrace) {
                              // If network image fails to load, fallback to default
                              profileController.profileImage.value =
                                  'assets/images/userprofile.png';
                            },
                          ),
                          if (profileController.isLoading.value)
                            Positioned.fill(
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.black26,
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    }),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: GestureDetector(
                        onTap: () => profileController.showImagePickerSheet(),
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: SvgPicture.asset(
                              SvgPath.cameraSvg,
                              width: 16,
                              height: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                // User details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () => Text(
                          profileController.name.value,
                          style: TextStyle(
                            fontFamily: 'Enwallowify',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Obx(
                        () => Text(
                          profileController.email.value,
                          style: getDMTextStyle(fontSize: 14, color: textColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Helper method to get the appropriate image provider
  ImageProvider _getImageProvider(String imagePath) {
    // If a local file is selected, use FileImage
    if (profileController.selectedImageFile.value != null) {
      return FileImage(profileController.selectedImageFile.value!);
    }
    // If imagePath is an asset path, use AssetImage
    else if (imagePath.startsWith('assets/')) {
      return AssetImage(imagePath);
    }
    // If imagePath is a network URL, use NetworkImage
    else if (imagePath.startsWith('http://') ||
        imagePath.startsWith('https://')) {
      return NetworkImage(imagePath);
    }
    // If imagePath is a local file path, use FileImage
    else {
      try {
        final file = File(imagePath);
        if (file.existsSync()) {
          return FileImage(file);
        } else {
          // File doesn't exist, fallback to default image
          return const AssetImage('assets/images/userprofile.png');
        }
      } catch (e) {
        // Fallback to default image if any error occurs
        return const AssetImage('assets/images/userprofile.png');
      }
    }
  }
}
