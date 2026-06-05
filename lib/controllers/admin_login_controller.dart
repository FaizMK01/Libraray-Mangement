import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../routes/app_routes.dart';
import '../utils/app_snackbar.dart';

class AdminLoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;
  final isPasswordHidden = true.obs;

  static const _adminEmail = 'admin@gmail.com';
  static const _adminPassword = 'admin12345';

  void togglePassword() => isPasswordHidden.value = !isPasswordHidden.value;

  void login() {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email == _adminEmail && password == _adminPassword) {
      GetStorage().write('isAdminLoggedIn', true);

      AppSnackbar.success(
        'Welcome Back',
        'You have successfully logged in as admin.',
      );
      Get.offAllNamed(AppRoutes.adminDashboard);
    } else {
      AppSnackbar.error(
        'Login Failed',
        'Invalid email or password. Please try again.',
      );
    }

    isLoading.value = false;
  }

  Future<void> logout() async {
    final box = GetStorage();
    box.write('isAdminLoggedIn', false);
    await box.save();
    Get.offAllNamed(AppRoutes.login);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
