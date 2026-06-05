import 'package:flutter/material.dart';

import 'app_theme.dart';

class BookCoverColors {
  static const List<Color> palette = [
    Color(0xFFD6E8F5),
    Color(0xFFD8F0E0),
    Color(0xFFF5E6D3),
    Color(0xFFF0D6E8),
    Color(0xFFE8E0F5),
    Color(0xFFF5F0D6),
  ];

  static Color forTitle(String title) {
    return palette[title.hashCode.abs() % palette.length];
  }

  static Color iconColor(Color bg) {
    return Color.lerp(bg, AppColors.primary, 0.6)!;
  }
}
