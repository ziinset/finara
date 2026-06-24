import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../../catatan/controllers/catatan_controller.dart';
import '../../statistik/controllers/statistik_controller.dart';
import '../../profile/controllers/profile_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<CatatanController>(
      () => CatatanController(),
    );
    Get.lazyPut<StatistikController>(
      () => StatistikController(),
    );
    Get.lazyPut<ProfileController>(
      () => ProfileController(),
    );
  }
}
