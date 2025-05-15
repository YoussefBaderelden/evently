import 'package:event_planning_app/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    primaryColor: AppColors.primaryPurple,
    scaffoldBackgroundColor: AppColors.bgwhite,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryPurple),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.black),
      bodyMedium: TextStyle(
          fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.black),
      bodySmall: TextStyle(
          fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.black),
      labelLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w900,
          color: AppColors.primaryPurple),
      labelMedium: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w900,
          color: AppColors.primaryPurple),
      labelSmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w900,
          color: AppColors.primaryPurple),
    ),
    filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
            backgroundColor: AppColors.primaryPurple,
            foregroundColor: AppColors.bgwhite,
            textStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)))),
    inputDecorationTheme: InputDecorationTheme(
      prefixIconColor: AppColors.gray,
      suffixIconColor: AppColors.gray,
      hintStyle: TextStyle(
          color: AppColors.gray, fontSize: 16, fontWeight: FontWeight.w500),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.gray),
        borderRadius: BorderRadius.circular(16),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.gray),
        borderRadius: BorderRadius.circular(16),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.gray),
        borderRadius: BorderRadius.circular(16),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.red),
        borderRadius: BorderRadius.circular(16),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.red),
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
            foregroundColor: AppColors.primaryPurple,
            textStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              fontStyle: FontStyle.italic,
            ))),
  );
  static ThemeData dark = ThemeData(
    primaryColor: AppColors.primaryPurple,
    scaffoldBackgroundColor: AppColors.bgDarkDarkPurple,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryPurple),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.ofWhite),
      bodyMedium: TextStyle(
          fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.ofWhite),
      bodySmall: TextStyle(
          fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.ofWhite),
      labelLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w900,
          color: AppColors.primaryPurple),
      labelMedium: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w900,
          color: AppColors.primaryPurple),
      labelSmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w900,
          color: AppColors.primaryPurple),
    ),
    inputDecorationTheme: InputDecorationTheme(
      prefixIconColor: AppColors.ofWhite,
      suffixIconColor: AppColors.ofWhite,
      hintStyle: TextStyle(
          color: AppColors.ofWhite, fontSize: 16, fontWeight: FontWeight.w500),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.primaryPurple),
        borderRadius: BorderRadius.circular(16),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.primaryPurple),
        borderRadius: BorderRadius.circular(16),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.primaryPurple),
        borderRadius: BorderRadius.circular(16),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.red),
        borderRadius: BorderRadius.circular(16),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.red),
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
            backgroundColor: AppColors.primaryPurple,
            foregroundColor: AppColors.bgwhite,
            textStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)))),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryPurple,
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
            fontStyle: FontStyle.italic,
          )),
    ),
  );
}
