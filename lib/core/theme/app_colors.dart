// ============================================================================
// app_colors.dart
// ============================================================================
import 'package:flutter/material.dart';

/// All app colors in one place.
class AppColors {
  AppColors._();

  // Brand
  static const primary = Color.fromARGB(255, 11, 71, 119); // TODO: clean
  static const primaryDark = Color(0xFF0046B3);
  static const accent = primary;

  // Neutrals
  static const background = Color(0xFFFAFAFA);
  static const surface = Colors.white;
  static const textPrimary = Color(0xFF333333);
  static const textSecondary = Color(0xFF666666);
  static const textTertiary = Color(0xFF999999);

  // Feedback
  static const success = Color(0xFF50C878);
  static const error = Color(0xFFD32F2F);
  static const warning = Color(0xFFFF6B35);
  static const info = Color(0xFF4A90E2);

  // Category gradients
  static const List<Color> craftGradient = [
    Color(0xFFFF6B35),
    Color(0xFFFF8C61),
  ];
  static const List<Color> technicalGradient = [
    Color(0xFF4A90E2),
    Color(0xFF6BA8F0),
  ];
  static const List<Color> cleaningGradient = [
    Color(0xFF50C878),
    Color(0xFF72D893),
  ];
  static const List<Color> primaryGradient = [
    Color(0xFF54ADF7),
    Color(0xFF54ADF7),
  ];

  // Dark theme
  static const backgroundDark = Color(0xFF000000);
  static const surfaceDark = Color(0xFF121212);
  static const textPrimaryDark = Colors.white;
  static const textSecondaryDark = Colors.white70;
}
