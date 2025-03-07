import 'package:flutter/material.dart';
import 'package:weather_app/presentation/screens/weather_page.dart';

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData.dark(),
      home: const WeatherPage(title: 'Flutter Demo Home Page'),
    );
  }
}
