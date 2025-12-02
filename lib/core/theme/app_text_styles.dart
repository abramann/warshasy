// ============================================================================
// app_text_styles.dart
// ============================================================================
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextTheme light(TextTheme? baseTextTheme) =>
      _buildTextTheme(baseTextTheme, isDark: false);

  static TextTheme dark(TextTheme? baseTextTheme) =>
      _buildTextTheme(baseTextTheme, isDark: true);

  static TextTheme _buildTextTheme(
    TextTheme? baseTextTheme, {
    required bool isDark,
  }) {
    final cairoTextTheme = GoogleFonts.cairoTextTheme(baseTextTheme);
    final textColor = isDark ? Colors.white : null;
    final secondaryColor = isDark ? Colors.white70 : null;

    return cairoTextTheme.copyWith(
      titleLarge: _buildTextStyle(
        cairoTextTheme.titleLarge,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: textColor,
      ),
      titleMedium: _buildTextStyle(
        cairoTextTheme.titleMedium,
        fontSize: 20,
        fontWeight: FontWeight.w500,
        height: 1.3,
        color: textColor,
      ),
      bodyLarge: _buildTextStyle(
        cairoTextTheme.bodyLarge,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: textColor,
      ),
      bodyMedium: _buildTextStyle(
        cairoTextTheme.bodyMedium,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: secondaryColor,
      ),
      labelSmall: _buildTextStyle(
        cairoTextTheme.labelSmall,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.2,
        color: secondaryColor,
      ),
    );
  }

  static TextStyle? _buildTextStyle(
    TextStyle? baseStyle, {
    required double fontSize,
    required FontWeight fontWeight,
    required double height,
    Color? color,
  }) {
    return baseStyle?.copyWith(
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
      color: color,
    );
  }
}
