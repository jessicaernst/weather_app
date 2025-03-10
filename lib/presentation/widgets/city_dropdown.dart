import 'package:flutter/material.dart';
import 'package:weather_app/core/app_strings.dart';
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
                  selectedCity == AppStrings.currentLocation
              ? selectedCity
              : AppStrings.currentLocation,
      onChanged: onCityChanged,
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
