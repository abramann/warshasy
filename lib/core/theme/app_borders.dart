// ============================================================================
// app_radius.dart
// ============================================================================
import 'package:flutter/material.dart';

class AppRadius {
  AppRadius._();

  static const small = 8.0;
  static const medium = 12.0;
  static const large = 16.0;
}

class AppBorders {
  AppBorders._();

  static OutlineInputBorder outline({
    Color color = Colors.transparent,
    double width = 1,
    double radius = AppRadius.medium,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
