import 'package:flutter/material.dart';

class RefreshBtn extends StatelessWidget {
  const RefreshBtn({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: const Text('🔄 Wetter aktualisieren'),
    );
  }
}
