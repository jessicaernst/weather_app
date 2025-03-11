import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:weather_app/models/daily_weather.dart';

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
    required String
    weatherCondition, // 🌤 Beschreibung des aktuellen Wetters ("Bewölkt", "Sonnig", etc.)
    required double windSpeed, // 💨 Windgeschwindigkeit in km/h
    required double humidity, // 💦 Luftfeuchtigkeit in %
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
