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
    required this.state,
    required this.weatherNotifier,
  });

  final WeatherState state;
  final WeatherNotifier weatherNotifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _logger.info('Baue Wetter-UI für ${state.selectedCity} auf...');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CityDropdown(
            selectedCity: state.selectedCity,
            weatherNotifier: weatherNotifier,
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: Text(
              AppStrings.actualWeatherIn(state.selectedCity),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 32),
          if (state.weatherData != null) ...[
            CurrentWeatherInfo(weatherData: state.weatherData!),
            const SizedBox(height: 32),
            HourlyForecast(weatherData: state.weatherData!),
            const SizedBox(height: 32),
            SevenDayForecast(weatherData: state.weatherData!),
            const SizedBox(height: 20),
          ],
          RefreshBtn(
            onPressed: () {
              _logger.info(AppStrings.updateWeatherForCity(state.selectedCity));
              weatherNotifier.refreshWeather();
            },
          ),
          const SizedBox(height: 10),
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
