import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/admin_login_controller.dart';
import '../../utils/app_theme.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              final controller = Get.put(AdminLoginController());
              await controller.logout();
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Admin Module — Coming Next!',
          style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
        ),
      ),
    );
  }
}
