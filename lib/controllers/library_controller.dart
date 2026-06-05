import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/book_model.dart';

class LibraryController extends GetxController {
  final searchController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final allBooks = <BookModel>[].obs;
  final filteredBooks = <BookModel>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _listenToBooks();
    searchController.addListener(_filterBooks);
  }

  void _listenToBooks() {
    _firestore
        .collection('books')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      allBooks.assignAll(
        snapshot.docs
            .map((doc) => BookModel.fromFirestore(doc.data(), doc.id))
            .toList(),
      );
      _filterBooks();
      isLoading.value = false;
    });
  }

  void _filterBooks() {
    final query = searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      filteredBooks.assignAll(allBooks);
      return;
    }

    filteredBooks.assignAll(
      allBooks.where((book) {
        return book.title.toLowerCase().contains(query) ||
            book.author.toLowerCase().contains(query);
      }).toList(),
    );
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
