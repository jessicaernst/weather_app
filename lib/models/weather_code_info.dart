import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

/// 📌 Interface für Wetterbeschreibung & Icons
/// - Wird von `WeatherData` implementiert
/// - Enthält Methoden für Wetterbeschreibung und Wetter-Icons
/// - Wird in `CurrentWeatherInfo` verwendet
/// - Wird in `WeatherData` implementiert
/// - Wird in `WeatherCodeInfo` gemischt
/// - Wird in `WeatherNotifier` verwendet
/// - Wird in `WeatherService` verwendet
/// - Wird in `WeatherServiceMock` verwendet
/// - Wird in `WeatherServiceOpenWeather` verwendet
/// - Wird in `WeatherServiceWeatherAPI` verwendet
/// - Die Codes für die Wetterbeschreibung und Icons stammen von der Wetter-API
/// - Die Codes sind in der API-Dokumentation zu finden
/// - Die Codes basieren auf der **WMO-Nummerierung** (World Meteorological Organization)
mixin WeatherCodeInfo {
  int get weatherCode; // 🌤 Wetter-Code aus der API

  /// 📝 **Wettercode in lesbaren Text umwandeln**
  String getWeatherDescription() {
    switch (weatherCode) {
      case 0:
        return 'Klarer Himmel';
      case 1:
        return 'Überwiegend klar';
      case 2:
        return 'Teilweise bewölkt';
      case 3:
        return 'Bedeckt';
      case 45:
      case 48:
        return 'Nebel';
      case 51:
      case 53:
      case 55:
        return 'Nieselregen';
      case 56:
      case 57:
        return 'Gefrierender Nieselregen';
      case 61:
      case 63:
      case 65:
        return 'Regen';
      case 66:
      case 67:
        return 'Gefrierender Regen';
      case 71:
      case 73:
      case 75:
        return 'Schneefall';
      case 77:
        return 'Schneekörner';
      case 80:
      case 81:
      case 82:
        return 'Regenschauer';
      case 85:
      case 86:
        return 'Schneeschauer';
      case 95:
        return 'Gewitter';
      case 96:
      case 99:
        return 'Gewitter mit Hagel';
      default:
        return 'Unbekanntes Wetter';
    }
  }

  /// 🎨 **Passendes Icon für das Wetter zurückgeben**
  IconData getWeatherIcon() {
    switch (weatherCode) {
      case 0:
      case 1:
        return WeatherIcons.day_sunny; // ☀️ Klarer Himmel
      case 2:
      case 3:
        return WeatherIcons.cloud; // ☁️ Bewölkt
      case 45:
      case 48:
        return WeatherIcons.fog; // 🌫 Nebel
      case 51:
      case 53:
      case 55:
        return WeatherIcons.raindrops; // 🌧 Sprühregen
      case 61:
      case 63:
      case 65:
        return WeatherIcons.rain; // ☔ Regen
      case 66:
      case 67:
        return WeatherIcons.sleet; // ❄️ Gefrierender Regen
      case 71:
      case 73:
      case 75:
        return WeatherIcons.snow; // ❄️ Schneefall
      case 80:
      case 81:
      case 82:
        return WeatherIcons.showers; // 🌦 Regenschauer
      case 85:
      case 86:
        return WeatherIcons.snowflake_cold; // ❄️ Schneeschauer
      case 95:
      case 96:
      case 99:
        return WeatherIcons.thunderstorm; // ⚡ Gewitter
      default:
        return WeatherIcons.na; // ❓ Unbekanntes Wetter
    }
  }
}
