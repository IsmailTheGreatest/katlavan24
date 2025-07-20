import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:katlavan24/core/styles/app_colors.dart';
import 'package:katlavan24/core/utils/extension_utils/is_null.dart';

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
        onTap: isLoading
            ? null
            : isEnabled
                ? onTap
                : null,
        child: Ink(
          width: double.infinity,
          height: 56,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
              color: isEnabled ? AppColors.mainColor : Color(0xffC7C7CC), borderRadius: BorderRadius.circular(12)),
          child: Center(
            child: isLoading
                ? CupertinoActivityIndicator(
                    color: Colors.white,
                  )
                : Text(
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

class PrimaryButtonAlt extends StatelessWidget {
  const PrimaryButtonAlt(this.text, {super.key, this.onTap, this.isEnabled = true, this.isLoading = false});

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
        onTap: isLoading
            ? null
            : isEnabled
                ? onTap
                : null,
        child: Ink(
          width: double.infinity,
          height: 56,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
              color: isEnabled ? AppColors.mainColor : AppColors.grayLight4, borderRadius: BorderRadius.circular(12)),
          child: Center(
            child: isLoading
                ? CupertinoActivityIndicator(
                    color: Colors.white,
                  )
                : Text(
                    text,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: isEnabled ? Colors.white : Color(0xffd9d9d9), fontSize: 16, fontWeight: FontWeight.w600),
                  ),
          ),
        ),
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  const SecondaryButton(this.text,
      {super.key,
      this.onTap,
      this.isEnabled = true,
      this.isLoading = false,
      this.localImagePath,
      this.padding,
      this.iconSize,
      this.fontSize,
      this.backgroundColor,
      this.textColor});

  final bool isEnabled;
  final bool isLoading;
  final String? localImagePath;
  final VoidCallback? onTap;
  final String text;
  final EdgeInsets? padding;
  final double? fontSize;
  final Color? backgroundColor;
  final Color? textColor;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: isEnabled ? onTap : null,
        child: Ink(
          width: double.infinity,
          height: 56,
          padding: padding ?? EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
              color: isEnabled ? backgroundColor??Color(0xffF0F0F0) : Colors.grey, borderRadius: BorderRadius.circular(12)),
          child: Center(
            child: isLoading
                ? CupertinoActivityIndicator(
                    color: Colors.black,
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      localImagePath.isNull
                          ? SizedBox()
                          : Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Image.asset(
                                localImagePath!,
                                height: iconSize ?? 24,
                                width: iconSize ?? 24,
                              ),
                            ),
                      Flexible(
                        child: Text(
                          text,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: textColor??Colors.black, fontSize: fontSize ?? 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
