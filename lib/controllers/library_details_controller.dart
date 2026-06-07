import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:library_mangement/routes/app_routes.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/book_model.dart';
import '../models/book_request_model.dart';
import '../utils/app_snackbar.dart';
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
    debugPrint('LibraryDetailsController initialized for book: ${book.title}');
    debugPrint('Book pdfUrl: ${book.pdfUrl}');
    debugPrint('Book googleBookId: ${book.googleBookId}');
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
            userRequest.value = BookRequestModel.fromFirestore(
              doc.data(),
              doc.id,
            );
            debugPrint(
              'User request found with pdfUrl: ${userRequest.value?.pdfUrl}',
            );
          } else {
            userRequest.value = null;
            debugPrint('No user request found');
          }
        });
  }

  String? _resolveReadUrl() {
    // Only use direct PDF URLs for in-app reading
    // Geo-restricted Google Books URLs fail in WebView
    final urls = [userRequest.value?.pdfUrl, book.pdfUrl];
    debugPrint('Resolving read URL from: $urls');
    final resolved = UrlHelper.firstValid(urls);
    debugPrint('Resolved read URL: $resolved');
    return resolved;
  }

  Future<void> openBookPdf() async {
    if (isOpeningBook.value) return;
    final url = _resolveReadUrl();
    debugPrint('Opening book with URL: $url');
    if (url == null) {
      // No PDF available, offer to open in external browser
      debugPrint('No PDF URL available, trying external URL');
      final externalUrl = _resolveExternalUrl();
      if (externalUrl != null) {
        await _launchExternalUrl(externalUrl);
      } else {
        AppSnackbar.error(
          'Link Unavailable',
          'No reading link is available for this book.',
        );
      }
      return;
    }
    isOpeningBook.value = true;
    try {
      debugPrint(
        'Navigating to book reader with URL: $url, title: ${book.title}',
      );
      Get.toNamed(
        AppRoutes.bookReader,
        arguments: {'url': url, 'title': book.title},
      );
    } finally {
      isOpeningBook.value = false;
    }
  }

  String? _resolveExternalUrl() {
    // Fallback to Google Books info page for external browser
    if (book.googleBookId != null && book.googleBookId!.isNotEmpty) {
      return 'https://books.google.com/books?id=${book.googleBookId}';
    }
    return null;
  }

  Future<void> _launchExternalUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        AppSnackbar.error(
          'Cannot Open',
          'Unable to open the book in external browser.',
        );
      }
    } catch (_) {
      AppSnackbar.error('Error', 'Failed to open external link.');
    }
  }
}
