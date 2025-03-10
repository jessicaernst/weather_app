import 'package:flutter/material.dart';
import 'package:weather_app/core/app_strings.dart';

class ClearHistoryBtn extends StatelessWidget {
  const ClearHistoryBtn({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(backgroundColor: Colors.white12),
      child: const Text(AppStrings.clearHistoryBtnLbl),
    );
  }
}
