import 'package:weather_app/models/weather_data.dart';
import 'package:weather_app/models/daily_weather.dart';

/// 🏗 **WeatherService** – Diese Klasse verarbeitet die API-Daten.
class WeatherService {
  /// 🌍 **Konvertiert JSON-Daten in ein `WeatherData`-Objekt.**
  WeatherData parseWeatherData(
    Map<String, dynamic> jsonData,
    String locationName,
  ) {
    // 📌 Extrahiert verschiedene Wetterdaten aus der API-Antwort:
    final weatherData = jsonData['current_weather'] ?? {};
    final hourlyData = jsonData['hourly'] ?? {};
    final dailyData = jsonData['daily'] ?? {};

    // 🕒 Liste mit den Zeitstempeln (als Strings) aus der API holen und in `DateTime` umwandeln
    final List<double> hourlyTemps = List<double>.from(
      (hourlyData['temperature_2m'] ?? []).map(
        (temp) => (temp as num).toDouble(),
      ),
    );

    final List<double> hourlyRain = List<double>.from(
      (hourlyData['precipitation_probability'] ?? []).map(
        (prob) => (prob as num).toDouble(),
      ),
    );

    // **📌 Tägliche Werte**
    final List<DailyWeather> dailyForecast = List.generate(
      (dailyData['time'] as List<dynamic>?)?.length ?? 0,
      (index) => DailyWeather(
        date: DateTime.parse(dailyData['time'][index] as String),
        minTemp:
            (dailyData['temperature_2m_min']?[index] as num?)?.toDouble() ??
            0.0,
        maxTemp:
            (dailyData['temperature_2m_max']?[index] as num?)?.toDouble() ??
            0.0,
        precipitationProbability:
            (dailyData['precipitation_probability_mean']?[index] as num?)
                ?.toDouble() ??
            0.0,
        weatherCode: dailyData['weathercode']?[index] as int? ?? 0,
      ),
    );

    return WeatherData(
      location: locationName,
      temperature: (weatherData['temperature'] as num?)?.toDouble() ?? 0.0,
      weatherCode: (weatherData['weathercode'] as int?) ?? 0,
      windSpeed: (weatherData['windspeed'] as num?)?.toDouble() ?? 0.0,
      hourlyTemperature: hourlyTemps,
      hourlyRainProbabilities: hourlyRain,
      hourlyTimes: List<String>.from(hourlyData['time'] ?? []),
      timezone: jsonData['timezone'] ?? 'UTC',
      dailyWeather: dailyForecast,
    );
  }
}
