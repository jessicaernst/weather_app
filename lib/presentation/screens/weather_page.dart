import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:weather_app/core/app_strings.dart';
import 'package:weather_app/presentation/widgets/error_msg.dart';
import 'package:weather_app/presentation/widgets/weather_page_content.dart';
import 'package:weather_app/providers/weather_notifier.dart';

final Logger _log = Logger('WeatherPage');

class WeatherPage extends ConsumerWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ Wetter-Status aus dem Provider abrufen (AsyncValue<WeatherState>)
    final weatherState = ref.watch(weatherNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appTitle),
        backgroundColor: Colors.blueGrey.withAlpha((0.2 * 255).toInt()),
      ),
      body: Center(
        child: weatherState.when(
          data: (state) => const WeatherPageContent(),
          loading: () => const CircularProgressIndicator(),
          error: (err, _) {
            _log.severe('❌ Fehler beim Laden des Wetters: $err');
            return ErrorMessage(
              errorMessage: AppStrings.error(err),
              onRetry:
                  () =>
                      ref
                          .read(weatherNotifierProvider.notifier)
                          .refreshWeather(),
            );
          },
        ),
      ),
    );
  }
}
