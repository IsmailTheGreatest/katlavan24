import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:katlavan24/core/styles/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(this.text, {super.key, this.onTap, this.isEnabled = true, this.isLoading = false});

  final bool isEnabled;
  final bool isLoading;
  final VoidCallback? onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: isLoading?null:isEnabled?onTap:null,
        child: Ink(
          width: double.infinity,
          height: 56,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(color: isEnabled?AppColors.mainColor:Color(0xffC7C7CC), borderRadius: BorderRadius.circular(12)),
          child: Center(
            child: isLoading?CupertinoActivityIndicator(color: Colors.white,):Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  const SecondaryButton(this.text, {super.key, this.onTap, this.isEnabled = true, this.isLoading = false});

  final bool isEnabled;
  final bool isLoading;
  final VoidCallback? onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: isEnabled?onTap:null,
        child: Ink(
          width: double.infinity,
          height: 56,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(color: isEnabled?Color(0xffF0F0F0):Colors.grey, borderRadius: BorderRadius.circular(12)),
          child: Center(
            child: isLoading?CupertinoActivityIndicator(color: Colors.black,):Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}
