import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:weather_app/core/app_strings.dart';
import 'package:weather_app/models/weather_data.dart';

final Logger _logger = Logger('HourlyForecast');

class HourlyForecast extends StatelessWidget {
  const HourlyForecast({super.key, required this.weatherData});

  final WeatherData weatherData;

  @override
  Widget build(BuildContext context) {
    _logger.info('Baue stündliche Vorhersage auf...');
    _logger.info('Anzahl der Stunden: ${weatherData.hourlyTemperature.length}');

    if (weatherData.hourlyTemperature.isEmpty ||
        weatherData.hourlyTimes.isEmpty ||
        weatherData.hourlyRainProbabilities.isEmpty) {
      _logger.warning(AppStrings.noWeatherData);
      return const Center(
        child: Text(
          AppStrings.noWeatherData,
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    // 📌 **Startindex kommt direkt aus den bereits umgerechneten Daten**
    final int startIndex = 0;

    _logger.info('Vorhersage beginnt bei Index: $startIndex');

    return Column(
      children: [
        const Text(
          AppStrings.hourlyForecast,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 24,
            itemBuilder: (context, index) {
              final int actualIndex = startIndex + index;
              if (actualIndex >= weatherData.hourlyTimes.length ||
                  actualIndex >= weatherData.hourlyRainProbabilities.length) {
                _logger.warning(
                  'Index $actualIndex ist außerhalb des gültigen Bereichs für Wetterdaten!',
                );
                return const SizedBox(); // Verhindert Abstürze bei inkonsistenten Daten
              }

              final String timeLabel =
                  (index == 0)
                      ? AppStrings.now
                      : weatherData.hourlyTimes[actualIndex].substring(
                        11,
                        16,
                      ); // HH:mm

              _logger.fine(
                'Erstelle Vorhersage-Widget für $timeLabel: '
                '${weatherData.hourlyTemperature[actualIndex]}°C, '
                '${weatherData.hourlyRainProbabilities[actualIndex]}% Regen',
              );

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
                    Text(
                      '⏰ $timeLabel',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '🌡 ${weatherData.hourlyTemperature[actualIndex].toStringAsFixed(1)}°C',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '🌧 ${weatherData.hourlyRainProbabilities[actualIndex]}%',
                      style: const TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
