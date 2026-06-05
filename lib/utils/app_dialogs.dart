import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_theme.dart';

class AppDialogs {
  AppDialogs._();

  static Future<bool> confirm({
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDestructive = false,
  }) async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title, style: AppTextStyles.heading2),
        content: Text(message, style: AppTextStyles.subtitle),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(
              cancelText,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text(
              confirmText,
              style: TextStyle(
                color: isDestructive ? AppColors.error : AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  static Future<bool> confirmLogout() => confirm(
        title: 'Logout',
        message: 'Are you sure you want to logout from your account?',
        confirmText: 'Logout',
        isDestructive: true,
      );
}
