import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_theme.dart';

enum SnackBarType { success, error, warning, info }

class AppSnackbar {
  AppSnackbar._();

  static void show({
    required String title,
    required String message,
    SnackBarType type = SnackBarType.info,
    IconData? icon,
    Duration duration = const Duration(seconds: 3),
  }) {
    final config = _configFor(type);

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: config.background,
      colorText: config.foreground,
      icon: Icon(icon ?? config.icon, color: config.foreground),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: duration,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
    );
  }

  static void success(String title, String message) =>
      show(title: title, message: message, type: SnackBarType.success);

  static void error(String title, String message) =>
      show(title: title, message: message, type: SnackBarType.error);

  static void warning(String title, String message) =>
      show(title: title, message: message, type: SnackBarType.warning);

  static void info(String title, String message) =>
      show(title: title, message: message, type: SnackBarType.info);

  static _SnackConfig _configFor(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return const _SnackConfig(
          background: AppColors.successLight,
          foreground: AppColors.success,
          icon: Icons.check_circle_rounded,
        );
      case SnackBarType.error:
        return const _SnackConfig(
          background: AppColors.errorLight,
          foreground: AppColors.error,
          icon: Icons.error_outline_rounded,
        );
      case SnackBarType.warning:
        return const _SnackConfig(
          background: AppColors.warningLight,
          foreground: AppColors.warning,
          icon: Icons.warning_amber_rounded,
        );
      case SnackBarType.info:
        return const _SnackConfig(
          background: AppColors.primaryLight,
          foreground: AppColors.primary,
          icon: Icons.info_outline_rounded,
        );
    }
  }
}

class _SnackConfig {
  final Color background;
  final Color foreground;
  final IconData icon;

  const _SnackConfig({
    required this.background,
    required this.foreground,
    required this.icon,
  });
}
