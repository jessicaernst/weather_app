import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:weather_app/core/app_strings.dart';
import 'package:weather_app/models/weather_data.dart';
import 'package:weather_icons/weather_icons.dart';

// Logger für Debugging und Fehleranalyse
final Logger _logger = Logger('HourlyForecast');

class HourlyForecast extends StatelessWidget {
  const HourlyForecast({super.key, required this.weatherData});

  final WeatherData weatherData; // Wetterdaten, die vom Provider kommen

  @override
  Widget build(BuildContext context) {
    _logger.info('Baue stündliche Vorhersage auf...');
    _logger.info('Anzahl der Stunden: ${weatherData.hourlyTemperature.length}');

    // 🔥 Falls keine Wetterdaten vorhanden sind, zeige eine Fehlermeldung an
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

    // 🕰 Startindex der Vorhersage (könnte dynamisch sein, aktuell statisch auf 0 gesetzt)
    final int startIndex = 0;

    _logger.info('Vorhersage beginnt bei Index: $startIndex');

    return Column(
      children: [
        // Überschrift für den Bereich "Stündliche Vorhersage"
        const Text(
          AppStrings.hourlyForecast,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 100, // Höhe der ListView für die Vorhersage
          child: ListView.builder(
            scrollDirection: Axis.horizontal, // Horizontal scrollbare Liste
            itemCount:
                24, // Anzahl der angezeigten Stunden (hier fest auf 24 gesetzt)
            itemBuilder: (context, index) {
              final int actualIndex = startIndex + index;

              // ❗ Falls der Index außerhalb des gültigen Bereichs liegt, nichts rendern
              if (actualIndex >= weatherData.hourlyTimes.length ||
                  actualIndex >= weatherData.hourlyRainProbabilities.length) {
                _logger.warning(
                  'Index $actualIndex ist außerhalb des gültigen Bereichs für Wetterdaten!',
                );
                return const SizedBox(); // Verhindert Abstürze bei fehlerhaften Daten
              }

              // 🕒 Die Uhrzeit für die Vorhersage-Zelle
              final String timeLabel =
                  (index == 0)
                      ? AppStrings
                          .now // Falls es die erste Zelle ist, wird "Jetzt" angezeigt
                      : weatherData.hourlyTimes[actualIndex].substring(
                        11, // Schneide das Datum weg → nur die Uhrzeit bleibt
                        16, // Format: HH:mm
                      );

              _logger.fine(
                'Erstelle Vorhersage-Widget für $timeLabel: '
                '${weatherData.hourlyTemperature[actualIndex]}°C, '
                '${weatherData.hourlyRainProbabilities[actualIndex]}% Regen',
              );

              return Container(
                width: 100, // Breite einer Vorhersage-Box
                margin: const EdgeInsets.symmetric(
                  horizontal: 5,
                ), // Abstand zwischen den Boxen
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blueGrey.withAlpha((0.2 * 255).toInt()),
                  borderRadius: BorderRadius.circular(10), // Abgerundete Ecken
                ),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Elemente zentrieren
                  children: [
                    // 🕰 Uhrzeit anzeigen (z. B. "Jetzt" oder "18:00")
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 10,
                      children: [
                        Icon(weatherData.getWeatherIcon(), size: 16),
                        Text(
                          timeLabel,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // 🌡 Temperatur anzeigen (mit einer Nachkommastelle)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 10,
                      children: [
                        const Icon(WeatherIcons.thermometer, size: 16),
                        Text(
                          '${weatherData.hourlyTemperature[actualIndex].toStringAsFixed(1)}°C',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),

                    // 🌧 Regenwahrscheinlichkeit anzeigen
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 10,
                      children: [
                        const Icon(WeatherIcons.rain, size: 16),
                        Text(
                          '${weatherData.hourlyRainProbabilities[actualIndex]}%',
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ],
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
