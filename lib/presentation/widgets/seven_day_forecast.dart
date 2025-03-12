import 'package:flutter/material.dart';
import 'package:weather_app/models/weather_data.dart';
import 'package:weather_icons/weather_icons.dart';

class SevenDayForecast extends StatelessWidget {
  const SevenDayForecast({super.key, required this.weatherData});

  final WeatherData
  weatherData; // 🌍 Enthält die Wetterdaten für die tägliche Vorhersage

  @override
  Widget build(BuildContext context) {
    // ❌ Falls keine Wetterdaten vorhanden sind, zeige eine leere Nachricht an
    if (weatherData.dailyWeather.isEmpty) {
      return const Center(child: Text('Keine Vorhersagedaten verfügbar'));
    }

    return Column(
      children: [
        // 📌 Überschrift für die 7-Tage-Vorhersage
        const Text(
          '📅 7-Tage-Vorhersage',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        // 📌 Wetterkarten für jeden der nächsten 7 Tage anzeigen
        ListView.builder(
          shrinkWrap: true, // 🚀 Kein unnötiger Platzverbrauch
          physics:
              const NeverScrollableScrollPhysics(), // 🔒 Verhindert Scrollen, wenn in einer Column
          itemCount:
              weatherData
                  .dailyWeather
                  .length, // 🗓 Anzahl der Tage aus den API-Daten holen
          itemBuilder: (context, index) {
            final dailyForecast =
                weatherData
                    .dailyWeather[index]; // ⛅ Wetterdaten für den aktuellen Tag holen

            return Card(
              elevation: 2, // 📌 Kleine Schatten für bessere Sichtbarkeit
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: ListTile(
                leading: Icon(
                  dailyForecast
                      .getWeatherIcon(), // 🌦 Passendes Icon je nach Wetterlage
                ), // 🌦 Passendes Icon je nach Wetterlage
                title: Text(
                  'Tag ${index + 1}',
                ), // 📅 Zeigt den aktuellen Tag an
                subtitle: Row(
                  children: [
                    const Icon(
                      WeatherIcons.thermometer, // 🌡 Temperatur-Icon
                      size: 16,
                    ),
                    const SizedBox(width: 8), // 🛠 Abstand für bessere Optik
                    Text(
                      '${dailyForecast.minTemp.round()}-${dailyForecast.maxTemp.round()}°C ',
                    ),
                    const SizedBox(
                      width: 16,
                    ), // 🛠 Mehr Abstand zwischen den Elementen
                    const Icon(
                      WeatherIcons.rain, // 🌧 Regen-Icon
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${dailyForecast.precipitationProbability.round()}% Regen',
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
