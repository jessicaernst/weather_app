import 'package:flutter/material.dart';
import 'package:weather_app/models/weather_data.dart';
import 'package:weather_icons/weather_icons.dart';

class HourlyForeCastCard extends StatelessWidget {
  const HourlyForeCastCard({
    super.key,
    required this.weatherData,
    required this.timeLabel,
    required this.actualIndex,
  });

  final WeatherData weatherData;
  final String timeLabel;
  final int actualIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blueGrey.withAlpha((0.2 * 255).toInt()),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(weatherData.getWeatherIcon(), size: 16),
              const SizedBox(width: 5),
              Text(
                timeLabel,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(WeatherIcons.thermometer, size: 16),
              const SizedBox(width: 5),
              Text(
                '${weatherData.hourlyTemperature[actualIndex].toStringAsFixed(1)}°C',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(WeatherIcons.rain, size: 16),
              const SizedBox(width: 5),
              Text(
                '${weatherData.hourlyRainProbabilities[actualIndex]}%',
                style: const TextStyle(color: Colors.blue),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
