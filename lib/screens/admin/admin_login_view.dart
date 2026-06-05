import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/admin_login_controller.dart';
import '../../utils/app_theme.dart';
import '../../widgets/form_label.dart';

class AdminLoginView extends StatelessWidget {
  const AdminLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminLoginController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.shield_rounded,
                      size: 48,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text('Admin Login', style: AppTextStyles.heading1),
                const SizedBox(height: 6),
                const Text(
                  'Authorized administrators only',
                  style: AppTextStyles.subtitle,
                ),
                const SizedBox(height: 32),
                const FormLabel('Email'),
                const SizedBox(height: 6),
                TextFormField(
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Enter admin email',
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: AppColors.textHint,
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Email is required';
                    }
                    if (!GetUtils.isEmail(val.trim())) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const FormLabel('Password'),
                const SizedBox(height: 6),
                Obx(
                  () => TextFormField(
                    controller: controller.passwordController,
                    obscureText: controller.isPasswordHidden.value,
                    onFieldSubmitted: (_) => controller.login(),
                    decoration: InputDecoration(
                      hintText: 'Enter password',
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: AppColors.textHint,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isPasswordHidden.value
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppColors.textHint,
                        ),
                        onPressed: controller.togglePassword,
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Password is required';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 32),
                Obx(
                  () => ElevatedButton(
                    onPressed:
                        controller.isLoading.value ? null : controller.login,
                    child: controller.isLoading.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Login as Admin'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
