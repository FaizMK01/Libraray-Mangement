import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import '../../utils/app_theme.dart';

class BookSavedScreen extends StatelessWidget {
  const BookSavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>;
    final title = args['title'] as String;
    final author = args['author'] as String;
    final quantity = args['quantity'] as int;
    final available = args['available'] as int;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Book Saved',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Get.offAllNamed(AppRoutes.adminDashboard),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 32),
            Container(
              width: 88,
              height: 88,
              decoration: const BoxDecoration(
                color: AppColors.successLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: AppColors.success,
                size: 48,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Book Added Successfully',
              style: AppTextStyles.heading1,
            ),
            const SizedBox(height: 8),
            const Text(
              'The book has been saved to your library.',
              style: AppTextStyles.subtitle,
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Saved Record', style: AppTextStyles.sectionTitle),
                  const SizedBox(height: 14),
                  _RecordRow(label: 'Title', value: title),
                  _RecordRow(label: 'Author', value: author),
                  _RecordRow(label: 'Quantity', value: '$quantity'),
                  _RecordRow(label: 'Available', value: '$available'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Get.offAllNamed(AppRoutes.adminDashboard),
              child: const Text('Back to Dashboard'),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

class _RecordRow extends StatelessWidget {
  final String label;
  final String value;

  const _RecordRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
