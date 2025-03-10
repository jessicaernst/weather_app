import 'package:flutter/material.dart';
import 'package:weather_app/models/weather_data.dart';

class SevenDayForecast extends StatelessWidget {
  const SevenDayForecast({super.key, required this.weatherData});

  final WeatherData weatherData;

  // Methode zur Bestimmung des passenden Icons basierend auf dem Wettercode der API
  IconData _getWeatherIcon(int weatherCode) {
    if (weatherCode >= 0 && weatherCode <= 3) {
      return Icons.wb_sunny; // Klar bis leicht bewölkt
    } else if (weatherCode >= 45 && weatherCode <= 48) {
      return Icons.foggy; // Neblig
    } else if (weatherCode >= 51 && weatherCode <= 67) {
      return Icons.grain; // Nieselregen oder gefrierender Regen
    } else if (weatherCode >= 71 && weatherCode <= 77) {
      return Icons.ac_unit; // Schnee oder Graupel
    } else if (weatherCode >= 80 && weatherCode <= 99) {
      return Icons.thunderstorm; // Starke Regenfälle, Gewitter
    } else {
      return Icons.cloud; // Standard: Bewölkt
    }
  }

  @override
  Widget build(BuildContext context) {
    // Falls keine Wetterdaten verfügbar sind, leere Liste anzeigen
    if (weatherData.dailyWeather.isEmpty) {
      return const Center(child: Text('Keine Vorhersagedaten verfügbar'));
    }

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
          itemCount: weatherData.dailyWeather.length,
          itemBuilder: (context, index) {
            final dailyForecast = weatherData.dailyWeather[index];

            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: ListTile(
                leading: Icon(_getWeatherIcon(dailyForecast.weatherCode)),
                title: Text('Tag ${index + 1}'),
                subtitle: Text(
                  '🌡 ${dailyForecast.minTemp.round()}-${dailyForecast.maxTemp.round()}°C '
                  '| 🌧 ${dailyForecast.precipitationProbability.round()}% Regen',
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
