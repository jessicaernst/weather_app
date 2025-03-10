import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:weather_app/core/app_strings.dart';
import 'package:weather_app/models/weather_state.dart';
import 'package:weather_app/presentation/widgets/city_dropdown.dart';
import 'package:weather_app/presentation/widgets/clear_history_btn.dart';
import 'package:weather_app/presentation/widgets/current_weather_info.dart';
import 'package:weather_app/presentation/widgets/hourly_forecast.dart';
import 'package:weather_app/presentation/widgets/refresh_btn.dart';
import 'package:weather_app/presentation/widgets/seven_day_forecast.dart';
import 'package:weather_app/providers/weather_provider.dart';

final Logger _logger = Logger('WeatherPage');

class WeatherPageContent extends ConsumerWidget {
  const WeatherPageContent({
    super.key,
    required this.state, // 🌍 Enthält den aktuellen Zustand (Wetterdaten, Stadt etc.)
    required this.weatherNotifier, // 🔄 Steuert das Laden und Aktualisieren der Wetterdaten
  });

  final WeatherState state; // 🌤 Der aktuelle Zustand der Wetterseite
  final WeatherNotifier weatherNotifier; // 📡 Steuert das Wetter-Update

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _logger.info('Baue Wetter-UI für ${state.selectedCity} auf...');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16), // 📏 Abstand für eine bessere Optik
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // 🔄 Zentriert den Inhalt
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          // 📌 Dropdown für die Stadtauswahl
          CityDropdown(
            selectedCity: state.selectedCity,
            weatherNotifier: weatherNotifier,
          ),
          const SizedBox(
            height: 10,
          ), // 📏 Kleiner Abstand für bessere Lesbarkeit
          // 📌 Überschrift mit dem aktuellen Ort
          SizedBox(
            width: double.infinity, // 📏 Volle Breite für bessere Darstellung
            child: Text(
              AppStrings.actualWeatherIn(state.selectedCity),
              textAlign: TextAlign.center, // 📌 Mittige Ausrichtung
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(
            height: 32,
          ), // 📏 Mehr Abstand, um Sektionen zu trennen
          // 📌 Wetterdaten werden angezeigt, wenn sie verfügbar sind
          if (state.weatherData != null) ...[
            // 🌡 Zeigt die aktuellen Wetterinfos an (Temperatur, Wind, Luftfeuchtigkeit)
            CurrentWeatherInfo(weatherData: state.weatherData!),
            const SizedBox(height: 32),

            // ⏰ Zeigt die stündliche Vorhersage an
            HourlyForecast(weatherData: state.weatherData!),
            const SizedBox(height: 32),

            // 📅 Zeigt die 7-Tage-Wettervorhersage
            SevenDayForecast(weatherData: state.weatherData!),
            const SizedBox(height: 20),
          ],

          // 🔄 Aktualisieren-Button (Lädt aktuelle Wetterdaten neu)
          RefreshBtn(
            onPressed: () {
              _logger.info(AppStrings.updateWeatherForCity(state.selectedCity));
              weatherNotifier.refreshWeather();
            },
          ),
          const SizedBox(height: 10),

          // 🗑 Löscht die gespeicherte Wetterhistorie
          ClearHistoryBtn(
            onPressed: () {
              _logger.warning('Lösche gespeicherte Wetterhistorie...');
              weatherNotifier.clearHistory();
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
