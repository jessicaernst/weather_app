import 'package:weather_app/models/weather_data.dart';
import 'package:weather_app/models/daily_weather.dart';

/// 🏗 **WeatherService** – Diese Klasse verarbeitet die API-Daten.
/// - Wandelt die erhaltenen JSON-Daten aus der Wetter-API in ein nutzbares Dart-Objekt (`WeatherData`) um.
/// - Enthält Methoden zur Extraktion und Formatierung von Wetterinformationen.
class WeatherService {
  /// 🌍 **Konvertiert JSON-Daten in ein `WeatherData`-Objekt.**
  /// - Diese Methode nimmt die **rohen JSON-Daten** der API und macht sie für die UI nutzbar.
  /// - Die Wetterdaten werden für den angegebenen **Standortnamen (`locationName`)** aufbereitet.
  WeatherData parseWeatherData(
    Map<String, dynamic> jsonData, // 🌍 Rohdaten von der API (als JSON-Map)
    String
    locationName, // 📍 Name des Standorts (z. B. "Berlin" oder "Aktueller Standort")
  ) {
    // 📌 Extrahiert verschiedene Wetterdaten aus der API-Antwort:
    // - `current_weather`: Enthält aktuelle Wetterinformationen wie Temperatur und Windgeschwindigkeit.
    // - `hourly`: Enthält stündliche Vorhersagen (z. B. Temperatur, Regenwahrscheinlichkeit).
    // - `daily`: Enthält tägliche Vorhersagen (z. B. Min-/Max-Temperatur, Wettercodes).
    final weatherData = jsonData['current_weather'] ?? {};
    final hourlyData = jsonData['hourly'] ?? {};
    final dailyData = jsonData['daily'] ?? {};

    // 🕒 **Stündliche Vorhersage** – Hier wird die Liste der Temperaturen pro Stunde extrahiert.
    // - Falls die API keine Werte liefert, wird eine **leere Liste** zurückgegeben.
    final List<double> hourlyTemps = List<double>.from(
      (hourlyData['temperature_2m'] ?? []).map(
        (temp) =>
            (temp as num)
                .toDouble(), // 🔄 Sicherstellen, dass alle Werte vom Typ `double` sind.
      ),
    );

    // 🌧 **Stündliche Regenwahrscheinlichkeit** – Enthält die Regenwahrscheinlichkeit (%) für jede Stunde.
    final List<double> hourlyRain = List<double>.from(
      (hourlyData['precipitation_probability'] ?? []).map(
        (prob) => (prob as num).toDouble(),
      ),
    );

    // 📅 **7-Tage-Vorhersage (Tägliche Werte)**
    // - Erstellt eine **Liste von DailyWeather-Objekten**, die die Wettervorhersage für die nächsten 7 Tage enthalten.
    final List<DailyWeather> dailyForecast = List.generate(
      // ❓ Falls `dailyData['time']` existiert, nutzen wir deren Länge für die Anzahl der Tage.
      // - Falls nicht, setzen wir die Länge auf `0`, um Abstürze zu vermeiden.
      (dailyData['time'] as List<dynamic>?)?.length ?? 0,

      // 🔄 Für jeden Tag in der API-Antwort wird ein **DailyWeather-Objekt** erstellt.
      (index) => DailyWeather(
        // 📅 Das Datum des jeweiligen Tages aus der API holen und in ein `DateTime`-Objekt umwandeln.
        date: DateTime.parse(dailyData['time'][index] as String),

        // 🌡 Die Minimaltemperatur für diesen Tag extrahieren.
        // - Falls kein Wert vorhanden ist, setzen wir **0.0 als Fallback**.
        minTemp:
            (dailyData['temperature_2m_min']?[index] as num?)?.toDouble() ??
            0.0,

        // 🔥 Die Maximaltemperatur für diesen Tag extrahieren.
        maxTemp:
            (dailyData['temperature_2m_max']?[index] as num?)?.toDouble() ??
            0.0,

        // 🌧 Die durchschnittliche Regenwahrscheinlichkeit für diesen Tag.
        precipitationProbability:
            (dailyData['precipitation_probability_mean']?[index] as num?)
                ?.toDouble() ??
            0.0,

        // ☁️ Der Wettercode für diesen Tag (z. B. 1 = Sonnig, 2 = Bewölkt, etc.).
        weatherCode: dailyData['weathercode']?[index] as int? ?? 0,
      ),
    );

    // 🌍 **Erstellt das `WeatherData`-Objekt mit allen Wetterinformationen.**
    return WeatherData(
      // 📍 Der Name des Standorts (z. B. "Berlin" oder "Aktueller Standort").
      location: locationName,

      // 🌡 Falls `temperature` fehlt, setzen wir **0.0 als Fallback**.
      temperature: (weatherData['temperature'] as num?)?.toDouble() ?? 0.0,

      // ☁️ Falls `weathercode` fehlt, setzen wir **0 als Fallback**.
      weatherCode: (weatherData['weathercode'] as int?) ?? 0,

      // 🌬 Falls `windspeed` fehlt, setzen wir **0.0 als Fallback**.
      windSpeed: (weatherData['windspeed'] as num?)?.toDouble() ?? 0.0,

      // 🔄 Falls `hourlyTemperature` fehlt, setzen wir eine **leere Liste** als Fallback.
      hourlyTemperature: hourlyTemps,

      // ☔ Falls `hourlyRainProbabilities` fehlt, setzen wir eine **leere Liste** als Fallback.
      hourlyRainProbabilities: hourlyRain,

      // 🕒 Falls `hourlyTimes` fehlt, setzen wir eine **leere Liste** als Fallback.
      hourlyTimes: List<String>.from(hourlyData['time'] ?? []),

      // ⏰ Falls `timezone` fehlt, setzen wir **"UTC" als Standardwert**.
      timezone: jsonData['timezone'] ?? 'UTC',

      // 📅 Falls `dailyWeather` fehlt, setzen wir eine **leere Liste** als Fallback.
      dailyWeather: dailyForecast,
    );
  }
}
