import 'package:flutter/material.dart';

class ChartContentView extends StatelessWidget {
  const ChartContentView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Chart Page',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
