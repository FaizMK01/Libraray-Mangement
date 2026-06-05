import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/admin_login_controller.dart';
import '../utils/app_dialogs.dart';
import '../utils/app_theme.dart';

class AdminLogoutFab extends StatelessWidget {
  const AdminLogoutFab({super.key});

  Future<void> _logout() async {
    final confirmed = await AppDialogs.confirmLogout();
    if (!confirmed) return;

    final controller = Get.put(AdminLoginController());
    await controller.logout();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: _logout,
      backgroundColor: AppColors.error,
      foregroundColor: Colors.white,
      elevation: 4,
      icon: const Icon(Icons.logout_rounded, size: 20),
      label: const Text(
        'Logout',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}
