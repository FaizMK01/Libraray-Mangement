class BookModel {
  final String id;
  final String title;
  final String author;
  final String description;
  final String coverImageUrl;
  final int quantity;
  final int available;
  final String? pdfUrl;
  final String? googleBookId;
  final DateTime? createdAt;

  BookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.coverImageUrl,
    required this.quantity,
    required this.available,
    this.pdfUrl,
    this.googleBookId,
    this.createdAt,
  });

  factory BookModel.fromFirestore(Map<String, dynamic> data, String id) {
    return BookModel(
      id: id,
      title: data['title'] ?? '',
      author: data['author'] ?? '',
      description: data['description'] ?? '',
      coverImageUrl: data['coverImageUrl'] ?? '',
      quantity: data['quantity'] ?? 0,
      available: data['available'] ?? 0,
      pdfUrl: data['pdfUrl'],
      googleBookId: data['googleBookId'],
      createdAt: data['createdAt']?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'author': author,
      'description': description,
      'coverImageUrl': coverImageUrl,
      'quantity': quantity,
      'available': available,
      'pdfUrl': pdfUrl,
      'googleBookId': googleBookId,
    };
  }
}
