import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppGradients {
  AppGradients._();

  static const LinearGradient primary = LinearGradient(
    colors: AppColors.primaryGradient,
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient craft = LinearGradient(
    colors: AppColors.craftGradient,
  );

  static const LinearGradient technical = LinearGradient(
    colors: AppColors.technicalGradient,
  );

  static const LinearGradient cleaning = LinearGradient(
    colors: AppColors.cleaningGradient,
  );
}
