import 'package:flutter/material.dart';
import 'package:katlavan24/core/styles/app_colors.dart';
import 'package:katlavan24/core/styles/styles.dart';
import 'package:katlavan24/feat/auth/presentation/widgets/custom_text_field.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart' show MaskTextInputFormatter;


class PhoneNumberRow extends StatelessWidget {

  final bool filled;
  final TextEditingController controller;
  final MaskTextInputFormatter phoneFormatter;
  const PhoneNumberRow({required this.controller, super.key, this.filled = false, required, required this.phoneFormatter });


@override
Widget build(BuildContext context) {
  return Row(
    children: [
      Container(
        margin: EdgeInsets.only(right: 8),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Color(0xfff0f0f0)),
        child: Text('+998 ', style: AppStyles.s16w400.copyWith(color: AppColors.black, height: 24 / 16)),
      ),
      Expanded(
        child: CustomTextField(controller: controller, filled: filled, phoneFormatter: phoneFormatter),
      ),
    ],
  );
}
}
