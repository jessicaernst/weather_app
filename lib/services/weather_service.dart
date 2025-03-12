import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:weather_app/models/weather_data.dart';
import 'package:weather_app/models/daily_weather.dart';
import 'package:timezone/timezone.dart' as tz;

final Logger _log = Logger('WeatherService');

/// 🏗 **WeatherService** – Diese Klasse verarbeitet die API-Daten.
/// - Wandelt die erhaltenen JSON-Daten aus der Wetter-API in ein nutzbares Dart-Objekt (`WeatherData`) um.
/// - Enthält Methoden zur Extraktion und Formatierung von Wetterinformationen, **inklusive korrekter Zeitzonen-Anpassung**.
class WeatherService {
  /// 🌍 **Konvertiert JSON-Daten in ein `WeatherData`-Objekt.**
  /// - Nutzt `tz.TZDateTime.from()`, um UTC-Zeit korrekt auf Ortszeit umzurechnen.
  /// - Dadurch wird sichergestellt, dass Sommer- und Winterzeit korrekt berechnet werden.
  WeatherData parseWeatherData(
    Map<String, dynamic> jsonData, // 🌍 Rohdaten von der API (als JSON-Map)
    String
    locationName, // 📍 Name des Standorts (z. B. "Berlin" oder "San Francisco")
  ) {
    _log.info('🌍 Rohdaten von Open-Meteo API: ${jsonData.toString()}');

    // 📌 Wetterdaten aus der API extrahieren
    final weatherData =
        jsonData['current_weather'] as Map<String, dynamic>? ?? {};
    final hourlyData = jsonData['hourly'] as Map<String, dynamic>? ?? {};
    final dailyData = jsonData['daily'] as Map<String, dynamic>? ?? {};

    // 🕒 **Zeitzoneninformationen aus der API holen**
    final String timezoneId = jsonData['timezone'] ?? 'UTC';

    try {
      // 🌍 **Korrekte Zeitzone anhand der API-Daten holen**
      tz.Location location;
      try {
        location = tz.getLocation(timezoneId);
      } catch (e) {
        _log.warning(
          '⚠️ Zeitzone nicht gefunden: $timezoneId. Fallback auf UTC.',
        );
        location = tz.getLocation('UTC');
      }

      _log.info('🕒 API gibt Zeitzone zurück: $timezoneId');

      // 🕒 **Liste mit den Zeitstempeln aus der API holen und in `DateTime` umwandeln**
      final List<String> hourlyTimes =
          (hourlyData['time'] as List<dynamic>?)?.map<String>((time) {
            final DateTime utcTime = DateTime.parse(time).toUtc();
            final DateTime localTime = tz.TZDateTime.from(utcTime, location);

            // 🕒 Formatierung mit `intl`
            final formattedTime = DateFormat('HH:mm').format(localTime);
            _log.fine(
              '🕒 Umgerechnet: UTC=$utcTime → Lokal=$formattedTime ($timezoneId)',
            );
            return formattedTime;
          }).toList() ??
          [];

      // 🌡 **Stündliche Temperaturen extrahieren**
      final List<double> hourlyTemps = List<double>.from(
        (hourlyData['temperature_2m'] ?? []).map(
          (temp) => (temp as num).toDouble(),
        ),
      );

      // 🌧 **Stündliche Regenwahrscheinlichkeit**
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
        hourlyTimes: hourlyTimes, // ✅ Jetzt mit der korrekten Ortszeit!
        // ⏰ Falls `timezone` fehlt, setzen wir **"UTC" als Standardwert**.
        timezone: timezoneId,

        // 📅 Falls `dailyWeather` fehlt, setzen wir eine **leere Liste** als Fallback.
        dailyWeather: dailyForecast,
      );
    } catch (e) {
      _log.severe('⚠️ Fehler beim Zeitzonen-Handling für $timezoneId: $e');

      // Fallback auf UTC falls Fehler auftritt
      return WeatherData(
        location: locationName,
        temperature: (weatherData['temperature'] as num?)?.toDouble() ?? 0.0,
        weatherCode: (weatherData['weathercode'] as int?) ?? 0,
        windSpeed: (weatherData['windspeed'] as num?)?.toDouble() ?? 0.0,
        hourlyTemperature: [],
        hourlyRainProbabilities: [],
        hourlyTimes: [],
        timezone: 'UTC',
        dailyWeather: [],
      );
    }
  }
}
