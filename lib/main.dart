import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app/routes/app_pages.dart';
import 'app/modules/wallet/controllers/wallet_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  
  // Inject globally so HomeController and WalletView can easily access it
  Get.put(WalletController(), permanent: true);
  
  runApp(
    GetMaterialApp(
      title: "Application",
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFEAEADE),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3A6043),
          background: const Color(0xFFEAEADE),
        ),
      ),
    ),
  );
}
