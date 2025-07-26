import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prince1025/core/utils/constants/colors.dart';
import 'package:prince1025/core/utils/constants/image_path.dart';
import 'package:prince1025/features/auth/controllers/auth_controller.dart';
import 'package:prince1025/features/auth/widgets/login_form.dart';
import 'package:prince1025/features/auth/widgets/registration_form.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    AuthController authController = Get.find<AuthController>();

    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final String backgroundImage =
        isDark
            ? ImagePath.darkLoginScreenbackground
            : ImagePath.lightLoginScreenbackground;

    Widget blurredContainer(Widget child) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child:
            isDark
                ? child // No blur in dark mode
                : BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                  child: child,
                ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(15, 50, 15, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(ImagePath.authLogo),
                  SizedBox(height: screenHeight * 0.05), // 5% of screen height
                  // Blurred Container only in light mode
                  blurredContainer(
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 40,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isDark
                                ? Colors.transparent
                                : Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(() {
                            final isLogin = authController.isLogin.value;
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  // color: AppColors.primaryWhite.withValues(
                                  //   alpha: 0.2,
                                  // ),
                                  color:
                                      Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? AppColors.primaryWhite.withValues(
                                            alpha: 0.2,
                                          )
                                          : AppColors.secondaryWhite.withValues(
                                            alpha: 0.7,
                                          ),
                                ),
                              ),

                              // Login and Register toogle button row
                              child: Row(
                                children: [
                                  //
                                  Expanded(
                                    child: GestureDetector(
                                      onTap:
                                          () =>
                                              authController.isLogin.value =
                                                  true,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color:
                                              isLogin
                                                  ? Theme.of(
                                                    context,
                                                  ).primaryColor
                                                  : Colors.transparent,

                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                          border:
                                              isLogin
                                                  ? Border.all(
                                                    color: AppColors
                                                        .primaryWhite
                                                        .withValues(alpha: 0.2),
                                                  )
                                                  : null,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Login",
                                            style:
                                                Theme.of(
                                                  context,
                                                ).textTheme.bodyLarge,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Register Container
                                  Expanded(
                                    child: GestureDetector(
                                      onTap:
                                          () =>
                                              authController.isLogin.value =
                                                  false,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color:
                                              !isLogin
                                                  ? Theme.of(
                                                    context,
                                                  ).primaryColor
                                                  : Colors.transparent,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                          border:
                                              !isLogin
                                                  ? Border.all(
                                                    color: AppColors
                                                        .primaryWhite
                                                        .withValues(alpha: 0.2),
                                                  )
                                                  : null,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Register",
                                            style:
                                                Theme.of(
                                                  context,
                                                ).textTheme.bodyLarge,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),

                          const SizedBox(height: 20),
                          Obx(
                            () =>
                                authController.isLogin.value
                                    ? LoginForm(authController: authController)
                                    : const EnhancedRegistrationForm(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
