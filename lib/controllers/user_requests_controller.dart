import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../models/book_request_model.dart';
import '../utils/app_snackbar.dart';

class UserRequestsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final requests = <BookRequestModel>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _listenToRequests();
  }

  void _listenToRequests() {
    _firestore
        .collection('requests')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      requests.assignAll(
        snapshot.docs
            .map((doc) => BookRequestModel.fromFirestore(doc.data(), doc.id))
            .toList(),
      );
      isLoading.value = false;
    });
  }

  Future<void> approveRequest(BookRequestModel request) async {
    try {
      await _firestore.collection('requests').doc(request.id).update({
        'status': 'approved',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      AppSnackbar.success(
        'Request Approved',
        "${request.userName}'s request for \"${request.bookTitle}\" has been approved.",
      );
    } catch (_) {
      AppSnackbar.error(
        'Approval Failed',
        'Unable to approve this request. Please try again.',
      );
    }
  }

  Future<void> rejectRequest(BookRequestModel request) async {
    try {
      await _firestore.collection('requests').doc(request.id).update({
        'status': 'rejected',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      AppSnackbar.warning(
        'Request Rejected',
        "${request.userName}'s request for \"${request.bookTitle}\" has been rejected.",
      );
    } catch (_) {
      AppSnackbar.error(
        'Rejection Failed',
        'Unable to reject this request. Please try again.',
      );
    }
  }
}
