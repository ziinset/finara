import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/catatan_controller.dart';

class CatatanView extends GetView<CatatanController> {
  const CatatanView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CatatanView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Notes Page',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
