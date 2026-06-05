import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';
import '../utils/app_dialogs.dart';
import '../utils/app_snackbar.dart';

class ProfileController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final studentIdController = TextEditingController();
  final emailController = TextEditingController();

  final email = ''.obs;
  final isLoading = true.obs;
  final isSaving = false.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String get initials {
    final name = nameController.text.trim();
    if (name.isEmpty) return '?';
    final parts = name.split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    isLoading.value = true;

    try {
      final user = _auth.currentUser;
      if (user == null) return;

      email.value = user.email ?? '';
      emailController.text = email.value;

      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        nameController.text = data['name'] ?? '';
        studentIdController.text = data['studentId'] ?? '';
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile() async {
    if (!formKey.currentState!.validate()) return;

    final user = _auth.currentUser;
    if (user == null) return;

    isSaving.value = true;

    try {
      await _firestore.collection('users').doc(user.uid).update({
        'name': nameController.text.trim(),
        'studentId': studentIdController.text.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      AppSnackbar.success(
        'Profile Updated',
        'Your profile changes have been saved successfully.',
      );
    } catch (_) {
      AppSnackbar.error(
        'Update Failed',
        'Unable to update your profile. Please try again.',
      );
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> logout() async {
    final confirmed = await AppDialogs.confirmLogout();

    if (confirmed) {
      await _auth.signOut();
      Get.offAllNamed(AppRoutes.login);
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    studentIdController.dispose();
    emailController.dispose();
    super.onClose();
  }
}
