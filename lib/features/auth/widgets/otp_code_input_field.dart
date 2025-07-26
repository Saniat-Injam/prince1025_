import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prince1025/features/auth/controllers/auth_controller.dart';

class OTPCodeInputField extends StatelessWidget {
  final int index;
  final AuthController authController = Get.find<AuthController>();

  OTPCodeInputField({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: Builder(
        builder:
            (context) => TextField(
              focusNode: authController.focusNodes[index],
              onChanged: (value) {
                authController.updateOTPCode(index, value);
                if (value.isNotEmpty) {
                  if (index < authController.focusNodes.length - 1) {
                    FocusScope.of(
                      context,
                    ).requestFocus(authController.focusNodes[index + 1]);
                  } else {
                    FocusScope.of(context).unfocus();
                  }
                } else if (value.isEmpty && index > 0) {
                  FocusScope.of(
                    context,
                  ).requestFocus(authController.focusNodes[index - 1]);
                }
              },
              textAlign: TextAlign.center,
              maxLength: 1,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                counterText: '',
                border: OutlineInputBorder(),
              ),
            ),
      ),
    );
  }
}
