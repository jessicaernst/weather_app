import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:weather_app/models/weather_data.dart';
import 'package:weather_app/models/weather_state.dart';
import 'package:weather_app/services/location_service.dart';
import 'package:weather_app/services/storage_service.dart';

part 'weather_provider.g.dart';

// Logger für die Klasse WeatherNotifier erstellen, um Debugging und Logging zu ermöglichen.
final Logger _log = Logger('WeatherNotifier');

// Diese Klasse verwaltet den Wetterzustand und ist zuständig für das Laden, Speichern und Abrufen von Wetterdaten.
@riverpod
class WeatherNotifier extends _$WeatherNotifier {
  // Vordefinierte Städte mit ihren Koordinaten. Diese Daten werden verwendet, wenn ein Benutzer eine Stadt auswählt.
  static final Map<String, (double lat, double lon)> cities = {
    'Bremen': (53.0793, 8.8017),
    'Berlin': (52.5200, 13.4050),
    'München': (48.1351, 11.5820),
    'Hamburg': (53.5511, 9.9937),
    'Köln': (50.9375, 6.9603),
  };

  // Initialisiert den Zustand des Wetter-Notifiers. Diese Methode wird automatisch aufgerufen, wenn der Notifier zum ersten Mal verwendet wird.
  @override
  Future<WeatherState> build() async {
    _log.info('Lade gespeicherte Standortinformationen...');
    // Versuche, den zuletzt gespeicherten Standort zu laden.
    final storedLocation = await LocationService.loadLastLocation();

    // Wenn ein gespeicherter Standort existiert:
    if (storedLocation != null) {
      _log.info('Gespeicherter Standort gefunden, lade Wetterdaten...');

      // Überprüfe, ob Geolocation verwendet wurde.
      final useGeolocation = storedLocation['useGeolocation'];
      // Bestimme den Namen der Stadt. Wenn Geolocation verwendet wurde, ist der Name 'Aktueller Standort'.
      // Andernfalls finde den Namen der Stadt, die zu den gespeicherten Koordinaten passt.
      final selectedCity =
          useGeolocation
              ? 'Aktueller Standort'
              : cities.keys.firstWhere(
                (key) =>
                    cities[key]?.$1 == storedLocation['latitude'] &&
                    cities[key]?.$2 == storedLocation['longitude'],
                orElse: () => 'Aktueller Standort',
              );

      // Lade die Wetterdaten für den gespeicherten Standort.
      final weatherData = await fetchWeather(
        storedLocation['latitude'],
        storedLocation['longitude'],
        selectedCity,
      );

      // Gib den Zustand mit den geladenen Daten zurück.
      return WeatherState(
        selectedCity: selectedCity,
        useGeolocation: useGeolocation,
        weatherData: weatherData,
      );
    }

    // Wenn kein gespeicherter Standort gefunden wurde:
    _log.warning(
      'Kein gespeicherter Standort gefunden, verwende aktuellen Standort...',
    );
    // Rufe die Methode zum Abrufen der Wetterdaten für den aktuellen Standort auf.
    return fetchWeatherForCurrentLocation();
  }

  // Holt das Wetter für den aktuellen Standort des Geräts.
  Future<WeatherState> fetchWeatherForCurrentLocation() async {
    try {
      _log.info('Ermittle aktuellen Standort...');
      // Setze den Zustand auf "wird geladen", um dem Benutzer anzuzeigen, dass die Daten abgerufen werden.
      state = const AsyncValue.loading();
      // Ermittle die aktuelle Position des Geräts.
      final position = await LocationService.determinePosition();

      // Rufe die Wetterdaten für den aktuellen Standort ab.
      final weatherData = await fetchWeather(
        position.latitude,
        position.longitude,
        'Aktueller Standort',
      );

      // Speichere den aktuellen Standort für die nächste Verwendung.
      await LocationService.saveLastLocation(
        position.latitude,
        position.longitude,
        true,
      );

      _log.info('Wetter für aktuellen Standort erfolgreich geladen.');
      // Gib den Zustand mit den neuen Daten zurück.
      return WeatherState(
        selectedCity: 'Aktueller Standort',
        useGeolocation: true,
        weatherData: weatherData,
      );
    } catch (e) {
      // Behandle Fehler beim Abrufen des Standorts.
      _log.severe('Fehler beim Abrufen des Standorts: $e');
      // Setze den Zustand auf "Fehler" und speichere die Fehlermeldung.
      state = AsyncValue.error(
        'Fehler beim Abrufen des Standorts: $e',
        StackTrace.current,
      );
      // Gib den Zustand mit der Fehlermeldung zurück.
      return WeatherState(
        errorMessage: 'Fehler beim Abrufen des Standorts: $e',
      );
    }
  }

