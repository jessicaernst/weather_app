import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:weather_app/models/weather_data.dart';
import 'package:weather_app/models/weather_state.dart';
import 'package:weather_app/services/location_service.dart';
import 'package:weather_app/services/storage_service.dart';

part 'weather_provider.g.dart';

final Logger _log = Logger('WeatherNotifier');

@riverpod
class WeatherNotifier extends _$WeatherNotifier {
  // 🌍 Vordefinierte Städte mit ihren Koordinaten
  static final Map<String, (double lat, double lon)> cities = {
    'Bremen': (53.0793, 8.8017),
    'Berlin': (52.5200, 13.4050),
    'München': (48.1351, 11.5820),
    'Hamburg': (53.5511, 9.9937),
    'Köln': (50.9375, 6.9603),
  };

  // 🔄 Startet den Initialisierungsprozess des Notifiers
  @override
  Future<WeatherState> build() async {
    _log.info('Lade gespeicherte Standortinformationen...');
    final storedLocation = await LocationService.loadLastLocation();

    if (storedLocation != null) {
      _log.info('Gespeicherter Standort gefunden, lade Wetterdaten...');

      final useGeolocation = storedLocation['useGeolocation'];
      final selectedCity =
          useGeolocation
              ? 'Aktueller Standort'
              : cities.keys.firstWhere(
                (key) =>
                    cities[key]?.$1 == storedLocation['latitude'] &&
                    cities[key]?.$2 == storedLocation['longitude'],
                orElse: () => 'Aktueller Standort',
              );

      final weatherData = await fetchWeather(
        storedLocation['latitude'],
        storedLocation['longitude'],
        selectedCity,
      );

      return WeatherState(
        selectedCity: selectedCity,
        useGeolocation: useGeolocation,
        weatherData: weatherData,
      );
    }

    _log.warning(
      'Kein gespeicherter Standort gefunden, verwende aktuellen Standort...',
    );
    return fetchWeatherForCurrentLocation();
  }

  // 📍 Holt das Wetter für den aktuellen Standort
  Future<WeatherState> fetchWeatherForCurrentLocation() async {
    try {
      _log.info('Ermittle aktuellen Standort...');
      state = const AsyncValue.loading();
      final position = await LocationService.determinePosition();

      final weatherData = await fetchWeather(
        position.latitude,
        position.longitude,
        'Aktueller Standort',
      );

      await LocationService.saveLastLocation(
        position.latitude,
        position.longitude,
        true,
      );

      _log.info('Wetter für aktuellen Standort erfolgreich geladen.');
      return WeatherState(
        selectedCity: 'Aktueller Standort',
        useGeolocation: true,
        weatherData: weatherData,
      );
    } catch (e) {
      _log.severe('Fehler beim Abrufen des Standorts: $e');
      state = AsyncValue.error(
        'Fehler beim Abrufen des Standorts: $e',
        StackTrace.current,
      );
      return WeatherState(
        errorMessage: 'Fehler beim Abrufen des Standorts: $e',
      );
    }
  }

  // 🌦 Holt Wetterdaten von der API
  Future<WeatherData> fetchWeather(
    double latitude,
    double longitude,
    String locationName,
  ) async {
    _log.info('Rufe Wetterdaten für $locationName ab...');
    final response = await http.get(
      Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current_weather=true',
      ),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final weatherData = jsonData['current_weather'];

      final weather = WeatherData(
        location: locationName,
        temperature: (weatherData['temperature'] ?? 0.0).toDouble(),
        weatherCondition:
            (weatherData['weathercode'] ?? 'Unbekannt').toString(),
        windSpeed: (weatherData['windspeed'] ?? 0.0).toDouble(),
        humidity: (weatherData['relativehumidity_2m'] ?? 0.0).toDouble(),
      );

      await StorageService.saveWeatherData(
        weather.temperature,
        weather.weatherCondition,
        weather.windSpeed,
        weather.humidity,
      );

      _log.info('Wetterdaten für $locationName erfolgreich gespeichert.');
      return weather;
    } else {
      _log.severe('Fehler beim Laden der Wetterdaten für $locationName.');
      throw Exception('Failed to load weather');
    }
  }

  // 🌍 Aktualisiert den Standort und lädt neue Wetterdaten
  void updateCity(String city) async {
    if (city == 'Aktueller Standort') {
      _log.info('Standort wird auf aktuellen Standort gesetzt...');
      await refreshWeather();
    } else {
      _log.info('Standort auf $city aktualisiert, lade Wetterdaten...');
      final (lat, lon) = cities[city]!;

      state = const AsyncValue.loading();

      await LocationService.saveLastLocation(lat, lon, false);

      final weather = await fetchWeather(lat, lon, city);
      state = AsyncValue.data(
        WeatherState(
          selectedCity: city,
          useGeolocation: false,
          weatherData: weather,
        ),
      );
      _log.info('Wetterdaten für $city erfolgreich geladen.');
    }
  }

  // 🔄 Frischt die Wetterdaten für den aktuellen Standort auf
  Future<void> refreshWeather() async {
    _log.info('Wetterdaten werden aktualisiert...');
    state = const AsyncValue.loading();
    state = AsyncValue.data(await fetchWeatherForCurrentLocation());
  }

  // 🗑 Löscht gespeicherte Wetterdaten und setzt den Zustand zurück
  Future<void> clearHistory() async {
    _log.warning('Lösche gespeicherte Wetterdaten...');
    await StorageService.clearWeatherData();

    state = const AsyncValue.data(
      WeatherState(
        selectedCity: 'Aktueller Standort',
        useGeolocation: true,
        weatherData: null,
        errorMessage: null,
      ),
    );
    _log.info('Wetterdaten erfolgreich gelöscht.');
  }
}
