// lib/controllers/user_requests_controller.dart
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../models/book_request_model.dart';
import '../utils/app_snackbar.dart';

class UserRequestsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final requests = <BookRequestModel>[].obs;
  final isLoading = true.obs;
  final hasError = false.obs; // ← was missing

  StreamSubscription? _sub;

  @override
  void onInit() {
    super.onInit();
    _listenToRequests();
  }

  void _listenToRequests() {
    // Only show spinner when list is genuinely empty (first visit).
    // On back-navigation Firestore returns cached data instantly → no flicker.
    if (requests.isEmpty) isLoading.value = true;
    hasError.value = false;

    _sub = _firestore
        .collection('requests')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen(
          (snapshot) {
            requests.assignAll(
              snapshot.docs
                  .map(
                    (doc) => BookRequestModel.fromFirestore(doc.data(), doc.id),
                  )
                  .toList(),
            );
            isLoading.value = false;
          },
          onError: (_) {
            hasError.value = true;
            isLoading.value = false;
          },
        );
  }

  /// Called by the Retry button in the error state.
  void refresh() {
    _sub?.cancel();
    _listenToRequests();
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

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }
}
