import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:prince1025/core/common/styles/global_text_style.dart';
import 'package:prince1025/features/profile/controllers/profile_controller.dart';
import 'package:prince1025/core/utils/constants/svg_path.dart';
import 'package:prince1025/features/profile/widgets/custom_Input_textfield.dart';
import 'package:prince1025/features/profile/widgets/custom_ev_button.dart';

class ChangeNameSection extends StatelessWidget {
  final ProfileController controller;
  final TextEditingController nameController = TextEditingController();
  final bool isExpanded;
  final Function() onTap;
  final Color textColor;
  final Color? iconColor;

  ChangeNameSection({
    required this.controller,
    required this.isExpanded,
    required this.onTap,
    required this.textColor,
    required this.iconColor,
    super.key,
  }) {
    nameController.text = controller.name.value;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Change Name Header
        InkWell(
          onTap: onTap,
          child: Row(
            children: [
              SvgPicture.asset(
                SvgPath.changeNameSvg,
                width: 20,
                height: 20,
                colorFilter:
                    iconColor != null
                        ? ColorFilter.mode(iconColor!, BlendMode.srcIn)
                        : null,
              ),
              const SizedBox(width: 8),
              Text(
                'Change Name',
                style: getDMTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
              const Spacer(),
              isExpanded
                  ? SvgPicture.asset(
                    SvgPath.arrowDownSvg,
                    width: 20,
                    height: 20,
                    colorFilter:
                        iconColor != null
                            ? ColorFilter.mode(iconColor!, BlendMode.srcIn)
                            : null,
                  )
                  : SvgPicture.asset(
                    SvgPath.rightArrowSvg,
                    width: 20,
                    height: 20,
                    colorFilter:
                        iconColor != null
                            ? ColorFilter.mode(iconColor!, BlendMode.srcIn)
                            : null,
                  ),
            ],
          ),
        ),

        // Expandable content
        if (isExpanded)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              CustomInputTextField(
                controller: nameController,
                hint: 'Enter your full name',
              ),
              const SizedBox(height: 16),
              CustomEVButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty) {
                    controller.changeName(nameController.text);
                    onTap(); // Close the expanded section
                  }
                },
                text: 'Save Changes',
              ),
              const SizedBox(height: 8),
            ],
          ),
      ],
    );
  }
}
