import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../../catatan/controllers/catatan_controller.dart';
import '../../statistik/controllers/statistik_controller.dart';
import '../../profile/controllers/profile_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Permanent agar state navbar tidak hilang saat pindah tab
    Get.put<HomeController>(HomeController(), permanent: true);
    // fenix: true agar bisa di-recreate setelah disposed
    Get.lazyPut<CatatanController>(
      () => CatatanController(),
      fenix: true,
    );
    Get.lazyPut<StatistikController>(
      () => StatistikController(),
      fenix: true,
    );
    Get.lazyPut<ProfileController>(
      () => ProfileController(),
      fenix: true,
    );
  }
}
