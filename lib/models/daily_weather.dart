import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:weather_app/models/weather_code_info.dart';

// 🚀 Diese beiden `part`-Dateien werden **automatisch** generiert und enthalten zusätzlichen Code:
// - `daily_weather.freezed.dart`: Enthält die Logik für die **Immutable-Datenklasse** (Freezed-Logik).
// - `daily_weather.g.dart`: Enthält die **JSON-Serialisierung** (fromJson & toJson).
part 'daily_weather.freezed.dart';
part 'daily_weather.g.dart';

// 📌 `@freezed` ist eine Annotation von **Freezed** (ein Code-Generator für Immutable-Klassen).
//    - Diese Klasse kann **nicht verändert** werden, nachdem sie einmal erstellt wurde. Stichwort: **Immutable**.
//    - Freezed generiert automatisch Funktionen wie `.copyWith()` oder `.toString()`.
@freezed
abstract class DailyWeather with _$DailyWeather, WeatherCodeInfo {
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
  /// - so kann das Mixin `WeatherCodeInfo` verwendet werden als ob es getter wären
  const DailyWeather._();

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
