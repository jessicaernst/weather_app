import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:weather_app/core/app_strings.dart';
import 'package:weather_app/presentation/widgets/city_dropdown.dart';
import 'package:weather_app/presentation/widgets/clear_history_btn.dart';
import 'package:weather_app/presentation/widgets/current_weather_info.dart';
import 'package:weather_app/presentation/widgets/hourly_forecast.dart';
import 'package:weather_app/presentation/widgets/refresh_btn.dart';
import 'package:weather_app/presentation/widgets/seven_day_forecast.dart';
import 'package:weather_app/providers/weather_notifier.dart';

final Logger _logger = Logger('WeatherPage');

class WeatherPageContent extends ConsumerWidget {
  const WeatherPageContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ Wetter-Status aus dem Provider abrufen
    final weatherState = ref.watch(weatherNotifierProvider);

    return weatherState.when(
      data: (state) {
        _logger.info('Baue Wetter-UI für ${state.selectedCity} auf...');

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 📌 Dropdown für die Stadtauswahl
              CityDropdown(selectedCity: state.selectedCity),
              const SizedBox(height: 10),

              // 📌 Überschrift mit dem aktuellen Ort
              SizedBox(
                width: double.infinity,
                child: Text(
                  AppStrings.actualWeatherIn(state.selectedCity),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // 📌 Wetterdaten werden angezeigt, wenn sie verfügbar sind
              if (state.weatherData != null) ...[
                CurrentWeatherInfo(weatherData: state.weatherData!),
                const SizedBox(height: 32),
                const HourlyForecast(),
                const SizedBox(height: 32),
                SevenDayForecast(weatherData: state.weatherData!),
                const SizedBox(height: 20),
              ],

              // 🔄 Aktualisieren-Button
              RefreshBtn(
                onPressed: () {
                  _logger.info(
                    AppStrings.updateWeatherForCity(state.selectedCity),
                  );
                  ref.read(weatherNotifierProvider.notifier).refreshWeather();
                },
              ),
              const SizedBox(height: 10),

              // 🗑 Löscht die gespeicherte Wetterhistorie
              ClearHistoryBtn(
                onPressed: () {
                  _logger.warning('Lösche gespeicherte Wetterhistorie...');
                  ref.read(weatherNotifierProvider.notifier).clearHistory();
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Fehler: $error')),
    );
  }
}
