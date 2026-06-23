import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/add_book_manual_controller.dart';
import '../../utils/app_theme.dart';
import '../../widgets/book_cover_widget.dart';
import '../../widgets/form_label.dart';

class AddBookManualScreen extends StatelessWidget {
  const AddBookManualScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddBookManualController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: adminAppBar('Add Book Manually'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Center(
                child: Obx(
                  () => BookCoverWidget(
                    title: controller.titleRx.value.isEmpty
                        ? 'Book Preview'
                        : controller.titleRx.value,
                    width: 110,
                    height: 154,
                    borderRadius: 16,
                    iconSize: 44,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              const FormLabel('Book Title'),
              const SizedBox(height: 6),
              TextFormField(
                controller: controller.titleController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  hintText: 'e.g. Clean Code',
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Book Title is required' : null,
              ),
              const SizedBox(height: 16),
              const FormLabel('Author (Optional)'),
              const SizedBox(height: 6),
              TextFormField(
                controller: controller.authorController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  hintText: 'e.g. Robert C. Martin (defaults to "Unknown")',
                ),
              ),
              const SizedBox(height: 16),
              const FormLabel('Book Description'),
              const SizedBox(height: 6),
              TextFormField(
                controller: controller.descriptionController,
                maxLines: 5,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: 'Enter a summary or description of the book...',
                  alignLabelWithHint: true,
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Book Description is required' : null,
              ),
              const SizedBox(height: 16),
              const FormLabel('PDF URL'),
              const SizedBox(height: 6),
              TextFormField(
                controller: controller.pdfUrlController,
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(
                  hintText: 'e.g. https://example.com/book.pdf',
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'PDF URL is required';
                  }
                  if (!GetUtils.isURL(v.trim())) {
                    return 'Please enter a valid URL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 36),
              Obx(
                () => ElevatedButton(
                  onPressed: controller.isSaving.value
                      ? null
                      : controller.saveBook,
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
