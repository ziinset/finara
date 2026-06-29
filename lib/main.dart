import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:intl/date_symbol_data_local.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  
  runApp(
    GetMaterialApp(
      title: "Application",
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
