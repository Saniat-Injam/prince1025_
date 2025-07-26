import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:prince1025/core/models/user_model.dart';
import 'package:prince1025/core/services/api_caller.dart';
import 'package:prince1025/core/services/auth_api_service.dart';
import 'package:prince1025/core/services/storage_service.dart';
import 'package:prince1025/core/utils/constants/api_constants.dart';
import 'package:prince1025/features/auth/controllers/auth_controller.dart';
import 'package:prince1025/features/profile/widgets/profile_image_picker_sheet.dart';
import 'package:prince1025/routes/app_routes.dart';

class ProfileController extends GetxController {
  // User information
  final RxString name = ''.obs;
  final RxString email = ''.obs;
  final RxString phoneNumber = ''.obs;
  final RxString userId = ''.obs;
  final RxString userRole = ''.obs;

  final RxString profileImage = 'assets/images/userprofile.png'.obs;
  final Rx<File?> selectedImageFile = Rx<File?>(null);
  final RxBool isLoading = false.obs;

  // Complete user model with subscription data
  final Rx<UserModel?> userModel = Rx<UserModel?>(null);

  // Subscription information
  final RxBool isPremium = false.obs;
  final RxString subscriptionType = 'Premium Yearly'.obs;
  final RxBool isActive = false.obs;
  final RxString renewalDate = 'June 15, 2025'.obs;

  final Logger logger = Logger();

  @override
  void onInit() {
    super.onInit();
    _loadUserDataFromStorage();
    // Also fetch fresh data from API to ensure we have the latest information
    fetchUserProfileFromApi();
  }

  /// Load user data from StorageService when controller initializes
  void _loadUserDataFromStorage() {
    try {
      final userData = StorageService.getUserData();
      if (userData != null) {
        // Set the complete user model
        userModel.value = userData;

        // Update observable values with data from storage
        name.value = userData.fullName.isNotEmpty ? userData.fullName : 'User';
        email.value =
            userData.email.isNotEmpty ? userData.email : 'user@example.com';
        phoneNumber.value =
            userData.phoneNumber.isNotEmpty ? userData.phoneNumber : '';
        userId.value = userData.id;
        userRole.value = userData.role;

        // Set profile image - use stored photo URL if available, otherwise default
        if (userData.photo != null && userData.photo!.isNotEmpty) {
          profileImage.value = userData.photo!;
        } else {
          profileImage.value = 'assets/images/userprofile.png';
        }

        // Update subscription status
        isPremium.value = userData.isSubscribed;
        isActive.value = userData.isSubscribed;

        logger.i('✅ User data loaded from storage: ${userData.fullName}');
      } else {
        logger.w('⚠️ No user data found in storage, will fetch from API');
        // Set loading placeholders if no user data is stored
        name.value = 'Loading...';
        email.value = 'Loading...';
        phoneNumber.value = '';
        profileImage.value = 'assets/images/userprofile.png';
      }
    } catch (e) {
      logger.e('❌ Error loading user data from storage: $e');
      // Fallback to loading placeholders
      name.value = 'Loading...';
      email.value = 'Loading...';
      phoneNumber.value = '';
      profileImage.value = 'assets/images/userprofile.png';
    }
  }

  /// Refresh user data from storage - call this when user data is updated
  void refreshUserData() {
    logger.i('🔄 Refreshing user data from storage');
    _loadUserDataFromStorage();
  }

