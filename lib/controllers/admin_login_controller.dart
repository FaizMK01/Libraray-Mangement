import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../routes/app_routes.dart';

class AdminLoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;
  final isPasswordHidden = true.obs;

  static const _adminEmail = 'admin@gmail.com';
  static const _adminPassword = 'admin12345';

  // final _box = GetStorage();

  void togglePassword() => isPasswordHidden.value = !isPasswordHidden.value;

  void login() {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email == _adminEmail && password == _adminPassword) {
      GetStorage().write('isAdminLoggedIn', true); // direct likho
      print('Saved: ${GetStorage().read('isAdminLoggedIn')}'); // check karo

      Get.snackbar(
        'Welcome Admin',
        'Login successful',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.offAllNamed(AppRoutes.adminDashboard);
    } else {
      Get.snackbar(
        'Error',
        'Incorrect Credentials',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }

    isLoading.value = false;
  }

  Future<void> logout() async {
    final box = GetStorage();
    box.write('isAdminLoggedIn', false);
    await box.save(); // force save karo disk pe
    Get.offAllNamed(AppRoutes.login);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
