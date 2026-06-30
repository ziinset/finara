import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:finara/app/data/models/wallet_model.dart';
import 'package:finara/app/modules/home/controllers/home_controller.dart';

class WalletController extends GetxController {
  // Reactive list of wallets
  final wallets = <WalletModel>[].obs;
  
  // Mock Premium status
  final isPremium = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with a default Main account wallet
    wallets.add(
      WalletModel(
        id: const Uuid().v4(),
        name: 'Main account',
        icon: Icons.account_balance_wallet,
        color: const Color(0xFF3A6043), // Primary green
        balance: 114050000,
        isActive: true,
      ),
    );
  }

  // Get active wallet
  WalletModel? get activeWallet {
    try {
      return wallets.firstWhere((element) => element.isActive);
    } catch (e) {
      return null;
    }
  }

  // Set active wallet
  void selectWallet(String id) {
    for (int i = 0; i < wallets.length; i++) {
      if (wallets[i].id == id) {
        wallets[i] = wallets[i].copyWith(isActive: true);
      } else {
        if (wallets[i].isActive) {
          wallets[i] = wallets[i].copyWith(isActive: false);
        }
      }
    }
    wallets.refresh(); // Important for GetX to detect deeper changes if using copyWith

    // Sync with HomeController
    final homeController = Get.find<HomeController>();
    final active = activeWallet;
    if (active != null) {
      homeController.updateActiveWallet(active);
    }
  }

  // Add new wallet
  bool addWallet(WalletModel newWallet) {
    // Check Freemium vs Premium limits
    if (!isPremium.value && wallets.isNotEmpty) {
      // Freemium can only have 1 active wallet (which is already there)
      // They can't add another one
      _showPremiumDialog();
      return false;
    }

    if (isPremium.value && wallets.length >= 10) {
      Get.snackbar('Batas Maksimal', 'Anda tidak dapat menambahkan lebih dari 10 wallet.');
      return false;
    }

    wallets.add(newWallet);
    return true;
  }

  void _showPremiumDialog() {
    Get.defaultDialog(
      title: 'Fitur Premium',
      middleText: 'Pengguna Freemium hanya dapat memiliki 1 wallet. Upgrade ke Premium untuk menambahkan hingga 10 wallet!',
      textConfirm: 'Upgrade',
      textCancel: 'Batal',
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFF3A6043),
      onConfirm: () {
        Get.back(); // close dialog
        isPremium.value = true;
        Get.snackbar('Premium Aktif', 'Anda sekarang adalah pengguna Premium (Mock)');
      },
    );
  }
}
