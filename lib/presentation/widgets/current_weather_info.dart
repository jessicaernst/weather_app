import 'package:flutter/material.dart';
import 'package:weather_app/core/app_strings.dart';
import 'package:weather_app/models/weather_data.dart';

class CurrentWeatherInfo extends StatelessWidget {
  const CurrentWeatherInfo({super.key, required this.weatherData});

  final WeatherData weatherData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          AppStrings.currentTemperature(weatherData.temperature),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(
          AppStrings.weatherCondition(weatherData.weatherCondition),
          style: const TextStyle(fontSize: 18),
        ),
        Text(
          AppStrings.windSpeed(weatherData.windSpeed),
          style: const TextStyle(fontSize: 18),
        ),
        Text(
          AppStrings.humidity(weatherData.humidity),
          style: const TextStyle(fontSize: 18),
        ),
      ],
    );
  }
}
