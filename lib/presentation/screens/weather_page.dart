import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:weather_app/core/app_strings.dart';
import 'package:weather_app/providers/weather_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final Logger _log = Logger('WeatherPage');

class WeatherPage extends ConsumerWidget {
  const WeatherPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherState = ref.watch(weatherNotifierProvider);
    final weatherNotifier = ref.read(weatherNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.appTitle)),
      body: Center(
        child: weatherState.when(
          data:
              (state) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 20,
                children: [
                  // Standort anzeigen
                  Text(
                    "Wetter in ${state.weatherData?.location ?? 'Unbekannt'}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Dropdown-Menü für Stadtwahl & aktuellen Standort
                  DropdownButton<String>(
                    value: state.selectedCity,
                    onChanged: (String? newCity) {
                      if (newCity != null) {
                        weatherNotifier.updateCity(newCity);
                      }
                    },
                    items: [
                      const DropdownMenuItem(
                        value: 'Aktueller Standort',
                        child: Text('Aktueller Standort'),
                      ),
                      ...WeatherNotifier.cities.keys.map(
                        (city) =>
                            DropdownMenuItem(value: city, child: Text(city)),
                      ),
                    ],
                  ),

                  state.weatherData != null
                      ? Column(
                        spacing: 32,
                        children: [
                          Text(
                            AppStrings.currentTemperature(
                              state.weatherData!.temperature,
                            ),
                            style: const TextStyle(fontSize: 24),
                          ),

                          ElevatedButton(
                            onPressed:
                                () =>
                                    ref
                                        .read(weatherNotifierProvider.notifier)
                                        .refreshWeather(),
                            child: const Text(AppStrings.updateWeather),
                          ),
                        ],
                      )
                      : Column(
                        spacing: 32,
                        children: [
                          const Text(
                            'Keine Wetterdaten verfügbar. Bitte aktualisieren.',
                            style: TextStyle(color: Colors.grey),
                          ),
                          ElevatedButton(
                            onPressed:
                                () =>
                                    ref
                                        .read(weatherNotifierProvider.notifier)
                                        .refreshWeather(),
                            child: const Text('Wetter abrufen'),
                          ),
                        ],
                      ),

                  // 🗑️ Historie löschen Button
                  ElevatedButton(
                    onPressed:
                        () =>
                            ref
                                .read(weatherNotifierProvider.notifier)
                                .clearHistory(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Historie löschen'),
                  ),
                ],
              ),
          loading: () => const CircularProgressIndicator(),
          error: (err, _) {
            _log.severe('Fehler beim Laden des Wetters: $err');
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Fehler: $err', style: const TextStyle(color: Colors.red)),
                ElevatedButton(
                  onPressed:
                      () =>
                          ref
                              .read(weatherNotifierProvider.notifier)
                              .refreshWeather(),
                  child: const Text(AppStrings.updateWeather),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
