import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:weather_app/models/weather_data.dart';
import 'package:weather_app/models/weather_state.dart';
import 'package:weather_app/services/location_service.dart';
import 'package:weather_app/services/storage_service.dart';

part 'weather_provider.g.dart';

// 📌 Logger für Debugging & Logging, damit Fehler leichter gefunden werden
final Logger _log = Logger('WeatherNotifier');

@riverpod
class WeatherNotifier extends _$WeatherNotifier {
  // 🌍 Liste vordefinierter Städte mit ihren Koordinaten
  // Falls der Nutzer keinen eigenen Standort verwendet, kann er hier eine Stadt auswählen.
  static final Map<String, (double lat, double lon)> cities = {
    'Bremen': (53.0793, 8.8017),
    'Berlin': (52.5200, 13.4050),
    'München': (48.1351, 11.5820),
    'Hamburg': (53.5511, 9.9937),
    'Köln': (50.9375, 6.9603),
  };

  // 🏁 **Startpunkt der App:** Lädt entweder den gespeicherten Standort oder nutzt die aktuelle Position
  @override
  Future<WeatherState> build() async {
    _log.info('Lade gespeicherte Standortinformationen...');
    final storedLocation = await LocationService.loadLastLocation();

    if (storedLocation != null) {
      _log.info('Gespeicherter Standort gefunden, lade Wetterdaten...');

      final useGeolocation = storedLocation['useGeolocation'];
      final selectedCity = storedLocation['locationName'] ?? 'Unbekannter Ort';

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

  // 📍 **Aktuellen Standort bestimmen und Wetter abrufen**
  Future<WeatherState> fetchWeatherForCurrentLocation() async {
    try {
      _log.info('Ermittle aktuellen Standort...');
      state = const AsyncValue.loading();

      final position = await LocationService.determinePosition();

      // 🔄 Reverse Geocoding: Holt den echten Ortsnamen zu den Koordinaten
      final locationName = await LocationService.getLocationName(
        position.latitude,
        position.longitude,
      );

      final weatherData = await fetchWeather(
        position.latitude,
        position.longitude,
        locationName,
      );

      // ✅ Speichert den echten Standortnamen für spätere Nutzung
      await LocationService.saveLastLocation(
        position.latitude,
        position.longitude,
        true,
        locationName,
      );

      _log.info(
        'Wetter für aktuellen Standort ($locationName) erfolgreich geladen.',
      );
      return WeatherState(
        selectedCity: locationName,
        useGeolocation: true,
        weatherData: weatherData,
      );
    } catch (e) {
      _log.severe('❌ Fehler beim Abrufen des Standorts: $e');
      state = AsyncValue.error(
        'Fehler beim Abrufen des Standorts: $e',
        StackTrace.current,
      );
      return WeatherState(
        errorMessage: 'Fehler beim Abrufen des Standorts: $e',
      );
    }
  }

  // 🌦 **Holt Wetterdaten von Open-Meteo**
  Future<WeatherData> fetchWeather(
    double latitude,
    double longitude,
    String locationName,
  ) async {
    _log.info('🌍 Rufe Wetterdaten für $locationName ab...');
    try {
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

        // ✅ Wetterdaten lokal speichern, damit sie nach App-Neustart noch verfügbar sind
        await StorageService.saveWeatherData(
          weather.temperature,
          weather.weatherCondition,
          weather.windSpeed,
          weather.humidity,
        );

        _log.info('✅ Wetterdaten für $locationName erfolgreich gespeichert.');
        return weather;
      } else {
        _log.severe(
          '❌ Fehler beim Laden der Wetterdaten für $locationName: ${response.statusCode}',
        );
        throw Exception(
          'Failed to load weather. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      _log.severe(
        '❌ Fehler beim Abrufen der Wetterdaten für $locationName: $e',
      );
      throw Exception('Fehler beim Abrufen der Wetterdaten: $e');
    }
  }

  // 🏙 **Wechselt die Stadt und lädt neue Wetterdaten**
  void updateCity(String city) async {
    if (city == 'Aktueller Standort') {
      _log.info('🌍 Standort wird auf aktuellen Standort gesetzt...');
      await refreshWeather();
    } else {
      _log.info('📍 Standort auf $city aktualisiert, lade Wetterdaten...');
      final (lat, lon) = cities[city]!;

      state = const AsyncValue.loading();
      await LocationService.saveLastLocation(lat, lon, false, city);

      final weather = await fetchWeather(lat, lon, city);
      state = AsyncValue.data(
        WeatherState(
          selectedCity: city,
          useGeolocation: false,
          weatherData: weather,
        ),
      );

      _log.info('✅ Wetterdaten für $city erfolgreich geladen.');
    }
  }

  // 🔄 **Aktualisiert die Wetterdaten für den aktuellen Standort**
  Future<void> refreshWeather() async {
    _log.info('🔄 Wetterdaten werden aktualisiert...');
    state = const AsyncValue.loading();
    state = AsyncValue.data(await fetchWeatherForCurrentLocation());
  }

  // 🗑 **Löscht gespeicherte Wetterdaten + Standort & setzt Zustand zurück**
  Future<void> clearHistory() async {
    _log.warning('⚠️ Lösche gespeicherte Wetterdaten und Standort...');
    await StorageService.clearWeatherData();

    state = const AsyncValue.data(
      WeatherState(
        selectedCity: 'Aktueller Standort',
        useGeolocation: true,
        weatherData: null,
        errorMessage: null,
      ),
    );
    _log.info('✅ Gespeicherte Daten erfolgreich gelöscht.');
  }
}
