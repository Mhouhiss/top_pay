import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'package:top_pay/core/services/local_storage_service.dart';
import 'package:top_pay/core/providers/storage_service_provider.dart';

final themeProvider = StateNotifierProvider<ThemeViewModel, ThemeMode>((ref) {
  final storage = ref.watch(storageServiceProvider);

  return ThemeViewModel(storage);
});

class ThemeViewModel extends StateNotifier<ThemeMode> {
  final LocalStorageService _storage;

  ThemeViewModel(this._storage) : super(_getInitialTheme(_storage));

  static ThemeMode _getInitialTheme(LocalStorageService storage) {
    switch (storage.themeMode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };

    await _storage.setThemeMode(value);
  }

  Future<void> toggleDarkMode(bool enabled) async {
    await setThemeMode(enabled ? ThemeMode.dark : ThemeMode.light);
  }
}
