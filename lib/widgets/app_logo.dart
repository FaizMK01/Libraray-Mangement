import 'package:flutter/material.dart';

import '../utils/app_theme.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final bool onPrimaryBackground;

  const AppLogo({
    super.key,
    this.size = 80,
    this.onPrimaryBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: onPrimaryBackground
            ? Colors.white.withValues(alpha: 0.15)
            : AppColors.primaryLight,
        borderRadius: BorderRadius.circular(size * 0.28),
        boxShadow: onPrimaryBackground
            ? null
            : [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
      ),
      child: Icon(
        Icons.local_library_rounded,
        size: size * 0.55,
        color: onPrimaryBackground ? Colors.white : AppColors.primary,
      ),
    );
  }
}
