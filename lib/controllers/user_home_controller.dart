import 'package:get/get.dart';

class UserHomeController extends GetxController {
  final currentIndex = 0.obs;

  void changeTab(int index) => currentIndex.value = index;
}
