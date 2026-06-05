import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/google_book_model.dart';
import '../services/google_books_service.dart';

class AddBookController extends GetxController {
  final searchController = TextEditingController();
  final GoogleBooksService _booksService = GoogleBooksService();

  final searchResults = <GoogleBookModel>[].obs;
  final isSearching = false.obs;
  final hasSearched = false.obs;
  final selectedBook = Rxn<GoogleBookModel>();

  Future<void> searchBooks() async {
    final query = searchController.text.trim();
    if (query.isEmpty) return;

    isSearching.value = true;
    hasSearched.value = true;

    try {
      final results = await _booksService.searchBooks(query);
      searchResults.assignAll(results);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to search books. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSearching.value = false;
    }
  }

  void selectBook(GoogleBookModel book) {
    selectedBook.value = book;
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
