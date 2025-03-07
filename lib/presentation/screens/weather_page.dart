import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:weather_app/core/app_strings.dart';
import 'package:weather_app/providers/weather_provider.dart';

final Logger _log = Logger('WeatherPage');

class WeatherPage extends ConsumerWidget {
  const WeatherPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherState = ref.watch(weatherNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.appTitle)),
      body: Center(
        child: weatherState.when(
          data:
              (data) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppStrings.currentTemperature(data.temperature),
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed:
                        () =>
                            ref
                                .read(weatherNotifierProvider.notifier)
                                .refreshWeather(),
                    child: const Text(AppStrings.updateWeather),
                  ),
                  const SizedBox(height: 10),
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
                const SizedBox(height: 20),
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
