import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../utils/app_snackbar.dart';

class BookReaderController extends GetxController {
  late final String url;
  late final String title;
  late final bool isPdf;

  WebViewController? webController;
  final loadProgress = 0.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>;
    var rawUrl = args['url'] as String;
    title = args['title'] as String? ?? 'Reading';

    debugPrint('BookReaderController — raw URL: $rawUrl');

    // Resolve the best in-app URL from whatever was stored
    rawUrl = _resolveToReadableUrl(rawUrl);

    url = rawUrl;
    debugPrint('BookReaderController — resolved URL: $url');

    final lower = url.toLowerCase();
    isPdf = lower.endsWith('.pdf') || lower.contains('/pdf/');

    debugPrint('isPdf: $isPdf');

    // Geo-restricted check (Google Books, etc.)
    if (_isGeoRestrictedUrl(url)) {
      debugPrint('URL is geo-restricted');
      hasError.value = true;
      errorMessage.value =
          'This book is restricted and cannot be read in-app.\n'
          'Tap "Open in Browser" below to read it online.';
      return;
    }

    if (isPdf) {
      debugPrint('Using SfPdfViewer');
    } else {
      debugPrint('Using WebView');
      _initWebView();
    }
  }

  /// Convert any Gutenberg URL (ebooks redirect, epub, txt, etc.) to the
  /// direct cached HTML page that WebView can render immediately.
  ///
  /// Pattern:  https://www.gutenberg.org/cache/epub/{id}/pg{id}-images.html
  String _resolveToReadableUrl(String raw) {
    if (!raw.contains('gutenberg.org')) return raw;

    // Extract numeric book ID from any gutenberg.org URL path segment
    final idMatch = RegExp(r'/(?:ebooks|cache/epub)/(\d+)').firstMatch(raw);
    if (idMatch != null) {
      final id = idMatch.group(1)!;
      final cacheUrl =
          'https://www.gutenberg.org/cache/epub/$id/pg$id-images.html';
      debugPrint('Resolved to Gutenberg cache URL: $cacheUrl');
      return cacheUrl;
    }

    // If the URL already looks like a cache URL or we can't parse an ID,
    // return as-is
    return raw;
  }

  void _initWebView() {
    webController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      // A real browser User-Agent prevents servers from serving download
      // responses or bot-detection pages instead of renderable HTML.
      ..setUserAgent(
        'Mozilla/5.0 (Linux; Android 13; Pixel 7) '
        'AppleWebKit/537.36 (KHTML, like Gecko) '
        'Chrome/120.0.6099.230 Mobile Safari/537.36',
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (p) {
            loadProgress.value = p;
            debugPrint('WebView progress: $p%');
          },
          onPageStarted: (pageUrl) {
            debugPrint('WebView page started: $pageUrl');
            // Clear any previous error when navigation begins
            hasError.value = false;
          },
          onPageFinished: (pageUrl) {
            debugPrint('WebView page finished: $pageUrl');
            loadProgress.value = 100;
            // Page finished loading — clear any mid-load connection error.
            // Gutenberg's CDN sometimes resets sub-connections (ERR_CONNECTION_RESET)
            // during HTTP/2 multiplexed loads but the page still completes.
            // If onPageFinished fires, the content is rendered — don't show error.
            hasError.value = false;
          },
          onWebResourceError: (error) {
            debugPrint(
              'WebView error — code: ${error.errorCode}, '
              'desc: ${error.description}, '
              'isMain: ${error.isForMainFrame}',
            );
            // Only raise an error for main-frame failures (not sub-resources
            // like blocked analytics scripts or stylesheets).
            if (error.isForMainFrame ?? true) {
              hasError.value = true;
              errorMessage.value =
                  'Could not load the book page.\n'
                  'Tap "Open in Browser" below to read it online.';
            }
          },
          onNavigationRequest: (request) {
            // Allow all navigation — Gutenberg pages have internal links
            debugPrint('WebView navigating to: ${request.url}');
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
  }

  bool _isGeoRestrictedUrl(String checkUrl) {
    final lower = checkUrl.toLowerCase();
    return lower.contains('books.google.com') ||
        lower.contains('play.google.com/books') ||
        lower.contains('googleapis.com/books');
  }

  Future<void> openInBrowser() async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        AppSnackbar.error('Cannot Open', 'Unable to open the link in browser.');
      }
    } catch (_) {
      AppSnackbar.error('Error', 'Failed to open the link.');
    }
  }

  void reload() => webController?.reload();
}
