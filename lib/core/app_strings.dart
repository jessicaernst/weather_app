class AppStrings {
  static const String appTitle = 'Weather App';

  static String currentTemperature(double temp) {
    return 'Aktuelle Temperatur: ${temp % 1 == 0 ? temp.toInt() : temp.toStringAsFixed(1)}°C';
  }

  static const String updateWeather = 'Wetter aktualisieren';
}
