import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;
  final isPasswordHidden = true.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill the fields',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Get.snackbar(
        'Success',
        'Login Successful!',
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.offAllNamed(AppRoutes.userHome);
    } on FirebaseAuthException catch (e) {
      String message = 'Error occurred';
      if (e.code == 'user-not-found') {
        message = 'User Not Found';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong Password';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid Email';
      }
      Get.snackbar('Error', message, snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
