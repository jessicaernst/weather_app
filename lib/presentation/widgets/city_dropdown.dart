import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:weather_app/core/app_strings.dart';
import 'package:weather_app/providers/weather_provider.dart';

final Logger _logger = Logger('CityDropdown');

// 🏙 Dropdown für die Stadtauswahl – ermöglicht das Wechseln zwischen gespeicherten Städten oder dem aktuellen Standort
class CityDropdown extends StatelessWidget {
  const CityDropdown({
    super.key,
    required this.selectedCity,
    required this.weatherNotifier,
  });

  final String selectedCity; // 🌍 Die aktuell ausgewählte Stadt
  final WeatherNotifier
  weatherNotifier; // ⛅ Der Riverpod Notifier, der die Wetterdaten aktualisiert

  @override
  Widget build(BuildContext context) {
    // ✅ Überprüft, ob die Stadt gültig ist, falls nicht -> Standardwert setzen
    final validatedCity = weatherNotifier.validateCityName(selectedCity);

    return DropdownButton<String>(
      value: validatedCity, // 🌍 Der aktuell gesetzte Wert im Dropdown
      onChanged: (newCity) {
        if (newCity != null) {
          if (newCity == AppStrings.currentLocation) {
            // 🌍 Falls "Aktueller Standort" gewählt wird -> Refresh aufrufen
            _logger.info(
              '🌍 Aktualisiere Wetterdaten für aktuellen Standort...',
            );
            weatherNotifier.refreshWeather();
          } else {
            // 📍 Falls eine andere Stadt gewählt wird -> Wetter für diese Stadt laden
            _logger.info('📍 Wechsel zu: $newCity');
            weatherNotifier.updateCity(newCity);
          }
        }
      },
      items: [
        // 📌 "Aktueller Standort" als erste Auswahlmöglichkeit im Dropdown
        const DropdownMenuItem(
          value: AppStrings.currentLocation,
          child: Text(AppStrings.currentLocation),
        ),

        // 📌 Alle Städte aus `WeatherNotifier.cities` dynamisch als Dropdown-Optionen hinzufügen
        ...WeatherNotifier.cities.keys.map(
          (city) => DropdownMenuItem(value: city, child: Text(city)),
        ),
      ],
    );
  }
}
