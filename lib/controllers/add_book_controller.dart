import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/book_model.dart';
import '../models/google_book_model.dart';
import '../services/google_books_service.dart';
import '../utils/app_snackbar.dart';
import '../utils/network_helper.dart';

class AddBookController extends GetxController {
  final searchController = TextEditingController();
  final GoogleBooksService _booksService = GoogleBooksService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final libraryBooks = <BookModel>[].obs;
  final searchResults = <GoogleBookModel>[].obs;
  final isSearching = false.obs;
  final isLoadingLibrary = true.obs;
  final hasSearched = false.obs;

  static const int _libraryLimit = 10;

  @override
  void onInit() {
    super.onInit();
    _listenToLibraryBooks();
    searchController.addListener(_onSearchChanged);
  }

  void _listenToLibraryBooks() {
    _firestore
        .collection('books')
        .orderBy('createdAt', descending: true)
        .limit(_libraryLimit)
        .snapshots()
        .listen((snapshot) {
      libraryBooks.assignAll(
        snapshot.docs
            .map((doc) => BookModel.fromFirestore(doc.data(), doc.id))
            .toList(),
      );
      isLoadingLibrary.value = false;
    });
  }

  void _onSearchChanged() {
    if (searchController.text.trim().isEmpty && hasSearched.value) {
      hasSearched.value = false;
      searchResults.clear();
    }
  }

  Future<void> searchBooks() async {
    final query = searchController.text.trim();
    if (query.isEmpty) {
      AppSnackbar.warning(
        'Search Required',
        'Please enter a book title or author to search.',
      );
      return;
    }

    if (!await NetworkHelper.hasConnection()) {
      AppSnackbar.error(
        'No Internet',
        'No internet connection. Please check your network and try again.',
      );
      return;
    }

    isSearching.value = true;
    hasSearched.value = true;

    try {
      final results = await _booksService.searchBooks(query);
      searchResults.assignAll(results);

      if (results.isEmpty) {
        AppSnackbar.info(
          'No Results',
          'No books found for "$query". Try different keywords.',
        );
      }
    } on NetworkException catch (e) {
      AppSnackbar.error('No Internet', e.message);
    } catch (_) {
      AppSnackbar.error(
        'Search Failed',
        'Unable to search books right now. Please try again later.',
      );
    } finally {
      isSearching.value = false;
    }
  }

  @override
  void onClose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.onClose();
  }
}
