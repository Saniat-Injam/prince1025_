import 'package:flutter/material.dart';

class CustomGradientButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Gradient gradient;
  final double borderRadius;
  final double height;

  const CustomGradientButton({
    super.key,
    required this.onPressed,
    required this.child,
    required this.gradient,
    this.borderRadius = 12.0,
    this.height = 48.0,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null;

    return GestureDetector(
      onTap: isDisabled ? null : onPressed,
      child: Opacity(
        opacity: isDisabled ? 0.5 : 1.0,
        child: Container(
          height: height,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          alignment: Alignment.center,
          child: DefaultTextStyle(
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
