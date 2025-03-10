import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:weather_app/core/app_strings.dart';
import 'package:weather_app/providers/weather_provider.dart';

final Logger _logger = Logger('CityDropdown');

class CityDropdown extends StatelessWidget {
  final String selectedCity;
  final WeatherNotifier weatherNotifier;

  const CityDropdown({
    super.key,
    required this.selectedCity,
    required this.weatherNotifier,
  });

  @override
  Widget build(BuildContext context) {
    final validatedCity = weatherNotifier.validateCityName(selectedCity);

    return DropdownButton<String>(
      value: validatedCity,
      onChanged: (newCity) {
        if (newCity != null) {
          if (newCity == AppStrings.currentLocation) {
            // 🌍 Falls "Aktueller Standort" gewählt wird -> Refresh aufrufen
            _logger.info(
              '🌍 Aktualisiere Wetterdaten für aktuellen Standort...',
            );
            weatherNotifier.refreshWeather();
          } else {
            _logger.info('📍 Wechsel zu: $newCity');
            weatherNotifier.updateCity(newCity);
          }
        }
      },
      items: [
        const DropdownMenuItem(
          value: AppStrings.currentLocation,
          child: Text(AppStrings.currentLocation),
        ),
        ...WeatherNotifier.cities.keys.map(
          (city) => DropdownMenuItem(value: city, child: Text(city)),
        ),
      ],
    );
  }
}
