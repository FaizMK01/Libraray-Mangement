import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/gutenberg_book_details_controller.dart';
import '../../models/gutenberg_book_model.dart';
import '../../utils/app_theme.dart';
import '../../widgets/book_cover_widget.dart';
import '../../widgets/form_label.dart';

class GutenbergBookDetailsScreen extends StatelessWidget {
  const GutenbergBookDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gutenbergBook = Get.arguments as GutenbergBookModel;
    if (Get.isRegistered<GutenbergBookDetailsController>()) {
      Get.delete<GutenbergBookDetailsController>(force: true);
    }
    final controller = Get.put(
      GutenbergBookDetailsController(gutenbergBook: gutenbergBook),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Book Details',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
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
              const FormLabel('Title'),
              const SizedBox(height: 6),
              TextFormField(
                controller: controller.titleController,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Title is required' : null,
              ),
              const SizedBox(height: 16),
              const FormLabel('Author'),
              const SizedBox(height: 6),
              TextFormField(
                controller: controller.authorController,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Author is required' : null,
              ),
              const SizedBox(height: 16),
              const FormLabel('Description'),
              const SizedBox(height: 6),
              TextFormField(
                controller: controller.descriptionController,
                maxLines: 5,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Description is required' : null,
              ),
              const SizedBox(height: 16),
              const FormLabel('Cover Image'),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: AppColors.successLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFC5DEB0)),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: AppColors.success,
                      size: 18,
                    ),
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
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: AppColors.successLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFC5DEB0)),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.download_done,
                      color: AppColors.success,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'PDF/EPUB Available',
                      style: TextStyle(
                        color: AppColors.success,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              // const SizedBox(height: 16),
              // const FormLabel('Quantity (copies)'),
              // const SizedBox(height: 6),
              // TextFormField(
              //   controller: controller.quantityController,
              //   keyboardType: TextInputType.number,
              //   validator: (v) {
              //     if (v == null || v.isEmpty) return 'Quantity is required';
              //     final qty = int.tryParse(v);
              //     if (qty == null || qty < 1) return 'Enter a valid quantity';
              //     return null;
              //   },
              // ),
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
}
