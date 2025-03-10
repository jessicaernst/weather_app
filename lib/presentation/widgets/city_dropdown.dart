import 'package:flutter/material.dart';
import 'package:weather_app/providers/weather_provider.dart';

class CityDropdown extends StatelessWidget {
  final String selectedCity;
  final ValueChanged<String?> onCityChanged;

  const CityDropdown({
    super.key,
    required this.selectedCity,
    required this.onCityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value:
          WeatherNotifier.cities.containsKey(selectedCity) ||
                  selectedCity == 'Aktueller Standort'
              ? selectedCity
              : 'Aktueller Standort',
      onChanged: onCityChanged,
      items: [
        const DropdownMenuItem(
          value: 'Aktueller Standort',
          child: Text('Aktueller Standort'),
        ),
        ...WeatherNotifier.cities.keys.map(
          (city) => DropdownMenuItem(value: city, child: Text(city)),
        ),
      ],
    );
  }
}