  /// Fetch user profile data from API and update storage
  Future<void> fetchUserProfileFromApi() async {
    try {
      logger.i('🔄 Fetching user profile from API');

      // Check if user is logged in
      final token = StorageService.token;
      if (token == null || token.isEmpty) {
        logger.e('❌ No token found in storage');
        return;
      }

      // Use ApiCaller to fetch user profile
      await ApiCaller.get(
        endpoint: ApiConstants.userProfile,
        showLoading: false, // Don't show loading for background fetch
        onSuccess: (data) {
          logger.i('✅ User profile fetched successfully');

          // Parse the response data into UserModel
          // Based on API response, data should be the user object directly
          if (data != null) {
            final user = UserModel.fromJson(data);

            // Save complete user data to storage
            StorageService.saveUserData(user);

            // Update the complete user model
            userModel.value = user;

            // Update observable values with fresh data
            name.value = user.fullName;
            email.value = user.email;
            phoneNumber.value = user.phoneNumber;
            userId.value = user.id;
            userRole.value = user.role;

            // Set profile image - use stored photo URL if available, otherwise default
            if (user.photo != null && user.photo!.isNotEmpty) {
              profileImage.value = user.photo!;
            } else {
              profileImage.value = 'assets/images/userprofile.png';
            }

            // Update subscription status based on actual subscription data
            isPremium.value = user.isSubscribed && user.hasActiveSubscription;
            isActive.value = user.isSubscribed && user.hasActiveSubscription;

            // Update subscription type from actual subscription data
            final currentSubscription = user.currentSubscription;
            if (currentSubscription?.plan != null) {
              subscriptionType.value = currentSubscription!.plan!.name;
              renewalDate.value = currentSubscription.formattedEndDate;
            }

            logger.i('✅ User data updated from API: ${user.fullName}');
            logger.i(
              '🔔 Subscription status: isPremium=${isPremium.value}, hasActiveSubscription=${user.hasActiveSubscription}',
            );
          } else {
            logger.w('⚠️ Invalid API response format');
          }

          return data;
        },
        onError: (error) {
          logger.e('❌ Failed to fetch user profile: $error');
          // Don't show error to user for background fetch
          // The app will continue to work with cached data
        },
      );
    } catch (e) {
      logger.e('❌ Exception while fetching user profile: $e');
    }
  }

