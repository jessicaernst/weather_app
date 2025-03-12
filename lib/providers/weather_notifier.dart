import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:weather_app/core/app_strings.dart';
import 'package:weather_app/models/weather_state.dart';
import 'package:weather_app/providers/repository_provider.dart';
import 'package:weather_app/providers/service_provider.dart';
import 'package:weather_app/repositories/weather_repository.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/services/location_service.dart';
import 'package:weather_app/services/storage_service.dart';

part 'weather_notifier.g.dart'; // 🚀 Automatisch generierte Datei durch Riverpod

final Logger _log = Logger(
  'WeatherNotifier',
); // 📌 Logger für Debugging und Statusmeldungen

/// 🌍 **WeatherNotifier** – Verwalte den Wetterzustand (Code-Generated)
/// - Nutzt Repository & Service für API-Calls & lokale Speicherung.
/// - Aktualisiert Wetterdaten und speichert sie, falls nötig.
/// - Nutzt Riverpod für State-Management.
@riverpod
class WeatherNotifier extends _$WeatherNotifier {
  // 📌 Diese beiden Variablen halten die Instanzen für das Repository und den Service bereit.
  // - `WeatherRepository` ruft die Wetterdaten aus der API ab.
  // - `WeatherService` verarbeitet die erhaltenen Daten in ein passendes Format.
  late final WeatherRepository _repository;
  late final WeatherService _service;

  /// 🌍 **Liste der vordefinierten Städte mit ihren Koordinaten**
  /// - Falls der Nutzer keine GPS-Ortung nutzt, kann er eine Stadt auswählen.
  /// - Jede Stadt ist mit `latitude` (Breitengrad) und `longitude` (Längengrad) gespeichert.
  static final Map<String, (double lat, double lon)> cities = {
    'Bremen': (53.0793, 8.8017),
    'Berlin': (52.5200, 13.4050),
    'München': (48.1351, 11.5820),
    'Hamburg': (53.5511, 9.9937),
    'Köln': (50.9375, 6.9603),
    'San José': (9.9281, -84.0907),
  };

  /// ✅ **Standard-Konstruktor erforderlich für Riverpod**
  /// - Der Konstruktor bleibt leer, weil Riverpod den State selbst verwaltet.
  WeatherNotifier();

  /// 🚀 **Diese Methode wird beim App-Start aufgerufen.**
  /// - Holt gespeicherte oder aktuelle Standortdaten.
  /// - Falls der Nutzer bereits einen Standort ausgewählt hat, wird dieser geladen.
  /// - Falls kein gespeicherter Standort existiert, wird GPS-Ortung genutzt.
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

  /// 📍 **Holt Wetterdaten für den aktuellen Standort via GPS**
  /// - Holt die aktuellen GPS-Koordinaten des Geräts.
  /// - Versucht, den Standortnamen über Reverse Geocoding zu bestimmen.
  /// - Falls kein Standortname gefunden wird, wird „Aktueller Standort“ als Fallback genutzt.
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

  /// 🌍 **Holt Wetterdaten von der API und speichert sie in SharedPreferences**
  /// - Führt eine API-Anfrage für die übergebenen Koordinaten aus.
  /// - Verarbeitet die Antwort und speichert den Standort.
  Future<WeatherState> fetchWeather(
    double latitude,
    double longitude,
    String locationName,
  ) async {
    state = const AsyncValue.loading();

    try {
      final jsonData = await _repository.fetchWeatherData(latitude, longitude);
      final timezoneId = jsonData['timezone'] ?? 'UTC';

      final weather = _service.parseWeatherData(jsonData, locationName);
      final List<String> correctedTimes =
          weather.hourlyTimes
              .map((utcTime) => convertUtcToLocal(utcTime, timezoneId))
              .toList();

      final correctedWeather = weather.copyWith(hourlyTimes: correctedTimes);

      await LocationService.saveLastLocation(
        latitude,
        longitude,
        true,
        locationName,
      );

      final newState = WeatherState(
        selectedCity: locationName,
        useGeolocation: true,
        weatherData: correctedWeather,
      );

      _log.info(
        '📌 Korrigierte Stundenzeiten vor UI-Update: ${correctedWeather.hourlyTimes}',
      );
      state = AsyncValue.data(newState);

      return newState;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      _log.severe('❌ Fehler beim Laden der Wetterdaten: $e');
      return WeatherState(errorMessage: e.toString());
    }
  }

