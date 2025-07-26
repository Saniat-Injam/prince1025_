import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prince1025/core/common/styles/global_text_style.dart';
import 'package:prince1025/core/utils/constants/colors.dart';
import 'package:prince1025/core/utils/constants/image_path.dart';

class SendSuccessScreen extends StatelessWidget {
  const SendSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final String? backgroundImage =
        isDarkTheme ? ImagePath.darkSendSuccessScreenbackground : null;

    return Container(
      decoration: BoxDecoration(
        image:
            isDarkTheme && backgroundImage != null
                ? DecorationImage(
                  image: AssetImage(backgroundImage),
                  fit: BoxFit.cover,
                )
                : null,
        color: isDarkTheme ? null : Colors.white,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: isDarkTheme ? Colors.white : Colors.black,
            ),
            onPressed: () => Get.back(),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Success Icon
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green.withValues(alpha: 0.1),
                    border: Border.all(color: Colors.green, width: 2),
                  ),
                  child: const Icon(Icons.check, size: 50, color: Colors.green),
                ),
                const SizedBox(height: 32),

                // Success Title
                Text(
                  'Message Sent Successfully!',
                  textAlign: TextAlign.center,
                  style: getDMTextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color:
                        isDarkTheme
                            ? AppColors.textdarkmode
                            : AppColors.textlightmode,
                  ),
                ),
                const SizedBox(height: 16),

                // Success Description
                Text(
                  'Thank you for reaching out to us. We have received your message and our support team will get back to you shortly.',
                  textAlign: TextAlign.center,
                  style: getDMTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: (isDarkTheme
                            ? AppColors.textdarkmode
                            : AppColors.textlightmode)
                        .withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 48),

                // Return Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Go back to previous screen (contact support screen)
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isDarkTheme
                              ? AppColors.primaryDarkBlue
                              : AppColors.primaryDarkBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Back to Contact Support',
                      style: getDMTextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
