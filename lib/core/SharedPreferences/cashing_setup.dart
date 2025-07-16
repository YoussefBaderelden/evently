import 'package:shared_preferences/shared_preferences.dart';

class CashingSetup {
  static const String _hasSeenSetup = 'hasSeenSetup';

  static Future<void> setHasSeenSetup(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasSeenSetup, value);
  }

  static Future<bool> hasSeenSetup() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hasSeenSetup) ?? false;
  }

}