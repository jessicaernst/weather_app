import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:weather_app/models/weather_data.dart';
import 'package:weather_app/services/storage_service.dart';

part 'weather_provider.g.dart';

@riverpod
class WeatherNotifier extends _$WeatherNotifier {
  @override
  Future<WeatherData> build() async {
    // 🌟 1️⃣ Lade gespeicherte Wetterdaten beim App-Start
    final storedData = await StorageService.loadWeatherData();
    if (storedData != null) {
      return WeatherData(
        temperature: storedData['temperature'],
        weatherCondition: storedData['weatherCondition'],
        windSpeed: storedData['windSpeed'],
        humidity: storedData['humidity'],
        location: '',
      );
    }
    // 🌟 2️⃣ Falls keine Daten gespeichert sind, lade die API-Daten
    return fetchWeather();
  }

  // 🌟 3️⃣ Wetterdaten von der API abrufen und speichern
  Future<WeatherData> fetchWeather() async {
    const double latitude = 53.0793;
    const double longitude = 8.8017;

    final response = await http.get(
      Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current_weather=true',
      ),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final weatherData = jsonData['current_weather'];

      final weather = WeatherData(
        temperature: (weatherData['temperature'] ?? 0.0).toDouble(),
        weatherCondition:
            (weatherData['weathercode'] ?? 'Unbekannt').toString(),
        windSpeed: (weatherData['windspeed'] ?? 0.0).toDouble(),
        humidity: (weatherData['relativehumidity_2m'] ?? 0.0).toDouble(),
        location: 'Bremen',
      );

      // 🌟 4️⃣ Speichern der neuen Wetterdaten in SharedPreferences
      await StorageService.saveWeatherData(
        weather.temperature,
        weather.weatherCondition,
        weather.windSpeed,
        weather.humidity,
      );

      return weather;
    } else {
      throw Exception('Failed to load weather');
    }
  }

  // 🌟 5️⃣ Wetterdaten erneut abrufen & UI aktualisieren
  Future<void> refreshWeather() async {
    state = const AsyncValue.loading();
    state = AsyncValue.data(await fetchWeather());
  }

  // 🌟 6️⃣ Wetter-Historie löschen & Zustand zurücksetzen
  Future<void> clearHistory() async {
    await StorageService.clearWeatherData();
    state = AsyncValue.error(
      'Keine gespeicherten Wetterdaten.',
      StackTrace.current,
    );
  }
}
