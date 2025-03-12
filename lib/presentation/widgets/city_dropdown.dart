import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:weather_app/core/app_strings.dart';
import 'package:weather_app/providers/weather_notifier.dart';

final Logger _logger = Logger('CityDropdown');

class CityDropdown extends ConsumerWidget {
  const CityDropdown({super.key, required this.selectedCity});

  final String selectedCity; // 🌍 Die aktuell ausgewählte Stadt

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ Wetter-Notifier abrufen
    final weatherNotifier = ref.read(weatherNotifierProvider.notifier);
    final cities = WeatherNotifier.cities; // ✅ Städte aus Notifier abrufen
    final validatedCity = weatherNotifier.validateCityName(
      selectedCity,
    ); // ✅ Stadt validieren

    return DropdownButton<String>(
      value: validatedCity, // 🌍 Der aktuell gesetzte Wert im Dropdown
      onChanged: (newCity) {
        if (newCity != null) {
          if (newCity == AppStrings.currentLocation) {
            _logger.info(
              '🌍 Aktualisiere Wetterdaten für aktuellen Standort...',
            );
            weatherNotifier.refreshWeather();
          } else {
            _logger.info('📍 Wechsel zu: $newCity');
            final (lat, lon) = cities[newCity]!;
            weatherNotifier.updateCity(newCity, lat, lon);
          }
        }
      },
      items: [
        const DropdownMenuItem(
          value: AppStrings.currentLocation,
          child: Text(AppStrings.currentLocation),
        ),
        ...cities.keys.map(
          (city) => DropdownMenuItem(value: city, child: Text(city)),
        ),
      ],
    );
  }
}
