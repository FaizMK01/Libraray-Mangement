import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/add_book_controller.dart';
import '../../controllers/admin_dashboard_controller.dart';
import '../../routes/app_routes.dart';
import '../../utils/app_theme.dart';
import '../../widgets/admin_logout_fab.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminDashboardController());

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: const AdminLogoutFab(),
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      body: RefreshIndicator(
        onRefresh: controller.refreshStats,
        color: AppColors.primary,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.shield_rounded,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome, Admin',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Manage your library at a glance',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Overview',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Live stats from your library',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Obx(() {
                      if (controller.isLoading.value) {
                        return const SizedBox(
                          height: 200,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          ),
                        );
                      }

                      return GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 1.15,
                        children: [
                          _StatCard(
                            value: '${controller.totalBooks.value}',
                            label: 'Total Books',
                            icon: Icons.menu_book_rounded,
                            backgroundColor: AppColors.surface,
                            accentColor: AppColors.textPrimary,
                            iconBgColor: AppColors.background,
                          ),
                          _StatCard(
                            value: '${controller.pendingRequests.value}',
                            label: 'Pending',
                            icon: Icons.hourglass_top_rounded,
                            backgroundColor: AppColors.warningLight,
                            accentColor: AppColors.warning,
                            iconBgColor: const Color(0xFFF5E6C4),
                          ),
                          _StatCard(
                            value: '${controller.approvedRequests.value}',
                            label: 'Approved',
                            icon: Icons.verified_rounded,
                            backgroundColor: AppColors.successLight,
                            accentColor: AppColors.success,
                            iconBgColor: const Color(0xFFD4EBC4),
                          ),
                          _StatCard(
                            value: '${controller.totalMembers.value}',
                            label: 'Members',
                            icon: Icons.groups_rounded,
                            backgroundColor: AppColors.primaryLight,
                            accentColor: AppColors.primary,
                            iconBgColor: const Color(0xFFD0E4F7),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
            SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Common tasks for library management',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _ActionCard(
                      title: 'Add New Book',
                      subtitle: 'Search and add books from Google Books',
                      icon: Icons.add_circle_outline_rounded,
                      accentColor: AppColors.primary,
                      backgroundColor: AppColors.primaryLight,
                      onTap: () => _openAddBook(controller),
                    ),
                    const SizedBox(height: 12),
                    Obx(
                      () => _ActionCard(
                        title: 'View Requests',
                        subtitle:
                            '${controller.pendingRequests.value} pending approval',
                        icon: Icons.notifications_active_outlined,
                        accentColor: AppColors.warning,
                        backgroundColor: AppColors.warningLight,
                        badge: controller.pendingRequests.value > 0
                            ? '${controller.pendingRequests.value}'
                            : null,
                        onTap: () {
                          Get.toNamed(AppRoutes.userRequests)
                              ?.then((_) => controller.refreshStats());
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openAddBook(AdminDashboardController controller) {
    Get.toNamed(AppRoutes.addBook)?.then((_) {
      if (Get.isRegistered<AddBookController>()) {
        Get.delete<AddBookController>(force: true);
      }
      controller.refreshStats();
    });
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color accentColor;
  final Color iconBgColor;

  const _StatCard({
    required this.value,
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.accentColor,
    required this.iconBgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: accentColor, size: 22),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: accentColor,
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: accentColor.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final Color backgroundColor;
  final String? badge;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.backgroundColor,
    this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: accentColor, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (badge != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.warningLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      badge!,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.warning,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: AppColors.textHint,
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
