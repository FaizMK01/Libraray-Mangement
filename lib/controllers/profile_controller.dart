import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';

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

      Get.snackbar(
        'Profile Updated',
        'Your changes have been saved',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEAF3DE),
        colorText: const Color(0xFF0F6E56),
        icon: const Icon(Icons.check_circle, color: Color(0xFF0F6E56)),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> logout() async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text(
              'Logout',
              style: TextStyle(color: Color(0xFFA32D2D)),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
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