  /// Refresh user profile data from API (can be called manually)
  Future<void> refreshUserProfileFromApi() async {
    try {
      isLoading.value = true;

      logger.i('🔄 Manually refreshing user profile from API');

      // Check if user is logged in
      final token = StorageService.token;
      if (token == null || token.isEmpty) {
        logger.e('❌ No token found in storage');
        EasyLoading.showError(
          'Authentication token not found. Please login again.',
        );
        return;
      }

      // Use ApiCaller to fetch user profile with loading indicator
      await ApiCaller.get(
        endpoint: ApiConstants.userProfile,
        showLoading: true,
        loadingMessage: 'Updating profile...',
        onSuccess: (data) {
          logger.i('✅ User profile refreshed successfully');

          // Parse the response data into UserModel
          // Based on API response, data should be the user object directly
          if (data != null) {
            final user = UserModel.fromJson(data);

            // Save complete user data to storage
            StorageService.saveUserData(user);

            // Update the complete user model
            userModel.value = user;

            // Update observable values with fresh data
            name.value = user.fullName;
            email.value = user.email;
            phoneNumber.value = user.phoneNumber;
            userId.value = user.id;
            userRole.value = user.role;

            // Set profile image - use stored photo URL if available, otherwise default
            if (user.photo != null && user.photo!.isNotEmpty) {
              profileImage.value = user.photo!;
            } else {
              profileImage.value = 'assets/images/userprofile.png';
            }

            // Update subscription status based on actual subscription data
            isPremium.value = user.isSubscribed && user.hasActiveSubscription;
            isActive.value = user.isSubscribed && user.hasActiveSubscription;

            // Update subscription type from actual subscription data
            final currentSubscription = user.currentSubscription;
            if (currentSubscription?.plan != null) {
              subscriptionType.value = currentSubscription!.plan!.name;
              renewalDate.value = currentSubscription.formattedEndDate;
            }

            EasyLoading.showSuccess('Profile updated successfully!');
            logger.i('✅ User data refreshed from API: ${user.fullName}');
            logger.i(
              '🔔 Subscription status: isPremium=${isPremium.value}, hasActiveSubscription=${user.hasActiveSubscription}',
            );
          } else {
            logger.w('⚠️ Invalid API response format');
            EasyLoading.showError('Invalid response format');
          }

          return data;
        },
        onError: (error) {
          logger.e('❌ Failed to refresh user profile: $error');
          EasyLoading.showError(error);
        },
      );
    } catch (e) {
      logger.e('❌ Exception while refreshing user profile: $e');
      EasyLoading.showError('An unexpected error occurred. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  /// Update user profile (name, email, phone, photo) using PATCH API
  Future<void> updateUserProfile({
    String? fullName,
    String? email,
    String? phoneNumber,
    File? imageFile,
  }) async {
    try {
      isLoading.value = true;
      logger.i('🔄 Updating user profile via API');

      // Check if user is logged in
      final token = StorageService.token;
      if (token == null || token.isEmpty) {
        logger.e('❌ No token found in storage');
        EasyLoading.showError(
          'Authentication token not found. Please login again.',
        );
        return;
      }

      // Prepare form data for multipart request
      final formData = dio.FormData();

      // Add text fields if provided
      if (fullName != null && fullName.trim().isNotEmpty) {
        formData.fields.add(MapEntry('fullName', fullName.trim()));
      }
      if (email != null && email.trim().isNotEmpty) {
        formData.fields.add(MapEntry('email', email.trim()));
      }
      if (phoneNumber != null && phoneNumber.trim().isNotEmpty) {
        formData.fields.add(MapEntry('phoneNumber', phoneNumber.trim()));
      }

      // Add image file if provided
      if (imageFile != null) {
        final fileName = imageFile.path.split('/').last;
        formData.files.add(
          MapEntry(
            'file',
            await dio.MultipartFile.fromFile(
              imageFile.path,
              filename: fileName,
            ),
          ),
        );
      }

      logger.i('🔄 Calling update profile API with form data');

      // Show loading indicator
      EasyLoading.show(status: 'Updating profile...');

      try {
        // Use dio directly for multipart FormData since ApiCaller expects Map<String, dynamic>
        final dioInstance = AuthApiService.getDio();
        final response = await dioInstance.patch(
          ApiConstants.userUpdate,
          data: formData,
        );

        // Dismiss loading
        EasyLoading.dismiss();

        // Check if response is successful
        if (response.statusCode == 200 || response.statusCode == 201) {
          logger.i('✅ Profile updated successfully');

          // Parse the updated user data
          if (response.data != null) {
            final userModel = UserModel.fromJson(response.data);

            // Save updated user data to storage
            StorageService.saveUserData(userModel);

            // Update the complete user model
            this.userModel.value = userModel;

            // Update observable values with fresh data
            name.value = userModel.fullName;
            this.email.value = userModel.email;
            this.phoneNumber.value = userModel.phoneNumber;
            userId.value = userModel.id;
            userRole.value = userModel.role;

            // Set profile image - use updated photo URL if available
            if (userModel.photo != null && userModel.photo!.isNotEmpty) {
              profileImage.value = userModel.photo!;
            } else {
              profileImage.value = 'assets/images/userprofile.png';
            }

            // Update subscription status
            isPremium.value = userModel.isSubscribed;
            isActive.value = userModel.isSubscribed;

            // Clear selected image file as it's now uploaded
            selectedImageFile.value = null;

            EasyLoading.showSuccess('Profile updated successfully!');
            logger.i('✅ Profile data updated from API: ${userModel.fullName}');
          } else {
            logger.w('⚠️ Invalid API response format');
            EasyLoading.showError('Invalid response format');
          }
        } else {
          logger.e('❌ Failed to update profile: ${response.statusMessage}');
          EasyLoading.showError(
            response.statusMessage ?? 'Failed to update profile',
          );
        }
      } on dio.DioException catch (dioError) {
        EasyLoading.dismiss();
        logger.e('❌ Dio error updating profile: ${dioError.message}');

        // Handle different types of Dio errors
        if (dioError.response?.data != null) {
          final errorMessage =
              dioError.response?.data['message'] ?? 'Failed to update profile';
          EasyLoading.showError(errorMessage);
        } else {
          EasyLoading.showError('Network error. Please check your connection.');
        }
      } catch (error) {
        EasyLoading.dismiss();
        logger.e('❌ Unexpected error updating profile: $error');
        EasyLoading.showError(
          'An unexpected error occurred. Please try again.',
        );
      }
    } catch (e) {
      logger.e('❌ Exception while updating profile: $e');
      EasyLoading.showError('An unexpected error occurred. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  // Settings related methods
  void changeName(String newName) {
    if (newName.isNotEmpty && newName.trim().isNotEmpty) {
      // Update profile via API which will also update storage
      updateUserProfile(fullName: newName.trim());
    }
  }

  //!=======================Change user password Api=======================
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      isLoading.value = true;
      logger.i('🔐 Attempting to change password');

      // Check if user is logged in
      final token = StorageService.token;
      if (token == null || token.isEmpty) {
        logger.e('❌ No token found in storage');
        EasyLoading.showError(
          'Authentication token not found. Please login again.',
        );
        return;
      }

      // Prepare request body
      final requestBody = {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      };

      logger.i('🔐 Calling change password API with body: $requestBody');

      // Use ApiCaller for consistent error handling with PATCH method
      await ApiCaller.patch(
        endpoint: ApiConstants.changePassword,
        data: requestBody,
        showLoading: true,
        loadingMessage: 'Changing password...',
        onSuccess: (data) {
          logger.i('✅ Password changed successfully');
          EasyLoading.showSuccess('Password changed successfully!');
          return data;
        },
        onError: (error) {
          logger.e('❌ Change password error: $error');
          EasyLoading.showError(error);
          // ApiCaller already handles showing the error message
          // The error parameter contains the proper API error message
        },
      );
    } catch (e) {
      logger.e('❌ Change password exception: $e');
      EasyLoading.showError('An unexpected error occurred. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  void logOut() {
    // Use AuthController's logout functionality to clear tokens and navigate
    try {
      final authController = Get.find<AuthController>();
      authController.logout();
      logger.i('📤 Logout initiated from profile screen');
    } catch (e) {
      logger.e('❌ Error during logout: $e');
      // Fallback: navigate directly to splash screen
      Get.offAllNamed(AppRoute.splashScreen);
    }
  }

  void manageSubscription() {
    // Implement subscription management logic
    // This would typically navigate to subscription management screen
  }

  // Image picker methods
  Future<void> pickImage(ImageSource source) async {
    try {
      isLoading.value = true;

      // For iOS simulator, try direct image picker approach first
      if (Platform.isIOS) {
        await _pickImageDirectly(source);
      } else {
        // For Android, use permission handler approach
        bool hasPermission = false;
        if (source == ImageSource.camera) {
          hasPermission = await _requestCameraPermission();
        } else {
          hasPermission = await _requestGalleryPermission();
        }

        if (!hasPermission) {
          Get.snackbar(
            'Permission Denied',
            'Please grant permission to access ${source == ImageSource.camera ? 'camera' : 'gallery'}',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3),
            mainButton: TextButton(
              onPressed: () => openAppSettings(),
              child: const Text(
                'SETTINGS',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
          return;
        }

        await _pickImageDirectly(source);
      }
    } catch (error) {
      logger.e('Error picking image: $error');
      Get.snackbar(
        'Error',
        'Failed to pick image: $error',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Direct image picker method
  Future<void> _pickImageDirectly(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );

      if (image != null) {
        selectedImageFile.value = File(image.path);
        await uploadProfileImage();
      }
    } catch (error) {
      logger.e('Error in direct image picker: $error');
      // If direct picker fails, try with permission request
      if (Platform.isIOS) {
        bool hasPermission = false;
        if (source == ImageSource.camera) {
          hasPermission = await _requestCameraPermission();
        } else {
          hasPermission = await _requestGalleryPermission();
        }

        if (hasPermission) {
          final ImagePicker picker = ImagePicker();
          final XFile? image = await picker.pickImage(
            source: source,
            maxWidth: 1000,
            maxHeight: 1000,
            imageQuality: 85,
          );

          if (image != null) {
            selectedImageFile.value = File(image.path);
            await uploadProfileImage();
          }
        }
      }
      rethrow;
    }
  }

  // Request camera permission
  Future<bool> _requestCameraPermission() async {
    try {
      final status = await Permission.camera.status;
      logger.i('Camera permission status: $status');

      if (status.isGranted) {
        return true;
      } else if (status.isDenied || status.isRestricted) {
        logger.i('Requesting camera permission...');
        final result = await Permission.camera.request();
        logger.i('Camera permission result: $result');
        return result.isGranted;
      } else if (status.isPermanentlyDenied) {
        // Show dialog to open app settings
        _showPermissionSettingsDialog('Camera');
        return false;
      }

      // If status is undetermined, try to request
      logger.i('Requesting camera permission (undetermined)...');
      final result = await Permission.camera.request();
      logger.i('Camera permission result (undetermined): $result');
      return result.isGranted;
    } catch (e) {
      logger.e('Error requesting camera permission: $e');
      return false;
    }
  }

  // Request gallery permission
  Future<bool> _requestGalleryPermission() async {
    try {
      Permission permission;
      String permissionName;

      if (Platform.isAndroid) {
        // For Android 13+, use photos permission
        permission = Permission.photos;
        permissionName = 'Photos';
      } else if (Platform.isIOS) {
        // For iOS, use photos permission
        permission = Permission.photos;
        permissionName = 'Photos';
      } else {
        return false;
      }

      final status = await permission.status;
      logger.i('$permissionName permission status: $status');

      if (status.isGranted) {
        return true;
      } else if (status.isDenied || status.isRestricted) {
        logger.i('Requesting $permissionName permission...');
        final result = await permission.request();
        logger.i('$permissionName permission result: $result');
        return result.isGranted;
      } else if (status.isPermanentlyDenied) {
        // Show dialog to open app settings
        _showPermissionSettingsDialog(permissionName);
        return false;
      }

      // If status is undetermined, try to request
      logger.i('Requesting $permissionName permission (undetermined)...');
      final result = await permission.request();
      logger.i('$permissionName permission result (undetermined): $result');
      return result.isGranted;
    } catch (e) {
      logger.e('Error requesting gallery permission: $e');
      return false;
    }
  }

  // Show dialog to open app settings for permanently denied permissions
  void _showPermissionSettingsDialog(String permissionName) {
    Get.dialog(
      AlertDialog(
        title: Text('Permission Required'),
        content: Text(
          '$permissionName permission is required to continue. Please enable it in app settings.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              openAppSettings();
            },
            child: Text('Settings'),
          ),
        ],
      ),
    );
  }

  // Method to show bottom sheet for image selection
  void showImagePickerSheet() {
    Get.bottomSheet(
      ProfileImagePickerSheet(controller: this),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      enableDrag: true,
      backgroundColor: Get.theme.scaffoldBackgroundColor,
    );
  }

  // Mock method to simulate uploading to a server
  Future<void> uploadProfileImage() async {
    try {
      // Use the new updateUserProfile method to upload the image
      if (selectedImageFile.value != null) {
        await updateUserProfile(imageFile: selectedImageFile.value!);
      }
    } catch (error) {
      logger.e('Error uploading profile image: $error');
      EasyLoading.showError('Failed to update profile image: $error');
    }
  }
}
