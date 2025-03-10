import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  const ErrorMessage({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  final String errorMessage;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 20,
      children: [
        Text(errorMessage, style: const TextStyle(color: Colors.red)),
        ElevatedButton(
          onPressed: onRetry,
          child: const Text('🔄 Wetter erneut abrufen'),
        ),
      ],
    );
  }
}
