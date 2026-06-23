import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/app_snackbar.dart';

class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final isLoading = false.obs;

  Future<void> sendResetEmail() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );

      emailController.clear();

      Get.back();

      AppSnackbar.success(
        'Email Sent',
        'Password reset link sent successfully. Check your inbox or spam folder.',
      );
    } on FirebaseAuthException catch (e) {
      String message = 'Failed to send reset email. Please try again.';

      if (e.code == 'user-not-found') {
        message = 'No account found with this email address.';
      } else if (e.code == 'invalid-email') {
        message = 'Please enter a valid email address.';
      }

      AppSnackbar.error('Request Failed', message);
    } finally {
      isLoading.value = false;
    }
  }


}
