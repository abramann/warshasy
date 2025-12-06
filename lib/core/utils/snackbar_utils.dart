// lib/core/utils/snackbar_utils.dart

import 'package:flutter/material.dart';
import 'package:warshasy/core/theme/app_borders.dart';
import 'package:warshasy/core/theme/app_colors.dart';

class SnackBarUtils {
  SnackBarUtils._(); // Private constructor to prevent instantiation

  /// Show a success snackbar with green background
  static void showSuccess(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    _showSnackBar(
      context,
      message: message,
      backgroundColor: AppColors.success,
      icon: Icons.check_circle,
      duration: duration,
      action: action,
    );
  }

  /// Show an error snackbar with red background
  static void showError(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
  }) {
    _showSnackBar(
      context,
      message: message,
      backgroundColor: AppColors.error,
      icon: Icons.error,
      duration: duration,
      action: action,
    );
  }

  /// Show a warning snackbar with orange background
  static void showWarning(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    _showSnackBar(
      context,
      message: message,
      backgroundColor: AppColors.warning,
      icon: Icons.warning,
      duration: duration,
      action: action,
    );
  }

  /// Show an info snackbar with blue background
  static void showInfo(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    _showSnackBar(
      context,
      message: message,
      backgroundColor: AppColors.info,
      icon: Icons.info,
      duration: duration,
      action: action,
    );
  }

  /// Show a custom snackbar with specified colors and icon
  static void showCustom(
    BuildContext context,
    String message, {
    required Color backgroundColor,
    IconData? icon,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    _showSnackBar(
      context,
      message: message,
      backgroundColor: backgroundColor,
      icon: icon,
      duration: duration,
      action: action,
    );
  }

  /// Internal method to show snackbar with consistent styling
  static void _showSnackBar(
    BuildContext context, {
    required String message,
    required Color backgroundColor,
    IconData? icon,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
        ),
        margin: const EdgeInsets.all(16),
        duration: duration,
        action: action,
      ),
    );
  }

  /// Dismiss any currently showing snackbar
  static void dismiss(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
  }
}

// Extension method for even cleaner usage
extension SnackBarExtension on BuildContext {
  void showSuccessSnackBar(String message, {SnackBarAction? action}) {
    SnackBarUtils.showSuccess(this, message, action: action);
  }

  void showErrorSnackBar(String message, {SnackBarAction? action}) {
    SnackBarUtils.showError(this, message, action: action);
  }

  void showWarningSnackBar(String message, {SnackBarAction? action}) {
    SnackBarUtils.showWarning(this, message, action: action);
  }

  void showInfoSnackBar(String message, {SnackBarAction? action}) {
    SnackBarUtils.showInfo(this, message, action: action);
  }

  void dismissSnackBar() {
    SnackBarUtils.dismiss(this);
  }
}
