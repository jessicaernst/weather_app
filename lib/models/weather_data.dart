import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:weather_app/models/daily_weather.dart';
import 'package:weather_icons/weather_icons.dart';

// 🚀 Diese `part`-Dateien werden **automatisch generiert** und enthalten wichtigen Code:
// - `weather_data.freezed.dart`: Enthält die Logik für die **Immutable-Datenklasse** (Freezed-Logik).
// - `weather_data.g.dart`: Enthält die **JSON-Serialisierung** (fromJson & toJson).
part 'weather_data.freezed.dart';
part 'weather_data.g.dart';

// 📌 `@freezed` ist eine Annotation von **Freezed** (ein Code-Generator für Immutable-Klassen).
//    - Diese Klasse kann **nach der Erstellung nicht mehr verändert** werden.
//    - Freezed generiert automatisch Funktionen wie `.copyWith()`, `.toString()`, usw.
@freezed
abstract class WeatherData with _$WeatherData {
  /// 🚀 Die `factory WeatherData` Methode erzeugt eine **neue Instanz** der `WeatherData` Klasse.
  /// - Alle Parameter sind `required`, d.h., sie **müssen** angegeben werden.
  /// - Diese Werte kommen aus der Wetter-API und werden hier gespeichert.
  const factory WeatherData({
    required String
    location, // 📍 Name des Standorts (z.B. "Berlin, Deutschland")
    required double temperature, // 🌡 Aktuelle Temperatur in °C
    required int
    weatherCode, // 🌤 Wetter-Code für das Wetter-Icon (z.B. 3 = bewölkt)
    required double windSpeed, // 💨 Windgeschwindigkeit in km/h
    // 📌 Stündliche Vorhersagewerte (für die nächsten 24 Stunden)
    required List<double>
    hourlyTemperature, // 🌡 Temperaturen pro Stunde (Liste von °C-Werten)
    required List<double>
    hourlyRainProbabilities, // 🌧 Regenwahrscheinlichkeit pro Stunde (%)
    required List<String>
    hourlyTimes, // ⏰ Zeitpunkte für die stündlichen Werte (z.B. ["10:00", "11:00", ...])

    required String
    timezone, // 🌍 Zeitzone des Standorts (z.B. "Europe/Berlin")
    // 🔥 7-Tage-Vorhersage (Liste von DailyWeather-Objekten, siehe `daily_weather.dart`)
    required List<DailyWeather> dailyWeather,
  }) = _WeatherData;

  /// ❗ **Private Konstruktor hinzufügen (WICHTIG für Freezed!)**
  /// - Dadurch kann Freezed zusätzliche Methoden für diese Klasse generieren.
  const WeatherData._();

  /// 📝 **Wettercode in lesbaren Text umwandeln**
  /// - Diese Methode gibt basierend auf `weatherCode` eine lesbare Beschreibung zurück.
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
        return 'Sprühregen';
      case 56:
      case 57:
        return 'Gefrierender Sprühregen';
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

  /// 🔄 Diese Factory-Methode ermöglicht es, `WeatherData` aus einem JSON-Objekt zu erstellen.
  /// - Sie wird verwendet, wenn die Wetterdaten **von der API geladen** werden.
  /// - **Beispiel**:
  ///   ```dart
  ///   final wetterJson = {
  ///     "location": "Berlin",
  ///     "temperature": 18.5,
  ///     "weatherCondition": "Sonnig",
  ///     "windSpeed": 12.0,
  ///     "humidity": 55.0,
  ///     "hourlyTemperature": [18.5, 19.0, 20.2],
  ///     "hourlyRainProbabilities": [10, 5, 0],
  ///     "hourlyTimes": ["10:00", "11:00", "12:00"],
  ///     "timezone": "Europe/Berlin",
  ///     "dailyWeather": [...] // 7-Tage-Vorhersage-Daten
  ///   };
  ///
  ///   final wetter = WeatherData.fromJson(wetterJson);
  ///   ```
  factory WeatherData.fromJson(Map<String, dynamic> json) =>
      _$WeatherDataFromJson(json);
}
