import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:katlavan24/core/styles/app_colors.dart';
import 'package:katlavan24/core/styles/styles.dart';

class OutlinedTextFormField extends StatelessWidget {
  const OutlinedTextFormField(
      {super.key,
        this.focusNode,
        required this.controller,
        this.textInputType = TextInputType.number,
        this.inputFormatters,
        required this.label});

  final FocusNode? focusNode;
  final TextEditingController controller;
  final TextInputType textInputType;
  final List<TextInputFormatter>? inputFormatters;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      inputFormatters: inputFormatters ?? [FilteringTextInputFormatter.digitsOnly],
      controller: controller,
      keyboardType: textInputType,
      style: AppStyles.s14.copyWith(height: 24 / 14, color: AppColors.grayColor),
      decoration: InputDecoration(
        hintText: label,
        isDense: true,
        hintStyle: AppStyles.s14.copyWith(height: 24 / 14, color: AppColors.grayColor),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppColors.grayLight4)),
        contentPadding: EdgeInsets.all(12),
      ),
    );
  }
}
