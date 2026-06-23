import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../controllers/book_read_controller.dart';
import '../../utils/app_theme.dart';

class InAppBookReaderScreen extends StatelessWidget {
  const InAppBookReaderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BookReaderController());

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
        title: Text(
          controller.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          // Reload button (WebView only)
          if (!controller.isPdf)
            IconButton(
              icon: const Icon(Icons.refresh_rounded, size: 20),
              tooltip: 'Reload',
              onPressed: controller.reload,
            ),
          // Always show open-in-browser button as a convenience
          IconButton(
            icon: const Icon(Icons.open_in_browser_rounded, size: 20),
            tooltip: 'Open in browser',
            onPressed: controller.openInBrowser,
          ),
        ],
      ),
      body: Obx(() {
        // ── Error state ──────────────────────────────────────────────────────
        if (controller.hasError.value) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.menu_book_outlined,
                    size: 72,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Unable to Load Book',
                    style: AppTextStyles.heading2,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    controller.errorMessage.value,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.subtitle,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: controller.openInBrowser,
                      icon: const Icon(Icons.open_in_browser_rounded),
                      label: const Text('Open in Browser'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.arrow_back_rounded),
                      label: const Text('Go Back'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // ── PDF viewer ───────────────────────────────────────────────────────
        if (controller.isPdf) {
          return SfPdfViewer.network(controller.url);
        }

        // ── WebView with loading progress bar ────────────────────────────────
        return Stack(
          children: [
            WebViewWidget(controller: controller.webController!),
            Obx(() {
              final p = controller.loadProgress.value;
              if (p >= 100) return const SizedBox.shrink();
              return Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: LinearProgressIndicator(
                  value: p / 100,
                  backgroundColor: AppColors.border,
                  valueColor:
                      const AlwaysStoppedAnimation(AppColors.primary),
                  minHeight: 3,
                ),
              );
            }),
          ],
        );
      }),
    );
  }
}
