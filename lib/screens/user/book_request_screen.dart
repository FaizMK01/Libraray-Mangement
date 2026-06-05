import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/book_request_controller.dart';
import '../../models/book_model.dart';
import '../../utils/app_theme.dart';

class BookRequestScreen extends StatelessWidget {
  const BookRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final book = Get.arguments as BookModel;
    final controller = Get.put(BookRequestController(book: book));

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
        title: const Row(
          children: [
            Icon(Icons.description_outlined, color: AppColors.primary, size: 22),
            SizedBox(width: 8),
            Text(
              'Book Request',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  '${book.title} — ${book.author}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildLabel('Name'),
              const SizedBox(height: 6),
              TextFormField(
                controller: controller.nameController,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Name is required' : null,
              ),
              const SizedBox(height: 16),
              _buildLabel('Student ID'),
              const SizedBox(height: 6),
              TextFormField(
                controller: controller.studentIdController,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Student ID is required' : null,
              ),
              const SizedBox(height: 16),
              _buildLabel('Purpose / Note'),
              const SizedBox(height: 6),
              TextFormField(
                controller: controller.purposeController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Research work...',
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Purpose is required' : null,
              ),
              const SizedBox(height: 32),
              Obx(
                () => ElevatedButton(
                  onPressed: controller.isSubmitting.value
                      ? null
                      : controller.submitRequest,
                  child: controller.isSubmitting.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Submit Request'),
                ),
              ),
            ],
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
