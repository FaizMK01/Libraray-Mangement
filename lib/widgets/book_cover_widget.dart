import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../utils/app_theme.dart';
import '../utils/book_cover_colors.dart';

class BookCoverWidget extends StatelessWidget {
  final String title;
  final String? imageUrl;
  final double width;
  final double height;
  final double borderRadius;
  final double iconSize;

  const BookCoverWidget({
    super.key,
    required this.title,
    this.imageUrl,
    this.width = 56,
    this.height = 72,
    this.borderRadius = 10,
    this.iconSize = 28,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = BookCoverColors.forTitle(title);
    final iconColor = BookCoverColors.iconColor(bgColor);

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: CachedNetworkImage(
          imageUrl: imageUrl!,
          width: width,
          height: height,
          fit: BoxFit.cover,
          placeholder: (_, __) => _placeholder(bgColor, iconColor),
          errorWidget: (_, __, ___) => _placeholder(bgColor, iconColor),
        ),
      );
    }

    return _placeholder(bgColor, iconColor);
  }

  Widget _placeholder(Color bgColor, Color iconColor) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: Icon(
        Icons.menu_book_rounded,
        color: iconColor,
        size: iconSize,
      ),
    );
  }
}
