import 'package:get/get.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  var currentIndex = 0.obs;
  var isFabOpen = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void changePage(int index) {
    currentIndex.value = index;
    isFabOpen.value = false; // close FAB menu when changing page
  }

  void toggleFab() {
    isFabOpen.value = !isFabOpen.value;
  }
}
