import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:weather_app/models/weather_state.dart';
import 'package:weather_app/presentation/widgets/city_dropdown.dart';
import 'package:weather_app/presentation/widgets/clear_history_btn.dart';
import 'package:weather_app/presentation/widgets/current_weather_info.dart';
import 'package:weather_app/presentation/widgets/hourly_forecast.dart';
import 'package:weather_app/presentation/widgets/refresh_btn.dart';
import 'package:weather_app/presentation/widgets/seven_day_forecast.dart';
import 'package:weather_app/providers/weather_provider.dart';

final Logger _logger = Logger('WeatherPage');

class WeatherPageContent extends StatelessWidget {
  const WeatherPageContent({
    super.key,
    required this.state,
    required this.weatherNotifier,
  });

  final WeatherState state;
  final WeatherNotifier weatherNotifier;

  @override
  Widget build(BuildContext context) {
    _logger.info('Baue Wetter-UI für ${state.selectedCity} auf...');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Wetter in ${state.selectedCity}',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          CityDropdown(
            selectedCity: state.selectedCity,
            onCityChanged: (newCity) {
              if (newCity != null) {
                _logger.info('Wechsle Stadt zu: $newCity');
                weatherNotifier.updateCity(newCity);
              }
            },
          ),
          const SizedBox(height: 20),
          if (state.weatherData != null) ...[
            CurrentWeatherInfo(weatherData: state.weatherData!),
            const SizedBox(height: 20),
            HourlyForecast(weatherData: state.weatherData!),
            const SizedBox(height: 20),
            const SevenDayForecast(),
            const SizedBox(height: 20),
          ],
          RefreshBtn(
            onPressed: () {
              _logger.info(
                'Aktualisiere Wetterdaten für ${state.selectedCity}...',
              );
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
        ],
      ),
    );
  }
}
