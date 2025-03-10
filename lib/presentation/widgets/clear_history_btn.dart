import 'package:flutter/material.dart';

class ClearHistoryBtn extends StatelessWidget {
  const ClearHistoryBtn({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
      child: const Text('🗑️ Historie löschen'),
    );
  }
}
