class UrlHelper {
  UrlHelper._();

  static String? normalize(String? url) {
    if (url == null || url.trim().isEmpty) return null;

    var normalized = url.trim();
    if (normalized.startsWith('http://')) {
      normalized = normalized.replaceFirst('http://', 'https://');
    } else if (!normalized.startsWith('http')) {
      normalized = 'https://$normalized';
    }
    return normalized;
  }

  static String? firstValid(Iterable<String?> urls) {
    for (final url in urls) {
      final normalized = normalize(url);
      if (normalized != null) return normalized;
    }
    return null;
  }
}
