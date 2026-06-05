import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/login_controller.dart';
import '../../routes/app_routes.dart';
import '../../utils/app_theme.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Logo
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const Icon(
                    Icons.library_books_rounded,
                    size: 44,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 28),

              const Text(
                'Welcome back',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Login to your account',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 32),

              // Email field
              const Text(
                'Email',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
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

              // Password field
              const Text(
                'Password',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Obx(
                () => TextFormField(
                  controller: controller.passwordController,
                  obscureText: controller.isPasswordHidden.value,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: AppColors.textHint,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isPasswordHidden.value
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
                    if (val.length < 6) return 'Minimum 6 characters required';
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 10),

              // Forgot password
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => Get.toNamed(AppRoutes.forgotPassword),
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Login button
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
                      : const Text('Login'),
                ),
              ),
              const SizedBox(height: 16),

              // Divider
              Row(
                children: [
                  const Expanded(child: Divider(color: AppColors.border)),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'OR',
                      style: TextStyle(fontSize: 12, color: AppColors.textHint),
                    ),
                  ),
                  const Expanded(child: Divider(color: AppColors.border)),
                ],
              ),
              const SizedBox(height: 16),

              // Login as Admin button
              // OutlinedButton.icon(
              //   onPressed: () {
              //     controller.fillAdminCredentials();
              //     controller.login();
              //   },
              //   icon: const Icon(Icons.shield_outlined,
              //       color: AppColors.primary, size: 18),
              //   label: const Text(
              //     'Login as Admin',
              //     style: TextStyle(
              //         color: AppColors.primary,
              //         fontWeight: FontWeight.w500),
              //   ),
              //   style: OutlinedButton.styleFrom(
              //     minimumSize: const Size(double.infinity, 50),
              //     side: const BorderSide(color: AppColors.primary),
              //     shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(12)),
              //   ),
              // ),
              // const SizedBox(height: 28),

              // Don't have account
              Center(
                child: GestureDetector(
                  onTap: () => Get.toNamed(AppRoutes.signup),
                  child: RichText(
                    text: const TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                      children: [
                        TextSpan(
                          text: 'Sign Up',
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
            ],
          ),
        ),
      ),
    );
  }
}
