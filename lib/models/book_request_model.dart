class BookRequestModel {
  final String id;
  final String bookId;
  final String bookTitle;
  final String bookAuthor;
  final String userId;
  final String userName;
  final String studentId;
  final String purpose;
  final String status;
  final String? pdfUrl;
  final DateTime? createdAt;

  BookRequestModel({
    required this.id,
    required this.bookId,
    required this.bookTitle,
    required this.bookAuthor,
    required this.userId,
    required this.userName,
    required this.studentId,
    required this.purpose,
    required this.status,
    this.pdfUrl,
    this.createdAt,
  });

  factory BookRequestModel.fromFirestore(Map<String, dynamic> data, String id) {
    return BookRequestModel(
      id: id,
      bookId: data['bookId'] ?? '',
      bookTitle: data['bookTitle'] ?? '',
      bookAuthor: data['bookAuthor'] ?? '',
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      studentId: data['studentId'] ?? '',
      purpose: data['purpose'] ?? '',
      status: data['status'] ?? 'pending',
      pdfUrl: data['pdfUrl'],
      createdAt: data['createdAt']?.toDate(),
    );
  }

  bool get isPending => status == 'pending';
  bool get isApproved => status == 'approved';
  bool get isRejected => status == 'rejected';
}
