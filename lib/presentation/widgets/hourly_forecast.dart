import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:weather_app/models/weather_data.dart';

final Logger _logger = Logger('HourlyForecast');

class HourlyForecast extends StatelessWidget {
  final WeatherData weatherData;

  const HourlyForecast({super.key, required this.weatherData});

  @override
  Widget build(BuildContext context) {
    // 📌 Logging der Anzahl der Einträge, um sicherzustellen, dass Daten vorhanden sind
    _logger.info('Baue stündliche Vorhersage auf...');
    _logger.info('Anzahl der Stunden: ${weatherData.hourlyTemperature.length}');

    // Falls keine Daten vorhanden sind, logge eine Warnung
    if (weatherData.hourlyTemperature.isEmpty ||
        weatherData.hourlyTimes.isEmpty ||
        weatherData.hourlyRainProbabilities.isEmpty) {
      _logger.warning('Keine stündlichen Wetterdaten verfügbar!');
      return const Center(
        child: Text(
          'Keine stündlichen Wetterdaten verfügbar.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return Column(
      children: [
        const Text(
          '⏳ Stündliche Vorhersage',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: weatherData.hourlyTemperature.length,
            itemBuilder: (context, index) {
              // Sicherstellen, dass die Indexwerte nicht außerhalb der Listen liegen
              if (index >= weatherData.hourlyTimes.length ||
                  index >= weatherData.hourlyRainProbabilities.length) {
                _logger.warning(
                  'Index $index ist außerhalb des gültigen Bereichs für Wetterdaten!',
                );
                return const SizedBox(); // Verhindert Abstürze bei inkonsistenten Daten
              }

              _logger.fine(
                'Erstelle Vorhersage-Widget für ${weatherData.hourlyTimes[index]}: '
                '${weatherData.hourlyTemperature[index]}°C, '
                '${weatherData.hourlyRainProbabilities[index]}% Regen',
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
                      '⏰ ${weatherData.hourlyTimes[index].substring(11, 16)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '🌡 ${weatherData.hourlyTemperature[index].toStringAsFixed(1)}°C',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '🌧 ${weatherData.hourlyRainProbabilities[index]}%',
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
