import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/google_book_model.dart';
import '../routes/app_routes.dart';
import '../utils/app_snackbar.dart';

class AdminBookDetailsController extends GetxController {
  final GoogleBookModel googleBook;

  AdminBookDetailsController({required this.googleBook});

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
    titleController.text = googleBook.title;
    authorController.text = googleBook.author;
    descriptionController.text = _truncateDescription(googleBook.description);
    coverImageUrl.value = googleBook.coverImageUrl;
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
      final pdfUrl = googleBook.bestReadUrl;

      final docRef = await _firestore.collection('books').add({
        'title': titleController.text.trim(),
        'author': authorController.text.trim(),
        'description': descriptionController.text.trim(),
        'coverImageUrl': coverImageUrl.value,
        'quantity': quantity,
        'available': quantity,
        'pdfUrl': pdfUrl,
        'googleBookId': googleBook.id,
        'createdAt': FieldValue.serverTimestamp(),
      });

      Get.offNamed(
        AppRoutes.bookSaved,
        arguments: {
          'title': titleController.text.trim(),
          'author': authorController.text.trim(),
          'quantity': quantity,
          'available': quantity,
          'bookId': docRef.id,
        },
      );
    } catch (e) {
      AppSnackbar.error(
        'Save Failed',
        'Unable to save the book to the library. Please try again.',
      );
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    authorController.dispose();
    descriptionController.dispose();
    quantityController.dispose();
    super.onClose();
  }
}
