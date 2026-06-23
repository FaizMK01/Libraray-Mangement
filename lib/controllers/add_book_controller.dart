import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/book_model.dart';
import '../models/gutenberg_book_model.dart';
import '../services/gutenberg_service.dart';
import '../utils/app_snackbar.dart';
import '../utils/network_helper.dart';

class AddBookController extends GetxController {
  final searchController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final libraryBooks = <BookModel>[].obs;
  final searchResultsGutenberg = <GutenbergBookModel>[].obs;
  final isSearching = false.obs;
  final isLoadingLibrary = true.obs;
  final hasSearched = false.obs;
  final suggestions = <GutenbergBookModel>[].obs; // NEW
  final showSuggestions = false.obs; // NEW
  Timer? _debounce; // NEW

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
    final query = searchController.text.trim();

    if (query.isEmpty) {
      hasSearched.value = false;
      searchResultsGutenberg.clear();
      suggestions.clear();
      showSuggestions.value = false;
      return;
    }

    // Debounce — fetch suggestions after 500ms
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _fetchSuggestions(query);
    });
  }

  Future<void> _fetchSuggestions(String query) async {
    try {
      final results = await GutenbergService.searchBooks(query);
      suggestions.assignAll(results.take(5).toList()); // sirf 5 suggestions
      showSuggestions.value = suggestions.isNotEmpty;
    } catch (_) {
      suggestions.clear();
      showSuggestions.value = false;
    }
  }

  void selectSuggestion(GutenbergBookModel book) {
    searchController.text = book.title;
    showSuggestions.value = false;
    suggestions.clear();
    searchResultsGutenberg.assignAll([book]);
    hasSearched.value = true;
  }

  void hideSuggestions() {
    showSuggestions.value = false;
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
      final results = await GutenbergService.searchBooks(query);
      searchResultsGutenberg.assignAll(results);

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


}
