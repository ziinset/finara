import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../../catatan/controllers/catatan_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<CatatanController>(
      () => CatatanController(),
    );
  }
}
