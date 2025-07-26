import 'package:flutter/material.dart';
import 'package:prince1025/core/utils/constants/colors.dart';
import 'package:prince1025/core/utils/constants/image_path.dart';

class ChangedSuccessScreen extends StatelessWidget {
  const ChangedSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImagePath.darkSendSuccessScreenbackground),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: isDarkTheme ? Colors.transparent : Colors.white,
        body: Center(
          child: Text(
            'Successfully changed',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              fontFamily: 'Enwallowify',
              color:
                  isDarkTheme
                      ? AppColors.textdarkmode
                      : AppColors.textlightmode,
            ),
          ),
        ),
      ),
    );
  }
}
