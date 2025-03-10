import 'package:flutter/material.dart';

class SevenDayForecast extends StatelessWidget {
  const SevenDayForecast({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          '📅 7-Tage-Vorhersage',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 7, // Später aus API abrufen
          itemBuilder: (context, index) {
            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: ListTile(
                leading: const Icon(Icons.wb_sunny),
                title: Text('Tag ${index + 1}'),
                subtitle: const Text('🌡 15-23°C | 🌧 10% Regen'),
              ),
            );
          },
        ),
      ],
    );
  }
}
