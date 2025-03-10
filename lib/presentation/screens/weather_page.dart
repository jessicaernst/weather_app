import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:weather_app/core/app_strings.dart';
import 'package:weather_app/presentation/widgets/error_msg.dart';
import 'package:weather_app/presentation/widgets/weather_page_content.dart';
import 'package:weather_app/providers/weather_provider.dart';

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
              (state) => WeatherPageContent(
                state: state,
                weatherNotifier: weatherNotifier,
              ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) {
            _log.severe('Fehler beim Laden des Wetters: $err');
            return ErrorMessage(
              errorMessage: '❌ Fehler: $err',
              onRetry: () => weatherNotifier.refreshWeather(),
            );
          },
        ),
      ),
    );
  }
}
