import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';
import '../utils/app_snackbar.dart';

class SignupController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final studentIdController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void togglePasswordVisibility() =>
      isPasswordVisible.value = !isPasswordVisible.value;

  void toggleConfirmPasswordVisibility() =>
      isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;

  Future<void> signup() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      final UserCredential credential = await _auth
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      await _firestore.collection('users').doc(credential.user!.uid).set({
        'uid': credential.user!.uid,
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'studentId': studentIdController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      AppSnackbar.success(
        'Account Created',
        'Welcome, ${nameController.text.trim()}! Your account is ready.',
      );

      Get.offAllNamed(AppRoutes.userHome);
    } on FirebaseAuthException catch (e) {
      String message = 'Error occurred';
      if (e.code == 'email-already-in-use') {
        message = 'Email already in use';
      } else if (e.code == 'weak-password') {
        message = 'Password should be at least 6 characters';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid Email';
      }
      AppSnackbar.error('Signup Failed', message);
    } finally {
      isLoading.value = false;
    }
  }


}
