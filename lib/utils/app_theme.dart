import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF185FA5);
  static const primaryLight = Color(0xFFE6F1FB);
  static const primaryDark = Color(0xFF0C447C);

  static const success = Color(0xFF0F6E56);
  static const successLight = Color(0xFFEAF3DE);

  static const error = Color(0xFFA32D2D);
  static const errorLight = Color(0xFFFCEBEB);

  static const warning = Color(0xFF854F0B);
  static const warningLight = Color(0xFFFAEEDA);

  static const textPrimary = Color(0xFF1A1A1A);
  static const textSecondary = Color(0xFF5F5E5A);
  static const textHint = Color(0xFF888780);

  static const background = Color(0xFFF8F8F8);
  static const surface = Color(0xFFFFFFFF);
  static const border = Color(0xFFE0E0E0);
}

class AppTheme {
  static ThemeData get theme => ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          error: AppColors.error,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surface,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.error),
          ),
          hintStyle: const TextStyle(
              color: AppColors.textHint, fontSize: 14),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ),
      );
}
