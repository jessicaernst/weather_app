import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:weather_app/core/app_strings.dart';
import 'package:weather_app/models/weather_state.dart';
import 'package:weather_app/providers/repository_provider.dart';
import 'package:weather_app/providers/service_provider.dart';
import 'package:weather_app/repositories/weather_repository.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/services/location_service.dart';
import 'package:weather_app/services/storage_service.dart';

part 'weather_notifier.g.dart'; // 🚀 Automatisch generierte Datei durch Riverpod

final Logger _log = Logger('WeatherNotifier');

/// 🌍 **WeatherNotifier** – Verwalte den Wetterzustand (Code-Generated)
/// - Nutzt Repository & Service für API-Calls & lokale Speicherung.
/// - Aktualisiert Wetterdaten und speichert sie.
@riverpod
class WeatherNotifier extends _$WeatherNotifier {
  late final WeatherRepository _repository;
  late final WeatherService _service;

  static final Map<String, (double lat, double lon)> cities = {
    'Bremen': (53.0793, 8.8017),
    'Berlin': (52.5200, 13.4050),
    'München': (48.1351, 11.5820),
    'Hamburg': (53.5511, 9.9937),
    'Köln': (50.9375, 6.9603),
  };

  /// ✅ **Standard-Konstruktor erforderlich für Riverpod**
  WeatherNotifier();

  /// 🚀 **Wird beim App-Start aufgerufen** – Holt gespeicherte oder aktuelle Standortdaten.
  @override
  Future<WeatherState> build() async {
    _repository = ref.read(weatherRepositoryProvider);
    _service = ref.read(weatherServiceProvider);

    _log.info('🔍 Lade gespeicherte Standortinformationen...');
    final storedLocation = await LocationService.loadLastLocation();

    if (storedLocation != null) {
      return fetchWeather(
        storedLocation['latitude'],
        storedLocation['longitude'],
        storedLocation['locationName'] ?? 'Unbekannter Ort',
      );
    }

    return fetchWeatherForCurrentLocation();
  }

  /// 📍 **Holt Wetterdaten für den aktuellen Standort**.
  Future<WeatherState> fetchWeatherForCurrentLocation() async {
    try {
      _log.info('📡 Ermittle aktuellen Standort...');
      state = const AsyncValue.loading();

      final position = await LocationService.determinePosition();
      String locationName = await LocationService.getLocationName(
        position.latitude,
        position.longitude,
      );

      if (locationName.isEmpty) {
        locationName = 'Aktueller Standort';
      }

      return fetchWeather(position.latitude, position.longitude, locationName);
    } catch (e) {
      _log.severe('❌ Fehler beim Abrufen des Standorts: $e');
      return WeatherState(
        errorMessage: 'Fehler beim Abrufen des Standorts: $e',
      );
    }
  }

  /// 🌍 **Holt Wetterdaten von der API und speichert sie in SharedPreferences**.
  Future<WeatherState> fetchWeather(
    double latitude,
    double longitude,
    String locationName,
  ) async {
    state = const AsyncValue.loading();
    final jsonData = await _repository.fetchWeatherData(latitude, longitude);
    final weather = _service.parseWeatherData(jsonData, locationName);

    await LocationService.saveLastLocation(
      latitude,
      longitude,
      true,
      locationName,
    );

    _log.info('✅ Wetter für $locationName geladen & gespeichert.');
    return WeatherState(
      selectedCity: locationName,
      useGeolocation: true,
      weatherData: weather,
    );
  }

  /// 🏙 **Wechselt den Standort und lädt neue Wetterdaten**.
  Future<void> updateCity(String city, double lat, double lon) async {
    state = const AsyncValue.loading();
    final weather = await fetchWeather(lat, lon, city);
    await LocationService.saveLastLocation(lat, lon, false, city);
    state = AsyncValue.data(weather);
    _log.info('✅ Wetterdaten für $city geladen & gespeichert.');
  }

  /// 🗑 **Löscht gespeicherte Wetterdaten und Standort**.
  Future<void> clearHistory() async {
    _log.warning('🗑 Lösche gespeicherte Wetterdaten & Standort...');
    await StorageService.clearWeatherData();
    state = const AsyncValue.data(
      WeatherState(selectedCity: 'Aktueller Standort', useGeolocation: true),
    );
    _log.info('✅ Gespeicherte Daten erfolgreich gelöscht.');
  }

  /// ✅ **Validiert den Stadtnamen und gibt eine gültige Stadt zurück**
  String validateCityName(String city) {
    if (cities.containsKey(city) || city == AppStrings.currentLocation) {
      return city;
    }
    _log.warning(
      '⚠️ Ungültige Stadt "$city", zurücksetzen auf ${AppStrings.currentLocation}',
    );
    return AppStrings.currentLocation;
  }

  /// ✅ **Aktualisiert Wetterdaten für den aktuellen Standort**
  Future<void> refreshWeather() async {
    _log.info('🌍 Aktualisiere Wetterdaten für aktuellen Standort...');
    state = const AsyncValue.loading();
    state = AsyncValue.data(await fetchWeatherForCurrentLocation());
  }
}
