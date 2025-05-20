import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:katlavan24/core/styles/app_colors.dart';
import 'package:katlavan24/core/styles/styles.dart';

final theme = ThemeData(
  primaryColorDark: Colors.black,
  primaryColorLight: Colors.black,
  textTheme: GoogleFonts.notoSansTextTheme(),
  dividerColor: Color(0xffe2e2e2),
  inputDecorationTheme: InputDecorationTheme(
    contentPadding: EdgeInsets.all(16),

    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Color(0xffE2E2E2), width: 1.5),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Color(0xffE2E2E2), width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Color(0xffE2E2E2), width: 1),
    ),
    floatingLabelBehavior: FloatingLabelBehavior.never,
  ),
  appBarTheme: AppBarTheme(backgroundColor: Colors.white),
  scaffoldBackgroundColor: Colors.white,
  primaryColor: AppColors.mainColor,
  tabBarTheme: TabBarTheme(
    indicatorSize: TabBarIndicatorSize.tab,
splashFactory: NoSplash.splashFactory,
    dividerColor: Colors.transparent,
    unselectedLabelStyle: AppStyles.s14.copyWith(
      fontWeight: FontWeight.w700,
      color: AppColors.black,
      letterSpacing: 0,
      height: 24 / 14,
    ),
    indicator: UnderlineTabIndicator(borderSide: BorderSide(width: 2, color: AppColors.mainColor)),

    labelStyle: AppStyles.s14.copyWith(
      fontWeight: FontWeight.w700,
      color: AppColors.mainColor,
      letterSpacing: 0,
      height: 24 / 14,
    ),
    indicatorColor: AppColors.mainColor,
  ),
);
