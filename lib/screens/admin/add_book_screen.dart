import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../controllers/add_book_controller.dart';
import '../../models/book_model.dart';
import '../../models/gutenberg_book_model.dart';
import '../../routes/app_routes.dart';
import '../../utils/app_theme.dart';
import '../../widgets/book_cover_widget.dart';

class AddBookScreen extends StatelessWidget {
  const AddBookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Delete first if already registered
    if (Get.isRegistered<AddBookController>()) {
      Get.delete<AddBookController>(force: true);
    }
    final controller = Get.put(AddBookController());
    return Scaffold(
      backgroundColor: AppColors.background,
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
                  TextButton.icon(
                    onPressed: () => Get.toNamed(AppRoutes.addBookManual),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: const Text(
                      'Add Manually',
                      style: TextStyle(
                        fontSize: 13,
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
                      'Browse your collection or search for books',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Obx(
                            () => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextField(
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
                                      borderRadius:
                                          controller.showSuggestions.value
                                          ? const BorderRadius.only(
                                              topLeft: Radius.circular(14),
                                              topRight: Radius.circular(14),
                                            )
                                          : BorderRadius.circular(14),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  onSubmitted: (_) {
                                    controller.hideSuggestions();
                                    controller.searchBooks();
                                  },
                                ),

                                // Suggestions dropdown
                                if (controller.showSuggestions.value)
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.surface,
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(14),
                                        bottomRight: Radius.circular(14),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.1,
                                          ),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: controller.suggestions.map((
                                        book,
                                      ) {
                                        return InkWell(
                                          onTap: () =>
                                              controller.selectSuggestion(book),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 10,
                                            ),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.menu_book_rounded,
                                                  size: 16,
                                                  color: AppColors.textHint,
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        book.title,
                                                        style: const TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: AppColors
                                                              .textPrimary,
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      Text(
                                                        book.author,
                                                        style: const TextStyle(
                                                          fontSize: 11,
                                                          color: AppColors
                                                              .textSecondary,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const Icon(
                                                  Icons.north_west_rounded,
                                                  size: 14,
                                                  color: AppColors.textHint,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                              ],
                            ),
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
        return _SearchShimmer();
      }

      return ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        children: [
          if (controller.hasSearched.value) ...[
            Obx(
              () => _SectionHeader(
                title: 'Search Results',
                subtitle: _getResultsCount(controller),
              ),
            ),
            const SizedBox(height: 12),
            Obx(
              () => _hasNoResults(controller)
                  ? _EmptyState(
                      icon: Icons.search_off_rounded,
                      title: 'No results found',
                      message:
                          'Try different keywords or check your internet connection.',
                      action: Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: OutlinedButton.icon(
                          onPressed: () => Get.toNamed(AppRoutes.addBookManual),
                          icon: const Icon(Icons.add_rounded, size: 18),
                          label: const Text('Add Book Manually'),
                        ),
                      ),
                    )
                  : Column(children: _buildSearchResults(controller)),
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
            _LibraryShimmer()
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

  String _getResultsCount(AddBookController controller) {
    return controller.searchResultsGutenberg.isEmpty
        ? 'No books found for your search'
        : '${controller.searchResultsGutenberg.length} book(s) found';
  }

  bool _hasNoResults(AddBookController controller) {
    return controller.searchResultsGutenberg.isEmpty;
  }

  List<Widget> _buildSearchResults(AddBookController controller) {
    return controller.searchResultsGutenberg
        .map(
          (book) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _GutenbergBookCard(book: book),
          ),
        )
        .toList();
  }
}

// Shimmer effect when searching
class _SearchShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cover placeholder
                  Container(
                    width: 56,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 6),
                        // Title placeholder
                        Container(
                          height: 14,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Author placeholder
                        Container(
                          height: 12,
                          width: 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Description placeholder
                        Container(
                          height: 10,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          height: 10,
                          width: 180,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Shimmer effect when library loads
class _LibraryShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        3,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  // Cover placeholder
                  Container(
                    width: 56,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 14,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 12,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Badge placeholder
                  Container(
                    width: 60,
                    height: 26,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
  final Widget? action;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.message,
    this.action,
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
          if (action != null) action!,
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

class _GutenbergBookCard extends StatelessWidget {
  final GutenbergBookModel book;

  const _GutenbergBookCard({required this.book});

  void _openDetails() {
    Get.toNamed('/gutenberg-book-details', arguments: book);
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
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.successLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Free Public Domain',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.success,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _openDetails,
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: const Text('Add to Libraryy'),
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
