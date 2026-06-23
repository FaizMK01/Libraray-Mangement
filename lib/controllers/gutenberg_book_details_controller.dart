import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../models/gutenberg_book_model.dart';
import '../utils/app_snackbar.dart';

class GutenbergBookDetailsController extends GetxController {
  final GutenbergBookModel gutenbergBook;

  GutenbergBookDetailsController({required this.gutenbergBook});

  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final authorController = TextEditingController();
  final descriptionController = TextEditingController();
  final quantityController = TextEditingController(text: '1');

  final isSaving = false.obs;
  final coverImageUrl = ''.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    titleController.text = gutenbergBook.title;
    authorController.text = gutenbergBook.author;
    descriptionController.text = _truncateDescription(
      gutenbergBook.description,
    );
    coverImageUrl.value = gutenbergBook.coverImageUrl;
  }

  String _truncateDescription(String text) {
    if (text.length <= 500) return text;
    return '${text.substring(0, 500)}...';
  }

  Future<void> saveToLibrary() async {
    if (!formKey.currentState!.validate()) return;

    isSaving.value = true;

    try {
      final quantity = int.parse(quantityController.text.trim());
      // Gutenberg books always have downloadable formats
      // Save the best available URL (PDF > EPUB > TXT)
      // The reader will use appropriate viewer based on format
      final pdfUrl = gutenbergBook.bestReadUrl;

      debugPrint('Gutenberg book PDF URL: $pdfUrl');
      debugPrint('Gutenberg book EPUB URL: ${gutenbergBook.epubUrl}');
      debugPrint('Gutenberg book TXT URL: ${gutenbergBook.txtUrl}');

      if (pdfUrl == null) {
        AppSnackbar.warning(
          'No Downloadable Format',
          'This book does not have any downloadable format available.',
        );
        isSaving.value = false;
        return;
      }

      final docRef = await _firestore.collection('books').add({
        'title': titleController.text.trim(),
        'author': authorController.text.trim(),
        'description': descriptionController.text.trim(),
        'coverImageUrl': coverImageUrl.value,
        'quantity': quantity,
        'available': quantity,
        'pdfUrl': pdfUrl,
        'googleBookId': null, // Gutenberg books don't have Google Book IDs
        'createdAt': FieldValue.serverTimestamp(),
      });

      Get.offNamed(
        '/book-saved',
        arguments: {
          'title': titleController.text.trim(),
          'author': authorController.text.trim(),
          'quantity': quantity,
          'available': quantity,
          'bookId': docRef.id,
        },
      );
    } catch (e) {
      debugPrint('Error saving book: $e');
      AppSnackbar.error(
        'Save Failed',
        'Unable to save the book to the library. Please try again.',
      );
    } finally {
      isSaving.value = false;
    }
  }


}
