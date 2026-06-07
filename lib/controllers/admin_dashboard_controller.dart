import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AdminDashboardController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final totalBooks = 0.obs;
  final pendingRequests = 0.obs;
  final approvedRequests = 0.obs;
  final totalMembers = 0.obs;
  final isLoading = true.obs;
  // Used by the dashboard screen to show error state + retry button
  final hasError = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadStats();
  }

  Future<void> _loadStats() async {
    isLoading.value = true;
    hasError.value = false;
    try {
      final results = await Future.wait([
        _firestore.collection('books').get(),
        _firestore
            .collection('requests')
            .where('status', isEqualTo: 'pending')
            .get(),
        _firestore
            .collection('requests')
            .where('status', isEqualTo: 'approved')
            .get(),
        _firestore.collection('users').get(),
      ]);

      totalBooks.value = results[0].docs.length;
      pendingRequests.value = results[1].docs.length;
      approvedRequests.value = results[2].docs.length;
      totalMembers.value = results[3].docs.length;
    } catch (_) {
      // Show error state in UI — user can tap Retry
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshStats() => _loadStats();
}
