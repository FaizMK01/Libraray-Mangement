import 'package:flutter/foundation.dart';

class GutenbergBookModel {
  final String id;
  final String title;
  final String author;
  final String description;
  final String coverImageUrl;
  final String? pdfUrl;
  final String? htmlUrl;
  final String? epubUrl;
  final String? txtUrl;
  final int downloadCount;

  GutenbergBookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.coverImageUrl,
    this.pdfUrl,
    this.htmlUrl,
    this.epubUrl,
    this.txtUrl,
    required this.downloadCount,
  });

  /// The best URL to use for in-app reading.
  ///
  /// Priority: PDF (SfPdfViewer) > HTML cache URL (WebView) > TXT (WebView).
  /// EPUB is intentionally last — it's not directly renderable in a WebView.
  /// For Gutenberg books, htmlUrl is always the direct cached HTML page
  /// (https://www.gutenberg.org/cache/epub/{id}/pg{id}-images.html)
  /// which loads perfectly in the in-app WebView.
  String? get bestReadUrl {
    if (pdfUrl != null && pdfUrl!.isNotEmpty) return pdfUrl;
    if (htmlUrl != null && htmlUrl!.isNotEmpty) return htmlUrl;
    if (txtUrl != null && txtUrl!.isNotEmpty) return txtUrl;
    if (epubUrl != null && epubUrl!.isNotEmpty) return epubUrl;
    return null;
  }

  factory GutenbergBookModel.fromJson(Map<String, dynamic> json) {
    // --- Cover image ---
    String coverUrl = '';
    if (json['formats'] != null) {
      final formats = json['formats'] as Map<String, dynamic>;
      coverUrl = formats['image/jpeg'] as String? ?? '';
    }
    if (coverUrl.isEmpty) {
      coverUrl = json['cover'] as String? ?? '';
    }

    // --- Author ---
    String authorName = 'Unknown Author';
    if (json['authors'] != null && (json['authors'] as List).isNotEmpty) {
      final authors = json['authors'] as List;
      authorName = authors[0]['name'] as String? ?? 'Unknown Author';
    }

    // --- Description ---
    String description = '';
    if (json['summaries'] != null) {
      description = json['summaries'].toString();
    }

    // --- Book ID (needed for cache URL) ---
    final bookId = json['id']?.toString() ?? '';

    // --- Download URLs ---
    String? pdfUrl;
    String? htmlUrl;
    String? epubUrl;
    String? txtUrl;

    if (json['formats'] != null) {
      final formats = json['formats'] as Map<String, dynamic>;
      debugPrint('Gutenberg formats keys: ${formats.keys.toList()}');

      for (final entry in formats.entries) {
        final key = entry.key.toLowerCase().trim();
        final value = entry.value as String?;
        if (value == null || value.isEmpty) continue;

        if (key == 'application/pdf' || key.contains('pdf')) {
          pdfUrl ??= value;
        } else if (key.contains('text/html') || key.contains('html')) {
          htmlUrl ??= value;
        } else if (key.contains('epub')) {
          epubUrl ??= value;
        } else if (key.contains('text/plain') || key.contains('plain')) {
          txtUrl ??= value;
        }
      }

      // -----------------------------------------------------------------------
      // KEY FIX: Convert Gutenberg's indirect HTML URL to the direct cache URL.
      //
      // Gutendex returns:  https://www.gutenberg.org/ebooks/1260.html.images
      //   → This is a redirect/download-style URL. WebView treats it as a
      //     file download and cannot render it.
      //
      // The actual renderable HTML page lives at:
      //   https://www.gutenberg.org/cache/epub/1260/pg1260-images.html
      //   → This is a plain HTTPS HTML file that WebView renders perfectly.
      //
      // We construct the cache URL directly using the book ID so the stored
      // URL in Firestore is always directly usable by the in-app WebView.
      // -----------------------------------------------------------------------
      if (bookId.isNotEmpty) {
        htmlUrl =
            'https://www.gutenberg.org/cache/epub/$bookId/pg$bookId-images.html';
        debugPrint('Using Gutenberg cache HTML URL: $htmlUrl');
      }

      debugPrint('Extracted PDF URL : $pdfUrl');
      debugPrint('Extracted HTML URL: $htmlUrl');
      debugPrint('Extracted EPUB URL: $epubUrl');
      debugPrint('Extracted TXT URL : $txtUrl');
    }

    return GutenbergBookModel(
      id: bookId,
      title: json['title'] ?? 'Unknown Title',
      author: authorName,
      description: description,
      coverImageUrl: coverUrl,
      pdfUrl: pdfUrl,
      htmlUrl: htmlUrl,
      epubUrl: epubUrl,
      txtUrl: txtUrl,
      downloadCount: json['download_count'] ?? 0,
    );
  }
}
