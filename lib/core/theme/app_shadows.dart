// ============================================================================
// app_shadows.dart
// ============================================================================
import 'package:flutter/material.dart';

class AppShadows {
  AppShadows._();

  // For cards / surfaces
  static const soft = [
    BoxShadow(
      blurRadius: 12,
      offset: Offset(0, 4),
      color: Color(0x1A000000), // ~10% black
    ),
  ];

  // For very subtle top-level elements
  static const subtle = [
    BoxShadow(
      blurRadius: 6,
      offset: Offset(0, 2),
      color: Color(0x14000000), // ~8% black
    ),
  ];
}
