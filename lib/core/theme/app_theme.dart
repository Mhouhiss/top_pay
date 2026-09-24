import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:top_pay/core/theme/app_colors.dart';
import 'package:top_pay/core/theme/app_text_styles.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: 'Sora',
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.white,
        secondary: AppColors.secondary,
        onSecondary: AppColors.white,
        surface: AppColors.surfaceLight,
        onSurface: AppColors.textPrimaryLight,
        error: AppColors.error,
        onError: AppColors.white,
      ),
      scaffoldBackgroundColor: AppColors.backgroundLight,
      textTheme: _buildTextTheme(Brightness.light),
      appBarTheme: _buildAppBarTheme(Brightness.light),
      elevatedButtonTheme: _buildElevatedButtonTheme(Brightness.light),
      outlinedButtonTheme: _buildOutlinedButtonTheme(Brightness.light),
      textButtonTheme: _buildTextButtonTheme(Brightness.light),
      inputDecorationTheme: _buildInputDecorationTheme(Brightness.light),
      cardTheme: _buildCardTheme(Brightness.light),
      bottomNavigationBarTheme: _buildBottomNavigationBarTheme(
        Brightness.light,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'Sora',
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryLight,
        onPrimary: AppColors.white,
        secondary: AppColors.secondaryLight,
        onSecondary: AppColors.white,
        surface: AppColors.surfaceDark,
        onSurface: AppColors.textPrimaryDark,
        error: AppColors.error,
        onError: AppColors.white,
      ),
      scaffoldBackgroundColor: AppColors.backgroundDark,
      textTheme: _buildTextTheme(Brightness.dark),
      appBarTheme: _buildAppBarTheme(Brightness.dark),
      elevatedButtonTheme: _buildElevatedButtonTheme(Brightness.dark),
      outlinedButtonTheme: _buildOutlinedButtonTheme(Brightness.dark),
      textButtonTheme: _buildTextButtonTheme(Brightness.dark),
      inputDecorationTheme: _buildInputDecorationTheme(Brightness.dark),
      cardTheme: _buildCardTheme(Brightness.dark),
      bottomNavigationBarTheme: _buildBottomNavigationBarTheme(Brightness.dark),
    );
  }

  static TextTheme _buildTextTheme(Brightness brightness) {
    final Color textColor = brightness == Brightness.light
        ? AppColors.textPrimaryLight
        : AppColors.textPrimaryDark;

    return TextTheme(
      displayLarge: AppTextStyles.displayLarge.copyWith(color: textColor),
      displayMedium: AppTextStyles.displayMedium.copyWith(color: textColor),
      displaySmall: AppTextStyles.displaySmall.copyWith(color: textColor),
      headlineLarge: AppTextStyles.headlineLarge.copyWith(color: textColor),
      headlineMedium: AppTextStyles.headlineMedium.copyWith(color: textColor),
      headlineSmall: AppTextStyles.headlineSmall.copyWith(color: textColor),
      titleLarge: AppTextStyles.titleLarge.copyWith(color: textColor),
      titleMedium: AppTextStyles.titleMedium.copyWith(color: textColor),
      titleSmall: AppTextStyles.titleSmall.copyWith(color: textColor),
      bodyLarge: AppTextStyles.bodyLarge.copyWith(color: textColor),
      bodyMedium: AppTextStyles.bodyMedium.copyWith(color: textColor),
      bodySmall: AppTextStyles.bodySmall.copyWith(color: textColor),
      labelLarge: AppTextStyles.labelLarge.copyWith(color: textColor),
      labelMedium: AppTextStyles.labelMedium.copyWith(color: textColor),
      labelSmall: AppTextStyles.labelSmall.copyWith(color: textColor),
    );
  }

  static AppBarTheme _buildAppBarTheme(Brightness brightness) {
    final isLight = brightness == Brightness.light;

    return AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: isLight
          ? AppColors.backgroundLight
          : AppColors.backgroundDark,
      foregroundColor: isLight
          ? AppColors.textPrimaryLight
          : AppColors.textPrimaryDark,
      systemOverlayStyle: isLight
          ? SystemUiOverlayStyle.dark
          : SystemUiOverlayStyle.light,
      titleTextStyle: AppTextStyles.titleLarge.copyWith(
        color: brightness == Brightness.light
            ? AppColors.textPrimaryLight
            : AppColors.textPrimaryDark,
      ),
    );
  }

  static ElevatedButtonThemeData _buildElevatedButtonTheme(
    Brightness brightness,
  ) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: brightness == Brightness.light
            ? AppColors.primary
            : AppColors.primaryLight,
        foregroundColor: AppColors.white,
        textStyle: AppTextStyles.button,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
    );
  }

  static OutlinedButtonThemeData _buildOutlinedButtonTheme(
    Brightness brightness,
  ) {
    final primary = brightness == Brightness.light
        ? AppColors.primary
        : AppColors.primaryLight;

    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primary,
        textStyle: AppTextStyles.button,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: BorderSide(color: primary),
      ),
    );
  }

  static TextButtonThemeData _buildTextButtonTheme(Brightness brightness) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: brightness == Brightness.light
            ? AppColors.primary
            : AppColors.primaryLight,
        textStyle: AppTextStyles.button,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  static InputDecorationTheme _buildInputDecorationTheme(
    Brightness brightness,
  ) {
    final isLight = brightness == Brightness.light;

    return InputDecorationTheme(
      filled: true,
      fillColor: isLight ? AppColors.surfaceLight : AppColors.surfaceDark,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isLight ? AppColors.borderLight : AppColors.borderDark,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isLight ? AppColors.borderLight : AppColors.borderDark,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isLight ? AppColors.primary : AppColors.primaryLight,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error),
      ),
    );
  }

  static CardThemeData _buildCardTheme(Brightness brightness) {
    return CardThemeData(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: brightness == Brightness.light
          ? AppColors.surfaceLight
          : AppColors.surfaceDark,
    );
  }

  static BottomNavigationBarThemeData _buildBottomNavigationBarTheme(
    Brightness brightness,
  ) {
    final isLight = brightness == Brightness.light;

    return BottomNavigationBarThemeData(
      backgroundColor: isLight ? AppColors.surfaceLight : AppColors.surfaceDark,
      selectedItemColor: isLight ? AppColors.primary : AppColors.primaryLight,
      unselectedItemColor: isLight
          ? AppColors.textSecondaryLight
          : AppColors.textSecondaryDark,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    );
  }
}
