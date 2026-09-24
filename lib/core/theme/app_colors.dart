import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF112B3C);
  static const Color primaryLight = Color(0xFF205375);
  static const Color primaryDark = Color(0xFF0A1B26);

  // Secondary Colors
  static const Color secondary = Color(0xFFF66B0E);
  static const Color secondaryLight = Color(0xFFFF8838);
  static const Color secondaryDark = Color(0xFFC45000);

  // Neutral Colors
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);

  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFff383c);
  static const Color info = Color(0xFF205375);

  // Background Colors
  static const Color backgroundLight = Color(0xFFEFEFEF);
  static const Color backgroundDark = Color(0xFF0B141B);

  static const Color surfaceLight = Color(0xFFF8FAFC);
  static const Color surfaceDark = Color(0xFF1E293B);

  // Borders / Dividers
  static const Color borderLight = Color(0xFFE5E7EB);
  static const Color borderDark = Color(0xFF3A3A3A);

  static const Color dividerLight = Color(0xFFEDEDED);
  static const Color dividerDark = Color(0xFF2C2C2C);

  // Text Colors
  static const Color textPrimaryLight = Color(0xFF112B3C);
  static const Color textSecondaryLight = Color(0xFF205375);

  static const Color textPrimaryDark = Color(0xFFF9FAFB);
  static const Color textSecondaryDark = Color(0xFF9CA3AF);

  // Network provider brand colors
  static const Color mtn = Color(0xFFFFCB05);
  static const Color airtel = Color(0xFFE30613);
  static const Color glo = Color(0xFF1BA94C);
  static const Color nineMobile = Color(0xFF006E51);

  // Button empty state colors
  static const Color buttonEmptyBackground = Color.fromRGBO(89, 89, 89, 1);
  static const Color buttonEmptyText = Color.fromRGBO(0, 0, 0, 1);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
