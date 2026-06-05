import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/book_model.dart';
import '../routes/app_routes.dart';
import '../utils/app_snackbar.dart';
import '../utils/url_helper.dart';
import 'library_details_controller.dart';

class BookRequestController extends GetxController {
  final BookModel book;

  BookRequestController({required this.book});

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final studentIdController = TextEditingController();
  final purposeController = TextEditingController();

  final isSubmitting = false.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (doc.exists) {
      final data = doc.data()!;
      nameController.text = data['name'] ?? '';
      studentIdController.text = data['studentId'] ?? '';
    }
  }

  Future<void> submitRequest() async {
    if (!formKey.currentState!.validate()) return;

    final user = _auth.currentUser;
    if (user == null) return;

    isSubmitting.value = true;

    try {
      final existing = await _firestore
          .collection('requests')
          .where('bookId', isEqualTo: book.id)
          .where('userId', isEqualTo: user.uid)
          .get();

      if (existing.docs.isNotEmpty) {
        AppSnackbar.warning(
          'Already Requested',
          'You have already submitted a request for this book.',
        );
        return;
      }

      await _firestore.collection('requests').add({
        'bookId': book.id,
        'bookTitle': book.title,
        'bookAuthor': book.author,
        'userId': user.uid,
        'userName': nameController.text.trim(),
        'studentId': studentIdController.text.trim(),
        'purpose': purposeController.text.trim(),
        'status': 'pending',
        'pdfUrl': UrlHelper.firstValid([
          book.pdfUrl,
          if (book.googleBookId != null && book.googleBookId!.isNotEmpty)
            'https://books.google.com/books?id=${book.googleBookId}',
        ]),
        'createdAt': FieldValue.serverTimestamp(),
      });

      AppSnackbar.success(
        'Request Submitted',
        'Your book request has been sent to the admin for approval.',
      );

      if (Get.isRegistered<LibraryDetailsController>()) {
        Get.delete<LibraryDetailsController>(force: true);
      }
      Get.offNamed(AppRoutes.libraryDetails, arguments: book);
    } catch (e) {
      AppSnackbar.error(
        'Submission Failed',
        'Unable to submit your request. Please try again.',
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    studentIdController.dispose();
    purposeController.dispose();
    super.onClose();
  }
}
