import 'package:flutter/material.dart';
import 'package:weather_app/core/app_strings.dart';

class RefreshBtn extends StatelessWidget {
  const RefreshBtn({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueGrey.withAlpha((0.2 * 255).toInt()),
      ),
      onPressed: onPressed,
      child: const Text(AppStrings.refreshBtnLbl),
    );
  }
}
