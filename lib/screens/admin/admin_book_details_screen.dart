import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/admin_book_details_controller.dart';
import '../../models/google_book_model.dart';
import '../../utils/app_theme.dart';
import '../../widgets/book_cover_widget.dart';

class AdminBookDetailsScreen extends StatelessWidget {
  const AdminBookDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final googleBook = Get.arguments as GoogleBookModel;
    if (Get.isRegistered<AdminBookDetailsController>()) {
      Get.delete<AdminBookDetailsController>(force: true);
    }
    final controller = Get.put(
      AdminBookDetailsController(googleBook: googleBook),
    );

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
            Icon(Icons.edit_outlined, color: AppColors.primary, size: 22),
            SizedBox(width: 8),
            Text(
              'Book Details',
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
              Center(
                child: Obx(
                  () => BookCoverWidget(
                    title: controller.titleController.text,
                    imageUrl: controller.coverImageUrl.value,
                    width: 100,
                    height: 140,
                    borderRadius: 14,
                    iconSize: 40,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildLabel('Title'),
              const SizedBox(height: 6),
              TextFormField(
                controller: controller.titleController,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Title is required' : null,
              ),
              const SizedBox(height: 16),
              _buildLabel('Author'),
              const SizedBox(height: 6),
              TextFormField(
                controller: controller.authorController,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Author is required' : null,
              ),
              const SizedBox(height: 16),
              _buildLabel('Description'),
              const SizedBox(height: 6),
              TextFormField(
                controller: controller.descriptionController,
                maxLines: 5,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Description is required' : null,
              ),
              const SizedBox(height: 16),
              _buildLabel('Cover Image'),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.successLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFC5DEB0)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle, color: AppColors.success, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Auto loaded',
                      style: TextStyle(
                        color: AppColors.success,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildLabel('Quantity (copies)'),
              const SizedBox(height: 6),
              TextFormField(
                controller: controller.quantityController,
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Quantity is required';
                  final qty = int.tryParse(v);
                  if (qty == null || qty < 1) return 'Enter a valid quantity';
                  return null;
                },
              ),
              const SizedBox(height: 32),
              Obx(
                () => ElevatedButton(
                  onPressed: controller.isSaving.value
                      ? null
                      : controller.saveToLibrary,
                  child: controller.isSaving.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Save to Library'),
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
