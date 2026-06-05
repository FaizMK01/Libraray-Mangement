import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/library_details_controller.dart';
import '../../models/book_model.dart';
import '../../routes/app_routes.dart';
import '../../utils/app_theme.dart';
import '../../widgets/book_cover_widget.dart';

class LibraryDetailsScreen extends StatelessWidget {
  const LibraryDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final book = Get.arguments as BookModel;
    if (Get.isRegistered<LibraryDetailsController>()) {
      Get.delete<LibraryDetailsController>(force: true);
    }
    final controller = Get.put(LibraryDetailsController(book: book));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textPrimary,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            BookCoverWidget(
              title: book.title,
              imageUrl: book.coverImageUrl,
              width: 140,
              height: 190,
              borderRadius: 16,
              iconSize: 52,
            ),
            const SizedBox(height: 24),
            Text(
              book.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              book.author,
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              book.description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            Obx(() {
              final request = controller.userRequest.value;

              if (request == null) {
                return ElevatedButton.icon(
                  onPressed: () =>
                      Get.toNamed(AppRoutes.bookRequest, arguments: book),
                  icon: const Icon(Icons.send_rounded, size: 18),
                  label: const Text('Request this Book'),
                );
              }

              if (request.isPending) {
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.warningLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            color: AppColors.warning,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Request Pending...',
                            style: TextStyle(
                              color: AppColors.warning,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Text(
                        'Waiting for admin approval',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                );
              }

              if (request.isApproved) {
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.successLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            color: AppColors.success,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Request Approved!',
                            style: TextStyle(
                              color: AppColors.success,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Obx(
                      () => ElevatedButton.icon(
                        onPressed: controller.isOpeningBook.value
                            ? null
                            : controller.openBookPdf,
                        icon: controller.isOpeningBook.value
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.menu_book_rounded, size: 18),
                        label: Text(
                          controller.isOpeningBook.value
                              ? 'Opening...'
                              : 'Read the Book',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.success,
                        ),
                      ),
                    ),
                  ],
                );
              }

              if (request.isRejected) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.errorLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.cancel_rounded, color: AppColors.error, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Request Rejected',
                        style: TextStyle(
                          color: AppColors.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return const SizedBox.shrink();
            }),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
