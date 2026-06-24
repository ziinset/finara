import 'package:flutter/material.dart';

class NotesContentView extends StatelessWidget {
  const NotesContentView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Notes Page',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
