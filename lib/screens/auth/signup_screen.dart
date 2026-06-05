import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/signup_controller.dart';
import '../../utils/app_theme.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/form_label.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());

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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(child: AppLogo(size: 72)),
                const SizedBox(height: 20),
                const Text('Create Account', style: AppTextStyles.heading1),
                const SizedBox(height: 6),
                const Text(
                  'Fill in your details to get started',
                  style: AppTextStyles.subtitle,
                ),
                const SizedBox(height: 28),

                // Name
                const FormLabel('Full Name'),
                const SizedBox(height: 6),
                TextFormField(
                  controller: controller.nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    hintText: 'Enter your full name',
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: AppColors.textHint,
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Name is required';
                    if (val.length < 3) return 'Enter a valid name';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Email
                const FormLabel('Email'),
                const SizedBox(height: 6),
                TextFormField(
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Enter your email',
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: AppColors.textHint,
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Email is required';
                    if (!val.contains('@')) return 'Enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Student ID
                const FormLabel('Student ID'),
                const SizedBox(height: 6),
                TextFormField(
                  controller: controller.studentIdController,
                  decoration: const InputDecoration(
                    hintText: 'e.g. 2021-CS-45',
                    prefixIcon: Icon(
                      Icons.badge_outlined,
                      color: AppColors.textHint,
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty)
                      return 'Student ID is required';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password
                const FormLabel('Password'),
                const SizedBox(height: 6),
                Obx(
                  () => TextFormField(
                    controller: controller.passwordController,
                    obscureText: !controller.isPasswordVisible.value,
                    decoration: InputDecoration(
                      hintText: 'Min 6 characters',
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: AppColors.textHint,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isPasswordVisible.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.textHint,
                        ),
                        onPressed: controller.togglePasswordVisibility,
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty)
                        return 'Password is required';
                      if (val.length < 6)
                        return 'Minimum 6 characters required';
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Confirm Password
                const FormLabel('Confirm Password'),
                const SizedBox(height: 6),
                Obx(
                  () => TextFormField(
                    controller: controller.confirmPasswordController,
                    obscureText: !controller.isConfirmPasswordVisible.value,
                    decoration: InputDecoration(
                      hintText: 'Re-enter your password',
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: AppColors.textHint,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isConfirmPasswordVisible.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.textHint,
                        ),
                        onPressed: controller.toggleConfirmPasswordVisibility,
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty)
                        return 'Please confirm your password';
                      if (val != controller.passwordController.text)
                        return 'Passwords do not match';
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 32),

                // Signup button
                Obx(
                  () => ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.signup,
                    child: controller.isLoading.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Create Account'),
                  ),
                ),
                const SizedBox(height: 20),

                Center(
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: RichText(
                      text: const TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: 'Login',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
