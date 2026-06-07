import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/user_requests_controller.dart';
import '../../models/book_request_model.dart';
import '../../utils/app_theme.dart';

class UserRequestsScreen extends StatelessWidget {
  const UserRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserRequestsController());

    return Scaffold(
      backgroundColor: AppColors.background,
      // ── No AdminLogoutFab here — only the dashboard has it ───────────────
      appBar: adminAppBar('User Requests'),
      body: Obx(() {
        // Loading — only shown on genuine first load
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        // Error state
        if (controller.hasError.value) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.wifi_off_rounded,
                  size: 48,
                  color: AppColors.textHint,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Could not load requests',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: controller.refresh,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // Empty state
        if (controller.requests.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.warningLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.inbox_outlined,
                    size: 36,
                    color: AppColors.warning,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'No requests yet',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Student book requests will appear here',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
          itemCount: controller.requests.length,
          itemBuilder: (context, index) {
            final request = controller.requests[index];
            return _RequestCard(
              request: request,
              onApprove: () => controller.approveRequest(request),
              onReject: () => controller.rejectRequest(request),
            );
          },
        );
      }),
    );
  }
}

// ── Request card ──────────────────────────────────────────────────────────────

class _RequestCard extends StatelessWidget {
  final BookRequestModel request;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const _RequestCard({
    required this.request,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final isDone = request.isApproved || request.isRejected;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDone
              ? AppColors.border
              : AppColors.primary.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row: name + status badge
          Row(
            children: [
              Expanded(
                child: Text(
                  request.userName,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isDone ? AppColors.textHint : AppColors.textPrimary,
                  ),
                ),
              ),
              if (request.isApproved) _StatusBadge.approved(),
              if (request.isRejected) _StatusBadge.rejected(),
              if (!isDone) _StatusBadge.pending(),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            request.bookTitle,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDone ? AppColors.textHint : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'ID: ${request.studentId} · ${request.purpose}',
            style: const TextStyle(fontSize: 12, color: AppColors.textHint),
          ),

          // Action buttons — only shown for pending requests
          if (!isDone) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onApprove,
                    icon: const Icon(Icons.check_rounded, size: 18),
                    label: const Text('Approve'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      minimumSize: const Size(0, 44),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onReject,
                    icon: const Icon(Icons.close_rounded, size: 18),
                    label: const Text('Reject'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      minimumSize: const Size(0, 44),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ── Status badge ──────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final Color color;
  final Color bgColor;
  final IconData icon;
  final String label;

  const _StatusBadge({
    required this.color,
    required this.bgColor,
    required this.icon,
    required this.label,
  });

  factory _StatusBadge.approved() => const _StatusBadge(
    color: AppColors.success,
    bgColor: AppColors.successLight,
    icon: Icons.check_circle_outline_rounded,
    label: 'Approved',
  );

  factory _StatusBadge.rejected() => const _StatusBadge(
    color: AppColors.error,
    bgColor: AppColors.errorLight,
    icon: Icons.cancel_outlined,
    label: 'Rejected',
  );

  factory _StatusBadge.pending() => const _StatusBadge(
    color: AppColors.warning,
    bgColor: AppColors.warningLight,
    icon: Icons.hourglass_top_rounded,
    label: 'Pending',
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
