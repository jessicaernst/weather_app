import 'package:flutter/material.dart';
import 'package:weather_app/core/app_strings.dart';
import 'package:weather_app/models/weather_data.dart';
import 'package:weather_icons/weather_icons.dart';

class CurrentWeatherInfo extends StatelessWidget {
  const CurrentWeatherInfo({super.key, required this.weatherData});

  final WeatherData weatherData; // Wetterdaten, die von der API kommen

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 🔥 Überschrift für die aktuelle Temperatur
        const Text(
          AppStrings.currentTemperature,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        // 🌡 Anzeige der Temperatur (wenn Kommazahl = 0, dann als Int anzeigen)
        Text(
          '${weatherData.temperature % 1 == 0 ? weatherData.temperature.toInt() : weatherData.temperature.toStringAsFixed(1)} °C',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 16), // Abstand für bessere Lesbarkeit
        // 🌤 Wetterlage (z. B. "Leicht bewölkt" oder "Starkregen")
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8,
          children: [
            Icon(weatherData.getWeatherIcon()),
            Text(
              AppStrings.weatherCondition(weatherData.getWeatherDescription()),
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
        const SizedBox(height: 8), // Abstand für bessere Lesbarkeit
        // 🌬 Windgeschwindigkeit anzeigen (z. B. "10 km/h")
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8,
          children: [
            const Icon(WeatherIcons.windy, size: 24),
            Text(
              AppStrings.windSpeed(weatherData.windSpeed),
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ],
    );
  }
}
