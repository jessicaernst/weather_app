import 'package:flutter/material.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key, required this.title});

  final String title;

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 24,
          children: [
            const Text(
              'Aktuelle Temperatur: 20°C',
              style: TextStyle(fontSize: 24),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Wetter aktualisieren'),
            ),
          ],
        ),
      ),
    );
  }
}