  /// 🕒 **Konvertiert eine UTC-Zeit (`HH:mm`) in die lokale Zeit der angegebenen Zeitzone**
  /// 🕒 **Konvertiert eine UTC-Zeit (`HH:mm`) in die lokale Zeit der angegebenen Zeitzone**
  String convertUtcToLocal(String utcTime, String timezoneId) {
    try {
      _log.info('🌍 Konvertiere UTC-Zeit $utcTime in Zeitzone $timezoneId');

      // 🌍 Korrekte Zeitzone für den Standort abrufen
      final tz.Location location = tz.getLocation(timezoneId);

      // 🕒 Stelle sicher, dass das UTC-Datum nicht zu Problemen führt (1970-01-01 als Basis)
      final DateTime utcDateTime = DateFormat('HH:mm').parse(utcTime);

      // 📅 Vollen UTC-Zeitstempel mit Dummy-Datum erstellen
      final DateTime fullUtcDate = DateTime.utc(
        1970,
        1,
        1,
        utcDateTime.hour,
        utcDateTime.minute,
      );

      // 🌍 Konvertiere in die lokale Zeit mit der angegebenen Zeitzone
      final tz.TZDateTime localTime = tz.TZDateTime.from(fullUtcDate, location);

      // ⏰ Formatierte Zeit für die UI zurückgeben
      final String formattedTime = DateFormat('HH:mm').format(localTime);

      _log.fine(
        '✅ Umrechnung erfolgreich: UTC=$utcTime → Lokal=$formattedTime ($timezoneId)',
      );
      return formattedTime;
    } catch (e) {
      _log.severe(
        '⚠️ Fehler bei Zeitzonen-Umrechnung für $utcTime in $timezoneId: $e',
      );
      return utcTime; // Falls Fehler, bleibt UTC
    }
  }

  /// 🏙 **Wechselt den Standort und lädt neue Wetterdaten**
  /// - Wird aufgerufen, wenn der Nutzer eine Stadt aus dem Dropdown-Menü wählt.
  Future<void> updateCity(String city, double lat, double lon) async {
    state =
        const AsyncValue.loading(); // ⏳ Zeigt an, dass neue Daten geladen werden.

    // 📡 Holt Wetterdaten für die neue Stadt.
    final weather = await fetchWeather(lat, lon, city);

    // 💾 Speichert die neue Stadt als Standardstandort.
    await LocationService.saveLastLocation(lat, lon, false, city);

    // ✅ Speichert die abgerufenen Wetterdaten im `state`, sodass sie in der UI angezeigt werden.
    state = AsyncValue.data(weather);

    _log.info('✅ Wetterdaten für $city geladen & gespeichert.');
  }

  /// 🗑 **Löscht gespeicherte Wetterdaten und Standort**
  /// - Entfernt den zuletzt gespeicherten Standort und alle dazugehörigen Daten.
  /// - Setzt den Standort auf „Aktueller Standort“.
  Future<void> clearHistory() async {
    _log.warning('🗑 Lösche gespeicherte Wetterdaten & Standort...');

    // 🔄 Löscht die gespeicherten Wetterdaten aus SharedPreferences.
    await StorageService.clearWeatherData();

    // 🔄 Setzt den State auf eine leere Wetteranzeige.
    state = const AsyncValue.data(
      WeatherState(selectedCity: 'Aktueller Standort', useGeolocation: true),
    );

    _log.info('✅ Gespeicherte Daten erfolgreich gelöscht.');
  }

  /// ✅ **Validiert den Stadtnamen und gibt eine gültige Stadt zurück**
  /// - Falls die Stadt in `cities` vorhanden ist, wird sie beibehalten.
  /// - Falls nicht, wird „Aktueller Standort“ als Fallback genutzt.
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
  /// - Wird aufgerufen, wenn der Nutzer den Aktualisieren-Button drückt.
  Future<void> refreshWeather() async {
    _log.info('🌍 Aktualisiere Wetterdaten für aktuellen Standort...');

    // ⏳ Setzt den State auf "Laden".
    state = const AsyncValue.loading();

    // 📡 Holt die aktuellen Wetterdaten erneut.
    state = AsyncValue.data(await fetchWeatherForCurrentLocation());
  }
}
