import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AdminDashboardController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final totalBooks = 0.obs;
  final pendingRequests = 0.obs;
  final approvedRequests = 0.obs;
  final totalMembers = 0.obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadStats();
  }

  Future<void> _loadStats() async {
    isLoading.value = true;
    try {
      final booksSnap = await _firestore.collection('books').get();
      final pendingSnap = await _firestore
          .collection('requests')
          .where('status', isEqualTo: 'pending')
          .get();
      final approvedSnap = await _firestore
          .collection('requests')
          .where('status', isEqualTo: 'approved')
          .get();
      final membersSnap = await _firestore.collection('users').get();

      totalBooks.value = booksSnap.docs.length;
      pendingRequests.value = pendingSnap.docs.length;
      approvedRequests.value = approvedSnap.docs.length;
      totalMembers.value = membersSnap.docs.length;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshStats() => _loadStats();
}
