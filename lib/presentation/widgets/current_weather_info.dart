import 'package:flutter/material.dart';
import 'package:weather_app/models/weather_data.dart';

class CurrentWeatherInfo extends StatelessWidget {
  const CurrentWeatherInfo({super.key, required this.weatherData});

  final WeatherData weatherData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          '🌡 Aktuelle Temperatur: ',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          '${weatherData.temperature.toStringAsFixed(1)}°C',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(
          '🌤 Wetterlage: ${weatherData.weatherCondition}',
          style: const TextStyle(fontSize: 18),
        ),
        Text(
          '💨 Windgeschwindigkeit: ${weatherData.windSpeed.toStringAsFixed(1)} km/h',
          style: const TextStyle(fontSize: 18),
        ),
        Text(
          '💧 Luftfeuchtigkeit: ${weatherData.humidity.toStringAsFixed(1)}%',
          style: const TextStyle(fontSize: 18),
        ),
      ],
    );
  }
}
