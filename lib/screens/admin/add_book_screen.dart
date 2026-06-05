import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/add_book_controller.dart';
import '../../models/book_model.dart';
import '../../models/google_book_model.dart';
import '../../routes/app_routes.dart';
import '../../utils/app_theme.dart';
import '../../widgets/admin_logout_fab.dart';
import '../../widgets/book_cover_widget.dart';

class AddBookScreen extends GetView<AddBookController> {
  const AddBookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: const AdminLogoutFab(),
      body: Column(
        children: [
          _SearchHeader(controller: controller),
          Expanded(child: _BookContent(controller: controller)),
        ],
      ),
    );
  }
}

class _SearchHeader extends StatelessWidget {
  final AddBookController controller;

  const _SearchHeader({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Find a Book',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Add to Library',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Browse your collection or search Google Books',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller.searchController,
                            style: const TextStyle(fontSize: 14),
                            textInputAction: TextInputAction.search,
                            decoration: InputDecoration(
                              hintText: 'Search by title or author...',
                              filled: true,
                              fillColor: AppColors.surface,
                              prefixIcon: const Icon(
                                Icons.search_rounded,
                                color: AppColors.textHint,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onSubmitted: (_) => controller.searchBooks(),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Obx(
                          () => SizedBox(
                            width: 48,
                            height: 48,
                            child: controller.isSearching.value
                                ? const Padding(
                                    padding: EdgeInsets.all(12),
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Material(
                                    color: AppColors.surface,
                                    borderRadius: BorderRadius.circular(14),
                                    child: InkWell(
                                      onTap: controller.searchBooks,
                                      borderRadius: BorderRadius.circular(14),
                                      child: const Icon(
                                        Icons.arrow_forward_rounded,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BookContent extends StatelessWidget {
  final AddBookController controller;

  const _BookContent({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isSearching.value) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: AppColors.primary),
              SizedBox(height: 16),
              Text(
                'Searching Google Books...',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ],
          ),
        );
      }

      return ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        children: [
          if (controller.hasSearched.value) ...[
            _SectionHeader(
              title: 'Search Results',
              subtitle: controller.searchResults.isEmpty
                  ? 'No books found for your search'
                  : '${controller.searchResults.length} book(s) found',
            ),
            const SizedBox(height: 12),
            if (controller.searchResults.isEmpty)
              const _EmptyState(
                icon: Icons.search_off_rounded,
                title: 'No results found',
                message:
                    'Try different keywords or check your internet connection.',
              )
            else
              ...controller.searchResults.map(
                (book) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _GoogleBookCard(book: book),
                ),
              ),
            const SizedBox(height: 24),
          ],
          _SectionHeader(
            title: 'Books in Library',
            subtitle: controller.isLoadingLibrary.value
                ? 'Loading your collection...'
                : 'Recently added books (up to 10)',
          ),
          const SizedBox(height: 12),
          if (controller.isLoadingLibrary.value)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            )
          else if (controller.libraryBooks.isEmpty)
            const _EmptyState(
              icon: Icons.library_books_outlined,
              title: 'No books yet',
              message:
                  'Your library is empty. Search above to find and add books.',
            )
          else
            ...controller.libraryBooks.map(
              (book) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _LibraryBookCard(book: book),
              ),
            ),
        ],
      );
    });
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.sectionTitle),
        const SizedBox(height: 4),
        Text(subtitle, style: AppTextStyles.subtitle),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: AppColors.primary),
          const SizedBox(height: 12),
          Text(title, style: AppTextStyles.heading2.copyWith(fontSize: 16)),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.subtitle,
          ),
        ],
      ),
    );
  }
}

class _LibraryBookCard extends StatelessWidget {
  final BookModel book;

  const _LibraryBookCard({required this.book});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          BookCoverWidget(title: book.title, imageUrl: book.coverImageUrl),
          const SizedBox(width: 14),
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
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.successLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Added',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.success,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GoogleBookCard extends StatelessWidget {
  final GoogleBookModel book;

  const _GoogleBookCard({required this.book});

  void _openDetails() {
    Get.toNamed(AppRoutes.adminBookDetails, arguments: book);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _openDetails,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BookCoverWidget(
                      title: book.title,
                      imageUrl: book.coverImageUrl,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            book.title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
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
                            maxLines: 2,
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
                  child: ElevatedButton.icon(
                    onPressed: _openDetails,
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: const Text('Add to Library'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 44),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
