import 'package:flutter/material.dart';

class AppStyles {
  AppStyles._();
  static const s16 = TextStyle(fontSize: 16, height: 20/16,letterSpacing: -0.5);
  static final s14 = s16.copyWith(fontSize: 14);
  static final s14w500 = s14.copyWith(fontWeight: FontWeight.w500);
  static final s14w700 = s14.copyWith(fontWeight: FontWeight.w700);
  static final s15 = s16.copyWith(fontSize: 15,);
  static final s15w600 = s16.copyWith(fontSize: 15,fontWeight: FontWeight.w600,height: 20/15);
  static final s12 = s16.copyWith(fontSize: 12);
  static final s16w400 = s16.copyWith(fontWeight: FontWeight.w400);
  static final s16w700 = s16.copyWith(fontWeight: FontWeight.w700);
  static final s20w400 = s16.copyWith(fontWeight: FontWeight.w400,fontSize: 20);
  static final s20w700 = s20w400.copyWith(fontWeight: FontWeight.w700);
  static final s18w600 = s16.copyWith(fontWeight: FontWeight.w600,fontSize: 18, height: 24/18);
  static final s32w700=s16.copyWith(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 40 / 32,
    letterSpacing: -0.5,
    color: Colors.black,
  );
  static final s32w600 = s32w700.copyWith(fontWeight: FontWeight.w600);
  static final s24 = s16.copyWith(fontSize: 24,height: 31/24);
  static final s24w700 = s24.copyWith(fontWeight: FontWeight.w700);
  static final s21w700 = s24w700.copyWith(fontSize: 21);

}
