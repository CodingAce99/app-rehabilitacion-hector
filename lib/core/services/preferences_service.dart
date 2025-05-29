import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static SharedPreferences? _preferences;

  static Future<SharedPreferences> get instance async {
    _preferences ??= await SharedPreferences.getInstance();
    return _preferences!;
  }

  // Métodos de ayuda para onboarding
  static Future<bool> getSeenOnboarding() async {
    final prefs = await instance;
    return prefs.getBool('seenOnboarding') ?? false;
  }

  static Future<void> setSeenOnboarding(bool seen) async {
    final prefs = await instance;
    await prefs.setBool('seenOnboarding', seen);
  }
}
