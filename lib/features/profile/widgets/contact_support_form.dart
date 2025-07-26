import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prince1025/core/common/styles/global_text_style.dart';
import 'package:prince1025/features/profile/controllers/contact_support_controller.dart';
import 'package:prince1025/features/profile/widgets/custom_form_field.dart';
import 'package:prince1025/features/profile/widgets/custom_ev_button.dart';

class ContactSupportForm extends StatelessWidget {
  final bool isDarkTheme;
  final Color textColor;

  const ContactSupportForm({
    super.key,
    required this.isDarkTheme,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ContactSupportController>();

    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact Form',
            style: getDMTextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(height: 16),

          // Name field
          CustomFormField(
            controller: controller.nameController,
            hint: 'Enter your name',
            validator: controller.validateName,
            prefixIcon: Icon(
              Icons.person_outline,
              color: isDarkTheme ? Colors.white : null,
            ),
          ),
          const SizedBox(height: 16),

          // Email field
          CustomFormField(
            controller: controller.emailController,
            hint: 'Enter your email',
            validator: controller.validateEmail,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icon(
              Icons.email_outlined,
              color: isDarkTheme ? Colors.white : null,
            ),
          ),
          const SizedBox(height: 16),

          // Opinion/Message field
          SizedBox(
            height: 120,
            child: CustomFormField(
              controller: controller.messageController,
              hint: 'Share your opinion about our platform',
              validator: controller.validateOpinion,
              maxLines: 5,
            ),
          ),
          const SizedBox(height: 32),

          // Submit Button
          Obx(
            () => CustomEVButton(
              onPressed: () {
                if (!controller.isLoading.value) {
                  controller.submitForm();
                }
              },
              text: controller.isLoading.value ? 'Sending...' : 'Submit',
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
