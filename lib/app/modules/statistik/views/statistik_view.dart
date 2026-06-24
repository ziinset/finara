import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/statistik_controller.dart';

class StatistikView extends GetView<StatistikController> {
  const StatistikView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StatistikView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'StatistikView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
