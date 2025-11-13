import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors
  static const Color primaryColor = Color(0xFF2563EB); // Blue
  static const Color secondaryColor = Color(0xFF10B981); // Green
  static const Color accentColor = Color(0xFFF59E0B); // Amber

  // Neutral Colors
  static const Color backgroundColor = Color(0xFFFAFAFA);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color errorColor = Color(0xFFDC2626);
  static const Color successColor = Color(0xFF10B981);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color infoColor = Color(0xFF3B82F6);

  // Text Colors
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textDisabled = Color(0xFFD1D5DB);

  // Border Colors
  static const Color borderLight = Color(0xFFE5E7EB);
  static const Color borderMedium = Color(0xFFD1D5DB);

  // Shadow Colors
  static const Color shadowLight = Color(0x0D000000);
  static const Color shadowMedium = Color(0x1A000000);

  // Light Theme
  static ThemeData lightTheme() {
    final baseTheme = ThemeData.light();
    final textTheme = _buildTextTheme(baseTheme.textTheme);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
        error: errorColor,
        surface: surfaceColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimary,
        onError: Colors.white,
      ),

      // Scaffold
      scaffoldBackgroundColor: backgroundColor,

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceColor,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        iconTheme: const IconThemeData(color: textPrimary),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),

      // Card
      cardTheme: CardTheme(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: surfaceColor,
        margin: const EdgeInsets.all(8),
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          side: const BorderSide(color: primaryColor, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),

        // Border styles
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderLight.withOpacity(0.5)),
        ),

        // Label style
        labelStyle: textTheme.bodyLarge?.copyWith(color: textSecondary),
        floatingLabelStyle: textTheme.bodyLarge?.copyWith(
          color: primaryColor,
          fontWeight: FontWeight.w500,
        ),

        // Hint style
        hintStyle: textTheme.bodyMedium?.copyWith(color: textTertiary),

        // Error style
        errorStyle: textTheme.bodySmall?.copyWith(
          color: errorColor,
          fontSize: 12,
        ),

        // Icon colors
        prefixIconColor: textSecondary,
        suffixIconColor: textSecondary,
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: Colors.grey[100],
        deleteIconColor: textSecondary,
        labelStyle: textTheme.bodyMedium?.copyWith(color: textPrimary),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),

      // Floating Action Button
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
      ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surfaceColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: textTertiary,
        selectedLabelStyle: textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: textTheme.labelSmall,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: borderLight,
        thickness: 1,
        space: 1,
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }
          return Colors.grey[300];
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor;
          }
          return Colors.grey[400];
        }),
      ),

      // Checkbox
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor;
          }
          return Colors.transparent;
        }),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),

      // Radio
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor;
          }
          return textSecondary;
        }),
      ),

      // Dialog
      dialogTheme: DialogTheme(
        backgroundColor: surfaceColor,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
      ),

      // Bottom Sheet
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        elevation: 8,
      ),

      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: textPrimary,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),

      // Progress Indicator
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primaryColor,
      ),

      // Text Theme
      textTheme: textTheme,

      // Icon Theme
      iconTheme: const IconThemeData(color: textSecondary, size: 24),
    );
  }

  // Dark Theme
  static ThemeData darkTheme() {
    final baseTheme = ThemeData.dark();
    final textTheme = _buildTextTheme(baseTheme.textTheme, isDark: true);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF60A5FA), // Lighter blue for dark mode
        secondary: Color(0xFF34D399), // Lighter green
        tertiary: Color(0xFFFBBF24), // Lighter amber
        error: Color(0xFFEF4444),
        surface: Color(0xFF1F2937),
        onPrimary: Color(0xFF1F2937),
        onSecondary: Color(0xFF1F2937),
        onSurface: Color(0xFFF9FAFB),
        onError: Colors.white,
      ),

      scaffoldBackgroundColor: const Color(0xFF111827),

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF1F2937),
        foregroundColor: const Color(0xFFF9FAFB),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: const Color(0xFFF9FAFB),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFF9FAFB)),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),

      // Card
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: const Color(0xFF1F2937),
        margin: const EdgeInsets.all(8),
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF60A5FA),
          foregroundColor: const Color(0xFF1F2937),
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF374151),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF4B5563)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF4B5563)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF60A5FA), width: 2),
        ),

        labelStyle: textTheme.bodyLarge?.copyWith(
          color: const Color(0xFF9CA3AF),
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: const Color(0xFF6B7280),
        ),
      ),

      // Text Theme
      textTheme: textTheme,
    );
  }

  // Build Text Theme with Cairo font
  static TextTheme _buildTextTheme(TextTheme baseTheme, {bool isDark = false}) {
    final Color textColor = isDark ? const Color(0xFFF9FAFB) : textPrimary;
    final Color secondaryTextColor =
        isDark ? const Color(0xFFD1D5DB) : textSecondary;

    return GoogleFonts.cairoTextTheme(baseTheme).copyWith(
      // Display styles (largest text)
      displayLarge: GoogleFonts.cairo(
        fontSize: 57,
        fontWeight: FontWeight.w700,
        height: 1.12,
        color: textColor,
      ),
      displayMedium: GoogleFonts.cairo(
        fontSize: 45,
        fontWeight: FontWeight.w700,
        height: 1.16,
        color: textColor,
      ),
      displaySmall: GoogleFonts.cairo(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        height: 1.22,
        color: textColor,
      ),

      // Headline styles
      headlineLarge: GoogleFonts.cairo(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        height: 1.25,
        color: textColor,
      ),
      headlineMedium: GoogleFonts.cairo(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1.29,
        color: textColor,
      ),
      headlineSmall: GoogleFonts.cairo(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.33,
        color: textColor,
      ),

      // Title styles
      titleLarge: GoogleFonts.cairo(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 1.27,
        color: textColor,
      ),
      titleMedium: GoogleFonts.cairo(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.5,
        letterSpacing: 0.15,
        color: textColor,
      ),
      titleSmall: GoogleFonts.cairo(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.43,
        letterSpacing: 0.1,
        color: textColor,
      ),

      // Body styles
      bodyLarge: GoogleFonts.cairo(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        letterSpacing: 0.15,
        color: textColor,
      ),
      bodyMedium: GoogleFonts.cairo(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.43,
        letterSpacing: 0.25,
        color: secondaryTextColor,
      ),
      bodySmall: GoogleFonts.cairo(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.33,
        letterSpacing: 0.4,
        color: secondaryTextColor,
      ),

      // Label styles
      labelLarge: GoogleFonts.cairo(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.43,
        letterSpacing: 0.1,
        color: textColor,
      ),
      labelMedium: GoogleFonts.cairo(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 1.33,
        letterSpacing: 0.5,
        color: textColor,
      ),
      labelSmall: GoogleFonts.cairo(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        height: 1.45,
        letterSpacing: 0.5,
        color: secondaryTextColor,
      ),
    );
  }
}

// Extension for easy access to custom colors
extension AppColors on ThemeData {
  Color get success => AppTheme.successColor;
  Color get warning => AppTheme.warningColor;
  Color get info => AppTheme.infoColor;
  Color get borderLight => AppTheme.borderLight;
  Color get borderMedium => AppTheme.borderMedium;
  Color get textSecondaryColor => AppTheme.textSecondary;
  Color get textTertiaryColor => AppTheme.textTertiary;
}
