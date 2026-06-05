import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/admin_login_controller.dart';
import '../../utils/app_theme.dart';

class AdminLoginView extends StatelessWidget {
  const AdminLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminLoginController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textPrimary,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Admin Login',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Only authorized admins can access',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Email
                  _buildLabel('Email'),
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
                      if (val == null || val.isEmpty) return 'Email required';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password
                  _buildLabel('Password'),
                  const SizedBox(height: 6),
                  Obx(
                    () => TextFormField(
                      controller: controller.passwordController,
                      obscureText: controller.isPasswordHidden.value,
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
                        if (val == null || val.isEmpty)
                          return 'Password required';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Login Button
                  Obx(
                    () => ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.login,
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
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
    );
  }
}
