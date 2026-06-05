import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/book_request_model.dart';

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
                .map(
                  (doc) => BookRequestModel.fromFirestore(doc.data(), doc.id),
                )
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

      Get.snackbar(
        'Approved',
        '${request.userName} equest has been approved!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEAF3DE),
        colorText: const Color(0xFF0F6E56),
        icon: const Icon(Icons.check_circle, color: Color(0xFF0F6E56)),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to approve request',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> rejectRequest(BookRequestModel request) async {
    try {
      await _firestore.collection('requests').doc(request.id).update({
        'status': 'rejected',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      Get.snackbar(
        'Rejected',
        '${request.userName} request has been rejected',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFCEBEB),
        colorText: const Color(0xFFA32D2D),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to reject request',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
