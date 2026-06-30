import 'package:get/get.dart';

import '../controllers/wallet_controller.dart';

class WalletBinding extends Bindings {
  @override
  void dependencies() {
    // WalletController is already registered as permanent in main.dart.
    // We just find it here to avoid creating a duplicate instance.
    Get.find<WalletController>();
  }
}
