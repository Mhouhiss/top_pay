import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:top_pay/core/utils/logger.dart';
import 'package:top_pay/core/services/local_storage_service.dart';
import 'package:top_pay/features/splash/viewmodel/app_state.dart';
import 'package:top_pay/core/providers/storage_service_provider.dart';

class AppViewModel extends StateNotifier<AppState> {
  final LocalStorageService _storage;
  bool _isDisposed = false;

  AppViewModel(this._storage) : super(const AppState());

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void _safeSetState(AppState newState) {
    if (!_isDisposed && mounted) {
      state = newState;
    }
  }

  Future<bool> initialize() async {
    _safeSetState(state.copyWith(isInitializing: true, clearError: true));

    try {
      final onboarding = _storage.hasSeenOnboarding;
      final themeMode = _storage.themeMode;

      _safeSetState(
        state.copyWith(
          isInitializing: false,
          hasSeenOnboarding: onboarding,
          themeMode: _parseThemeMode(themeMode),
        ),
      );
      Logger.success('App initialization completed');
      return onboarding;
    } catch (e) {
      Logger.error('App initialization failed', error: e);
      _safeSetState(
        state.copyWith(
          isInitializing: false,
          errorMessage: 'Failed to restore application settings',
        ),
      );
      return false;
    }
  }

  Future<void> completeOnboarding() async {
    try {
      await _storage.setHasSeenOnboarding();
      _safeSetState(state.copyWith(hasSeenOnboarding: true));
    } catch (e) {
      Logger.error('Failed to complete onboarding', error: e);
      _safeSetState(
        state.copyWith(errorMessage: 'Could not save onboarding status'),
      );
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    try {
      await _storage.setThemeMode(_themeModeToString(mode));
      _safeSetState(state.copyWith(themeMode: mode));
    } catch (e) {
      Logger.error('Failed to update theme mode', error: e);
      _safeSetState(
        state.copyWith(errorMessage: 'Could not save theme preference'),
      );
    }
  }

  Future<void> clearAllData() async {
    try {
      await _storage.clear();
      _safeSetState(
        const AppState(
          isInitializing: false,
          hasSeenOnboarding: false,
          themeMode: ThemeMode.system,
        ),
      );
    } catch (e) {
      Logger.error('Failed to clear local app storage', error: e);
    }
  }

  void clearError() {
    _safeSetState(state.copyWith(clearError: true));
  }

  ThemeMode _parseThemeMode(String mode) {
    switch (mode.toLowerCase()) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }

  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.light:
        return 'light';
      case ThemeMode.system:
        return 'system';
    }
  }
}

final appViewModelProvider = StateNotifierProvider<AppViewModel, AppState>((
  ref,
) {
  final localStorage = ref.watch(storageServiceProvider);
  return AppViewModel(localStorage);
});
