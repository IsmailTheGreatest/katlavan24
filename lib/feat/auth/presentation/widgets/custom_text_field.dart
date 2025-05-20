import 'package:flutter/material.dart';
import 'package:katlavan24/core/styles/styles.dart';
import 'package:katlavan24/gen_l10n/app_localizations.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.labelText,
    required this.controller,
    required this.filled,
     this.phoneFormatter,
  });

  final TextEditingController controller;
  final bool filled;
  final String? labelText;
  final MaskTextInputFormatter? phoneFormatter;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        filled: filled ? true : false,
        fillColor: Color(0xfff0f0f0),
        focusedBorder: filled?OutlineInputBorder(borderSide: BorderSide(color: Color(0xfff0f0f0)), borderRadius: BorderRadius.circular(8)):null,
        enabledBorder: filled?OutlineInputBorder(borderSide: BorderSide(color: Color(0xfff0f0f0)), borderRadius: BorderRadius.circular(8)):null,
        border: filled?OutlineInputBorder(borderSide: BorderSide(color: Color(0xfff0f0f0)), borderRadius: BorderRadius.circular(8)):null,
        label: Text(
          labelText??AppLocalizations.of(context)!.phoneNumber,
          style: AppStyles.s16w400.copyWith(color: Color(0xff595D62)),
        ),
      ),
      inputFormatters: phoneFormatter!=null?[phoneFormatter!]:null,
      keyboardType: labelText!=null?TextInputType.webSearch:TextInputType.number,
    );
  }
}
