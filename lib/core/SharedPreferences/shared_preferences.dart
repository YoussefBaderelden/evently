import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static const String onboardingKey = 'onboarding_completed';

  static Future<void> setOnboardingSeen(bool seen) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(onboardingKey, seen);
  }

  static Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(onboardingKey) ?? false;
  }
}
