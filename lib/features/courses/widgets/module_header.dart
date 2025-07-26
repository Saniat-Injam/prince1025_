import 'package:flutter/material.dart';
import '../models/lesson_model.dart';

class ModuleHeader extends StatelessWidget {
  final CourseModule module;
  final bool isDarkTheme;
  final Color textColor;

  const ModuleHeader({
    super.key,
    required this.module,
    required this.isDarkTheme,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      module.title,
      style: TextStyle(
        fontFamily: 'Enwallowify',
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
    );
  }
}
