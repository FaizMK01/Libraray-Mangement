import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/add_book_controller.dart';
import '../../models/google_book_model.dart';
import '../../routes/app_routes.dart';
import '../../utils/app_theme.dart';
import '../../widgets/book_cover_widget.dart';

class AddBookScreen extends StatelessWidget {
  const AddBookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddBookController());

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
        title: const Row(
          children: [
            Icon(Icons.menu_book_rounded, color: AppColors.primary, size: 22),
            SizedBox(width: 8),
            Text(
              'Add Book',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: TextField(
              controller: controller.searchController,
              decoration: InputDecoration(
                hintText: 'Search book name...',
                prefixIcon: const Icon(Icons.search, color: AppColors.textHint),
                suffixIcon: Obx(
                  () => controller.isSearching.value
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primary,
                            ),
                          ),
                        )
                      : IconButton(
                          icon: const Icon(
                            Icons.arrow_forward_rounded,
                            color: AppColors.primary,
                          ),
                          onPressed: controller.searchBooks,
                        ),
                ),
              ),
              onSubmitted: (_) => controller.searchBooks(),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isSearching.value) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              if (!controller.hasSearched.value) {
                return const Center(
                  child: Text(
                    'Search for books using Google Books API',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                );
              }

              if (controller.searchResults.isEmpty) {
                return const Center(
                  child: Text(
                    'No books found. Try a different search.',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                );
              }

              return ListView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                children: [
                  const Text(
                    'Results from Google Books:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...controller.searchResults.map(
                    (book) => _BookResultCard(book: book),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _BookResultCard extends StatelessWidget {
  final GoogleBookModel book;

  const _BookResultCard({required this.book});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BookCoverWidget(
                title: book.title,
                imageUrl: book.coverImageUrl,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      book.author,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      book.description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textHint,
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                Get.toNamed(AppRoutes.adminBookDetails, arguments: book);
              },
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Select'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textPrimary,
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
