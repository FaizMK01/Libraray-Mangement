class GoogleBookModel {
  final String id;
  final String title;
  final String author;
  final String description;
  final String coverImageUrl;
  final String? previewLink;
  final String? infoLink;
  final String? webReaderLink;
  final String? pdfUrl;

  GoogleBookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.coverImageUrl,
    this.previewLink,
    this.infoLink,
    this.webReaderLink,
    this.pdfUrl,
  });

  String? get bestReadUrl {
    final candidates = [
      pdfUrl,
      webReaderLink,
      previewLink,
      infoLink,
      id.isNotEmpty ? 'https://books.google.com/books?id=$id' : null,
    ];

    for (final url in candidates) {
      if (url != null && url.trim().isNotEmpty) {
        return _normalizeUrl(url.trim());
      }
    }
    return null;
  }

  static String _normalizeUrl(String url) {
    if (url.startsWith('http://')) {
      return url.replaceFirst('http://', 'https://');
    }
    if (!url.startsWith('http')) {
      return 'https://$url';
    }
    return url;
  }

  factory GoogleBookModel.fromJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'] as Map<String, dynamic>? ?? {};
    final accessInfo = json['accessInfo'] as Map<String, dynamic>? ?? {};
    final pdf = accessInfo['pdf'] as Map<String, dynamic>? ?? {};

    final authors = volumeInfo['authors'] as List<dynamic>?;
    final imageLinks = volumeInfo['imageLinks'] as Map<String, dynamic>?;

    String coverUrl = '';
    if (imageLinks != null) {
      coverUrl = imageLinks['thumbnail'] ??
          imageLinks['smallThumbnail'] ??
          '';
      if (coverUrl.startsWith('http:')) {
        coverUrl = coverUrl.replaceFirst('http:', 'https:');
      }
    }

    return GoogleBookModel(
      id: json['id'] ?? '',
      title: volumeInfo['title'] ?? 'Unknown Title',
      author: authors != null && authors.isNotEmpty
          ? authors.join(', ')
          : 'Unknown Author',
      description: volumeInfo['description'] ?? 'No description available.',
      coverImageUrl: coverUrl,
      previewLink: volumeInfo['previewLink'] as String?,
      infoLink: volumeInfo['infoLink'] as String?,
      webReaderLink: accessInfo['webReaderLink'] as String?,
      pdfUrl: pdf['downloadLink'] as String?,
    );
  }
}
