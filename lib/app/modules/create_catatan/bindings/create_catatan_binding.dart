import 'package:get/get.dart';

import '../../catatan/controllers/catatan_controller.dart';
import '../controllers/create_catatan_controller.dart';

class CreateCatatanBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure CatatanController is available (it may already be registered)
    if (!Get.isRegistered<CatatanController>()) {
      Get.lazyPut<CatatanController>(() => CatatanController());
    }
    Get.lazyPut<CreateCatatanController>(() => CreateCatatanController());
  }
}
