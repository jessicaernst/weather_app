abstract class AppStrings {
  static const String appTitle = 'Wetter App';

  // 🌡 Aktuelle Wetterdaten
  static const String currentTemperature = '🌡 Aktuelle Temperatur:';

  static String weatherCondition(String condition) {
    return '🌤 Wetterlage: $condition';
  }

  static String windSpeed(double speed) {
    return '💨 Windgeschwindigkeit: ${speed.toStringAsFixed(1)} km/h';
  }

  static String humidity(double humidity) {
    return '💧 Luftfeuchtigkeit: ${humidity.toStringAsFixed(1)}%';
  }

  // 📍 Standort & Wetteraktualisierung
  static String actualWeatherIn(String city) {
    return 'Wetter in $city:';
  }

  static String updateWeatherForCity(String city) {
    return 'Aktualisiere Wetterdaten für $city...';
  }

  static const String updateWeather = '🔄 Wetter aktualisieren';
  static const String currentLocation = '📍 Aktueller Standort';
  static const String hourlyForecast = '⏳ Stündliche Vorhersage';

  // 🛠 Fehler & Aktionen
  static String error(Object message) {
    return '❌ Fehler: $message';
  }

  static const String noWeatherData =
      '⚠️ Keine stündlichen Wetterdaten verfügbar.';

  static const String clearHistoryBtnLbl = '🗑️ Historie löschen';
  static const String refreshBtnLbl = '🔄 Wetter aktualisieren';
  static const String refreshWeatherBtnLbl = '🔄 Wetter erneut abrufen';
}
