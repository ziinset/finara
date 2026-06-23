import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() {
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
