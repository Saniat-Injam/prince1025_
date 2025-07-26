import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prince1025/core/utils/constants/image_path.dart';
import 'package:prince1025/features/splash_screen/controller/splasho_screen_controller.dart';
// Make sure this path is correct

class SplashScreen extends GetView<SplashScreenController> {
  @override
  final SplashScreenController controller = Get.put(SplashScreenController());

  SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              isDark
                  ? ImagePath.darkSplashScreenbackground
                  : ImagePath.lightSplashScreenbackground,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(ImagePath.authLogo),
            const SizedBox(height: 20),

            const SizedBox(height: 10),
            const Text(
              "MANIFEST YOUR DREAMS",
              style: TextStyle(
                letterSpacing: 1.2,
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
