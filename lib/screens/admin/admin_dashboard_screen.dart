import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/admin_dashboard_controller.dart';
import '../../controllers/admin_login_controller.dart';
import '../../routes/app_routes.dart';
import '../../utils/app_theme.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminDashboardController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.dashboard_outlined, color: Colors.white, size: 22),
            SizedBox(width: 8),
            Text(
              'Dashboard',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              final loginController = Get.put(AdminLoginController());
              await loginController.logout();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: controller.refreshStats,
        color: AppColors.primary,
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.4,
                  children: [
                    _StatCard(
                      label: '${controller.totalBooks.value} Total Books',
                      backgroundColor: AppColors.surface,
                      textColor: AppColors.textPrimary,
                      borderColor: AppColors.border,
                    ),
                    _StatCard(
                      label: '${controller.pendingRequests.value} Pending',
                      backgroundColor: AppColors.warningLight,
                      textColor: AppColors.warning,
                      borderColor: const Color(0xFFE8D5A8),
                    ),
                    _StatCard(
                      label: '${controller.approvedRequests.value} Approved',
                      backgroundColor: AppColors.successLight,
                      textColor: AppColors.success,
                      borderColor: const Color(0xFFC5DEB0),
                    ),
                    _StatCard(
                      label: '${controller.totalMembers.value} Members',
                      backgroundColor: AppColors.primaryLight,
                      textColor: AppColors.primary,
                      borderColor: const Color(0xFFB8D4F0),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                const Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 14),
                _ActionButton(
                  label: 'Add New Book',
                  icon: Icons.add_rounded,
                  backgroundColor: AppColors.primaryLight,
                  textColor: AppColors.primary,
                  borderColor: const Color(0xFFB8D4F0),
                  onTap: () async {
                    await Get.toNamed(AppRoutes.addBook);
                    controller.refreshStats();
                  },
                ),
                const SizedBox(height: 12),
                _ActionButton(
                  label:
                      'View Requests (${controller.pendingRequests.value})',
                  icon: Icons.notifications_outlined,
                  backgroundColor: AppColors.warningLight,
                  textColor: AppColors.warning,
                  borderColor: const Color(0xFFE8D5A8),
                  onTap: () async {
                    await Get.toNamed(AppRoutes.userRequests);
                    controller.refreshStats();
                  },
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;

  const _StatCard({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: textColor, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