  // Holt Wetterdaten von der Open-Meteo-API.
  Future<WeatherData> fetchWeather(
    double latitude,
    double longitude,
    String locationName,
  ) async {
    _log.info('Rufe Wetterdaten für $locationName ab...');
    // Führe die HTTP-Anfrage innerhalb eines try-catch-Blocks aus, um Fehler zu behandeln.
    try {
      // Sende eine GET-Anfrage an die Open-Meteo-API.
      final response = await http.get(
        Uri.parse(
          'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current_weather=true',
        ),
      );

      // Überprüfe den HTTP-Statuscode der Antwort.
      if (response.statusCode == 200) {
        // Wenn die Anfrage erfolgreich war, decodiere die JSON-Antwort.
        final jsonData = json.decode(response.body);
        // Hole die aktuellen Wetterdaten aus der JSON-Antwort.
        final weatherData = jsonData['current_weather'];

        // Erstelle ein WeatherData-Objekt aus den erhaltenen Daten.
        final weather = WeatherData(
          location: locationName,
          temperature: (weatherData['temperature'] ?? 0.0).toDouble(),
          weatherCondition:
              (weatherData['weathercode'] ?? 'Unbekannt').toString(),
          windSpeed: (weatherData['windspeed'] ?? 0.0).toDouble(),
          humidity: (weatherData['relativehumidity_2m'] ?? 0.0).toDouble(),
        );

        // Speichere die Wetterdaten im lokalen Speicher.
        await StorageService.saveWeatherData(
          weather.temperature,
          weather.weatherCondition,
          weather.windSpeed,
          weather.humidity,
        );

        _log.info('Wetterdaten für $locationName erfolgreich gespeichert.');
        // Gib die Wetterdaten zurück.
        return weather;
      } else {
        // Wenn die Anfrage nicht erfolgreich war, logge den Fehler.
        _log.severe(
          'Fehler beim Laden der Wetterdaten für $locationName: ${response.statusCode}',
        );
        // Wirf eine Exception, um den Fehler weiterzuleiten.
        throw Exception(
          'Failed to load weather. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      // Fange Fehler ab, die während der HTTP-Anfrage oder der JSON-Verarbeitung auftreten könnten.
      _log.severe('Fehler beim Abrufen der Wetterdaten für $locationName: $e');
      // Wirf eine Exception, um den Fehler weiterzuleiten.
      throw Exception('Fehler beim Abrufen der Wetterdaten: $e');
    }
  }

  // Aktualisiert den Standort und lädt die Wetterdaten für den neuen Standort.
  void updateCity(String city) async {
    // Überprüfe, ob der Benutzer den aktuellen Standort ausgewählt hat.
    if (city == 'Aktueller Standort') {
      _log.info('Standort wird auf aktuellen Standort gesetzt...');
      // Wenn ja, aktualisiere die Wetterdaten für den aktuellen Standort.
      await refreshWeather();
    } else {
      // Andernfalls:
      _log.info('Standort auf $city aktualisiert, lade Wetterdaten...');
      // Hole die Koordinaten der ausgewählten Stadt aus der Liste.
      final (lat, lon) = cities[city]!;

      // Setze den Zustand auf "wird geladen".
      state = const AsyncValue.loading();

      // Speichere den neuen Standort.
      await LocationService.saveLastLocation(lat, lon, false);

      // Lade die Wetterdaten für den neuen Standort.
      final weather = await fetchWeather(lat, lon, city);
      // Aktualisiere den Zustand mit den neuen Daten.
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

  // Aktualisiert die Wetterdaten für den aktuellen Standort.
  Future<void> refreshWeather() async {
    _log.info('Wetterdaten werden aktualisiert...');
    // Setze den Zustand auf "wird geladen".
    state = const AsyncValue.loading();
    // Rufe die Wetterdaten für den aktuellen Standort ab und aktualisiere den Zustand.
    state = AsyncValue.data(await fetchWeatherForCurrentLocation());
  }

  // Löscht die gespeicherten Wetterdaten und setzt den Zustand auf den Standardwert zurück.
  Future<void> clearHistory() async {
    _log.warning('Lösche gespeicherte Wetterdaten...');
    // Lösche die gespeicherten Wetterdaten im lokalen Speicher.
    await StorageService.clearWeatherData();

    // Setze den Zustand auf den Standardwert zurück.
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
