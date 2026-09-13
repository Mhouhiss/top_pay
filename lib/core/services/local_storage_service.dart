import 'package:shared_preferences/shared_preferences.dart';

import 'package:top_pay/core/utils/logger.dart';

class LocalStorageService {
  static const String _onboardingKey = 'has_seen_onboarding';
  static const String _themeKey = 'theme_mode';

  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  bool get hasSeenOnboarding {
    try {
      return _prefs.getBool(_onboardingKey) ?? false;
    } catch (e) {
      Logger.error('Failed to read onboarding', error: e);
      return false;
    }
  }

  Future<void> setHasSeenOnboarding() async {
    try {
      await _prefs.setBool(_onboardingKey, true);
      Logger.success('Onboarding Saved');
    } catch (e) {
      Logger.error('Failed to save onboarding', error: e);
      rethrow;
    }
  }

  String get themeMode {
    try {
      return _prefs.getString(_themeKey) ?? 'system';
    } catch (e) {
      Logger.error('Failed to read theme', error: e);
      return 'system';
    }
  }

  Future<void> setThemeMode(String mode) async {
    try {
      await _prefs.setString(_themeKey, mode);
      Logger.success('Theme saved: $mode');
    } catch (e) {
      Logger.error('Failed to save theme', error: e);
    }
  }

  Future<void> clear() async {
    try {
      await _prefs.clear();
      Logger.success('Storage cleared');
    } catch (e) {
      Logger.error('Failed to clear storage', error: e);
    }
  }
}
