import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/book_model.dart';
import '../models/book_request_model.dart';
import '../utils/url_helper.dart';

class LibraryDetailsController extends GetxController {
  final BookModel book;

  LibraryDetailsController({required this.book});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final userRequest = Rxn<BookRequestModel>();
  final isOpeningBook = false.obs;

  String get _userId => FirebaseAuth.instance.currentUser!.uid;

  @override
  void onInit() {
    super.onInit();
    _listenToUserRequest();
  }

  void _listenToUserRequest() {
    _firestore
        .collection('requests')
        .where('userId', isEqualTo: _userId)
        .snapshots()
        .listen((snapshot) {
      final match = snapshot.docs.where((doc) {
        return doc.data()['bookId'] == book.id;
      });

      if (match.isNotEmpty) {
        final doc = match.first;
        userRequest.value =
            BookRequestModel.fromFirestore(doc.data(), doc.id);
      } else {
        userRequest.value = null;
      }
    });
  }

  String? _resolveReadUrl() {
    return UrlHelper.firstValid([
      userRequest.value?.pdfUrl,
      book.pdfUrl,
      if (book.googleBookId != null && book.googleBookId!.isNotEmpty)
        'https://books.google.com/books?id=${book.googleBookId}',
    ]);
  }

  Future<void> openBookPdf() async {
    if (isOpeningBook.value) return;

    final url = _resolveReadUrl();
    if (url == null) {
      Get.snackbar(
        'Error',
        'No read link available for this book',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isOpeningBook.value = true;

    try {
      final uri = Uri.parse(url);
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        Get.snackbar(
          'Error',
          'Could not open the book. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (_) {
      Get.snackbar(
        'Error',
        'Could not open the book. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isOpeningBook.value = false;
    }
  }
}
