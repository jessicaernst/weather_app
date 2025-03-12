import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:weather_app/core/app_strings.dart';
import 'package:weather_app/presentation/widgets/hourly_forecast_card.dart';
import 'package:weather_app/providers/weather_notifier.dart';
import 'dart:math';

// Logger für Debugging und Fehleranalyse
final Logger _logger = Logger('HourlyForecast');

/// 📅 **Stündliche Vorhersage-Komponente**
/// - Holt die Wetterdaten direkt aus dem `WeatherNotifier`.
/// - Zeigt die nächsten 24 Stunden Wettervorhersage an.
class HourlyForecast extends ConsumerWidget {
  const HourlyForecast({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _logger.info('Baue stündliche Vorhersage auf...');

    final weatherState = ref.watch(weatherNotifierProvider);
    _logger.info(
      '📢 UI empfängt Wetter-Update: ${weatherState.value?.weatherData?.hourlyTimes}',
    );

    return weatherState.when(
      // 🔄 Falls Daten noch geladen werden
      loading: () => const Center(child: CircularProgressIndicator()),

      // ❌ Falls ein Fehler aufgetreten ist
      error: (error, stackTrace) {
        _logger.severe('Fehler beim Laden der Wetterdaten: $error');
        return Center(
          child: Text(
            'Fehler: $error',
            style: const TextStyle(color: Colors.red),
          ),
        );
      },

      // ✅ Falls Daten erfolgreich geladen wurden
      data: (state) {
        // 🌦 Falls keine Wetterdaten vorhanden sind, zeige eine Nachricht an
        if (state.weatherData == null) {
          _logger.warning(AppStrings.noWeatherData);
          return const Center(
            child: Text(
              AppStrings.noWeatherData,
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        final weatherData = state.weatherData!;

        // ❗ Falls die Wetterdaten fehlen, zeige eine Warnung an
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

        // 🕰 **Aktuelle Stunde ermitteln**
        // Sicherstellen, dass DateTime.now() in der richtigen Zeitzone ist
        final nowUtc = DateTime.now().toUtc();
        final timezoneOffset = Duration(seconds: weatherData.utcOffsetSeconds);
        final nowLocal = nowUtc.add(timezoneOffset);
        final int currentHour = nowLocal.hour;

        int startIndex = weatherData.hourlyTimes.indexWhere((time) {
          final int hour = int.parse(time.split(':')[0]);
          return hour >= currentHour;
        });

        // Falls kein passender Index gefunden wurde, nimm das erste Element
        if (startIndex == -1) {
          startIndex = 0;
        }

        _logger.info('✅ Berechneter Startindex: $startIndex');

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
                itemCount: min(24, weatherData.hourlyTimes.length - startIndex),
                itemBuilder: (context, index) {
                  final int actualIndex =
                      (startIndex + index) % weatherData.hourlyTimes.length;

                  final String timeLabel =
                      (index == 0)
                          ? AppStrings.now
                          : weatherData.hourlyTimes[actualIndex];

                  return HourlyForeCastCard(
                    weatherData: weatherData,
                    timeLabel: timeLabel,
                    actualIndex: actualIndex,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
