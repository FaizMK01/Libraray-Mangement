import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/user_requests_controller.dart';
import '../../models/book_request_model.dart';
import '../../utils/app_theme.dart';
import '../../widgets/admin_logout_fab.dart';

class UserRequestsScreen extends StatelessWidget {
  const UserRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserRequestsController());

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: const AdminLogoutFab(),
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'User Requests',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (controller.requests.isEmpty) {
          return const Center(
            child: Text(
              'No requests yet',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
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
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            request.userName,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDone ? AppColors.textHint : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            request.bookTitle,
            style: TextStyle(
              fontSize: 14,
              color: isDone ? AppColors.textHint : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'ID: ${request.studentId} · ${request.purpose}',
            style: TextStyle(
              fontSize: 12,
              color: isDone ? AppColors.textHint : AppColors.textHint,
            ),
          ),
          const SizedBox(height: 14),
          if (request.isApproved)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.successLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check, color: AppColors.success, size: 16),
                  SizedBox(width: 4),
                  Text(
                    'Approved',
                    style: TextStyle(
                      color: AppColors.success,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            )
          else if (request.isRejected)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.errorLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.close, color: AppColors.error, size: 16),
                  SizedBox(width: 4),
                  Text(
                    'Rejected',
                    style: TextStyle(
                      color: AppColors.error,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            )
          else
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onApprove,
                    icon: const Icon(Icons.check, size: 18),
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
                    icon: const Icon(Icons.close, size: 18),
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
      ),
    );
  }
}
