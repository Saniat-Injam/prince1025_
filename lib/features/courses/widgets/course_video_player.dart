// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:prince1025/core/common/styles/global_text_style.dart';
// import '../controllers/course_details_controller.dart';
// import '../models/course_model.dart';
// import '../models/lesson_model.dart';

// class CourseVideoPlayer extends StatelessWidget {
//   final Course course;
//   final Lesson? currentLesson;
//   final bool isDarkTheme;
//   final Color textColor;

//   const CourseVideoPlayer({
//     super.key,
//     required this.course,
//     required this.currentLesson,
//     required this.isDarkTheme,
//     required this.textColor,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<CourseDetailsController>();

//     return Container(
//       child: Column(
//         children: [
//           // Video Player Section
//           _buildVideoPlayer(controller),

//           // Course Info Section
//           _buildCourseInfo(controller),
//         ],
//       ),
//     );
//   }

//   Widget _buildVideoPlayer(CourseDetailsController controller) {
//     return Container(
//       height: 240,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: Colors.black,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Stack(
//         children: [
//           // Video Thumbnail/Player
//           ClipRRect(
//             borderRadius: BorderRadius.circular(12),
//             child: Image.network(
//               course.imageUrl,
//               height: 240,
//               width: double.infinity,
//               fit: BoxFit.cover,
//               errorBuilder: (context, error, stackTrace) {
//                 return Container(
//                   height: 240,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                       colors: [
//                         const Color(0xFF4E91FF).withValues(alpha: 0.8),
//                         const Color(0xFF1448CF).withValues(alpha: 0.8),
//                       ],
//                     ),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: const Center(
//                     child: Icon(
//                       Icons.play_circle_filled,
//                       size: 60,
//                       color: Colors.white,
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),

//           // Video Controls Overlay
//           Positioned.fill(
//             child: Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12),
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     Colors.transparent,
//                     Colors.black.withValues(alpha: 0.7),
//                   ],
//                 ),
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // Play/Pause Button
//                   Obx(
//                     () => GestureDetector(
//                       onTap: controller.playPause,
//                       child: Container(
//                         padding: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           color: Colors.white.withValues(alpha: 0.2),
//                           shape: BoxShape.circle,
//                         ),
//                         child: Icon(
//                           controller.isPlaying.value
//                               ? Icons.pause
//                               : Icons.play_arrow,
//                           size: 40,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           // Video Progress Bar
//           Positioned(
//             bottom: 20,
//             left: 20,
//             right: 20,
//             child: Obx(
//               () => Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Progress Slider
//                   SliderTheme(
//                     data: SliderTheme.of(Get.context!).copyWith(
//                       activeTrackColor: const Color(0xFF4E91FF),
//                       inactiveTrackColor: Colors.white.withValues(alpha: 0.3),
//                       thumbColor: const Color(0xFF4E91FF),
//                       thumbShape: const RoundSliderThumbShape(
//                         enabledThumbRadius: 8,
//                       ),
//                       trackHeight: 4,
//                     ),
//                     child: Slider(
//                       value: controller.videoProgress.value,
//                       onChanged: controller.seekTo,
//                       min: 0.0,
//                       max: 1.0,
//                     ),
//                   ),

//                   // Time Display
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         controller.currentTime.value,
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 12,
//                         ),
//                       ),
//                       Text(
//                         controller.videoDuration.value,
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 12,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           // Loading Indicator
//           Obx(
//             () =>
//                 controller.isVideoLoading.value
//                     ? const Center(
//                       child: CircularProgressIndicator(
//                         color: Color(0xFF4E91FF),
//                       ),
//                     )
//                     : const SizedBox.shrink(),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCourseInfo(CourseDetailsController controller) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Course Title and Subtitle
//           Text(
//             course.title,
//             style: TextStyle(
//               fontFamily: 'Enwallowify',
//               fontSize: 24,
//               fontWeight: FontWeight.w600,
//               color: textColor,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             course.subtitle,
//             style: getDMTextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w400,
//               color:
//                   isDarkTheme
//                       ? const Color(0xFFBEBEBE)
//                       : const Color(0xFF939393),
//             ),
//           ),
//           const SizedBox(height: 20),

//           // Progress Section
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Your progress',
//                     style: getDMTextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                       color: textColor,
//                     ),
//                   ),
//                   Text(
//                     controller.progressText,
//                     style: getDMTextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w500,
//                       color:
//                           isDarkTheme
//                               ? const Color(0xFFBEBEBE)
//                               : const Color(0xFF939393),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 12),

//               // Progress Bar
//               Container(
//                 height: 8,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(50),
//                   color:
//                       isDarkTheme
//                           ? const Color(0xFF2A2A2A)
//                           : const Color(0xFFE0E0E0),
//                 ),
//                 child: FractionallySizedBox(
//                   alignment: Alignment.centerLeft,
//                   widthFactor: controller.overallProgress,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(50),
//                       gradient: const LinearGradient(
//                         colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
