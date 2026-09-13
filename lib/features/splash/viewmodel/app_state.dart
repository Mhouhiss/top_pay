import 'package:flutter/material.dart';

class AppState {
  final bool isInitializing;
  final bool hasSeenOnboarding;
  final ThemeMode themeMode;
  final String? errorMessage;

  const AppState({
    this.isInitializing = true,
    this.hasSeenOnboarding = false,
    this.themeMode = ThemeMode.system,
    this.errorMessage,
  });

  AppState copyWith({
    bool? isInitializing,
    bool? hasSeenOnboarding,
    ThemeMode? themeMode,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AppState(
      isInitializing: isInitializing ?? this.isInitializing,
      hasSeenOnboarding: hasSeenOnboarding ?? this.hasSeenOnboarding,
      themeMode: themeMode ?? this.themeMode,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
