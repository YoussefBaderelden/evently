import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get getThemeMode  =>  _themeMode;
  set setThemeMode (ThemeMode mode){
    _themeMode=mode;
    notifyListeners();
  }
 bool isDark(){
    return getThemeMode == ThemeMode.dark;
 }
}
