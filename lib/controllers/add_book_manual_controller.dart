import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/app_snackbar.dart';

class AddBookManualController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final authorController = TextEditingController();
  final descriptionController = TextEditingController();
  final pdfUrlController = TextEditingController();

  final titleRx = ''.obs;
  final isSaving = false.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    titleController.addListener(() {
      titleRx.value = titleController.text;
    });
  }

  Future<void> saveBook() async {
    if (!formKey.currentState!.validate()) return;

    isSaving.value = true;

    try {
      final title = titleController.text.trim();
      final author = authorController.text.trim().isEmpty
          ? 'Unknown'
          : authorController.text.trim();
      final description = descriptionController.text.trim();
      final pdfUrl = pdfUrlController.text.trim();

      final docRef = await _firestore.collection('books').add({
        'title': title,
        'author': author,
        'description': description,
        'coverImageUrl': '', // Will trigger default placeholder cover
        'quantity': 1,
        'available': 1,
        'pdfUrl': pdfUrl,
        'googleBookId': null,
        'createdAt': FieldValue.serverTimestamp(),
      });

      Get.offNamed(
        '/book-saved',
        arguments: {
          'title': title,
          'author': author,
          'quantity': 1,
          'available': 1,
          'bookId': docRef.id,
        },
      );
    } catch (e) {
      debugPrint('Error saving manual book: $e');
      AppSnackbar.error(
        'Save Failed',
        'Unable to save the book to the library. Please try again.',
      );
    } finally {
      isSaving.value = false;
    }
  }


}
