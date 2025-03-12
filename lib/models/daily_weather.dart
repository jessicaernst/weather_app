import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:weather_icons/weather_icons.dart';

// 🚀 Diese beiden `part`-Dateien werden **automatisch** generiert und enthalten zusätzlichen Code:
// - `daily_weather.freezed.dart`: Enthält die Logik für die **Immutable-Datenklasse** (Freezed-Logik).
// - `daily_weather.g.dart`: Enthält die **JSON-Serialisierung** (fromJson & toJson).
part 'daily_weather.freezed.dart';
part 'daily_weather.g.dart';

// 📌 `@freezed` ist eine Annotation von **Freezed** (ein Code-Generator für Immutable-Klassen).
//    - Diese Klasse kann **nicht verändert** werden, nachdem sie einmal erstellt wurde. Stichwort: **Immutable**.
//    - Freezed generiert automatisch Funktionen wie `.copyWith()` oder `.toString()`.
@freezed
abstract class DailyWeather with _$DailyWeather {
  /// 🚀 Die `factory DailyWeather` Methode erzeugt eine **neue Instanz** der `DailyWeather` Klasse.
  /// - Alle Parameter sind `required`, d.h., sie **müssen** angegeben werden.
  /// - Diese Werte kommen aus der Wetter-API und werden gespeichert.
  const factory DailyWeather({
    required DateTime
    date, // 📅 Das Datum des jeweiligen Tages (z.B. 2025-03-12)
    required double minTemp, // 🌡 Die **Minimaltemperatur** des Tages (°C)
    required double maxTemp, // 🔥 Die **Maximaltemperatur** des Tages (°C)
    required double
    precipitationProbability, // 🌧 Die Regenwahrscheinlichkeit (%)
    required int
    weatherCode, // 🌤 Wetter-Code für das Wetter-Icon (z.B. 3 = bewölkt)
  }) = _DailyWeather;

  /// - Dadurch kann Freezed zusätzliche Methoden für diese Klasse generieren.
  const DailyWeather._();

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

  /// 🔄 Diese Factory-Methode ermöglicht es, die `DailyWeather` Klasse aus einem JSON-Objekt zu erstellen.
  /// - Sie wird verwendet, wenn die Wetterdaten **von der API geladen** werden.
  /// - **Beispiel**:
  ///   ```dart
  ///   final wetterJson = {"date": "2025-03-12", "minTemp": 10.2, "maxTemp": 18.5, "precipitationProbability": 30, "weatherCode": 3};
  ///   final wetter = DailyWeather.fromJson(wetterJson);
  ///   ```
  factory DailyWeather.fromJson(Map<String, dynamic> json) =>
      _$DailyWeatherFromJson(json);
}
