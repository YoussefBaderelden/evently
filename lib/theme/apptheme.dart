import 'package:flutter/material.dart';

class AppTheme {
  static Color primary = Color(0xff5669FF);
  static Color white = Color(0xffF2FEFF);
  static Color red = Color(0xffFF5659);
  static Color black = Color(0xff1C1C1C);
  static Color gray = Color(0xff7B7B7B);

  static ThemeData lighttheme = ThemeData(
    scaffoldBackgroundColor: white,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: primary,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: white,
      unselectedItemColor: white,
    ),
    textTheme: TextTheme(
      displaySmall: TextStyle(
        color: white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        color: white,
        fontSize: 22,
      ),
      headlineLarge: TextStyle(
        color: black,
        fontSize: 36,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: TextStyle(
        color: black,
        fontSize: 24,
        fontWeight: FontWeight.w700,
      ),
      titleLarge: TextStyle(
        color: black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(
        color: black,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
      ),
      titleSmall: TextStyle(
        color: black,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(
        color: black,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      bodyMedium: TextStyle(
        color: black,
        fontSize: 16,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
        decoration: TextDecoration.underline,
        decorationColor: AppTheme.primary,
        decorationThickness: 1.5,
      ),
      bodySmall: TextStyle(
        color: black,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      labelLarge: TextStyle(
        color: black,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      labelMedium: TextStyle(
        color: black,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      labelSmall: TextStyle(
        color: white,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
