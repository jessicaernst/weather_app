import 'package:logging/logging.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/core/app_strings.dart';
import 'package:weather_app/models/daily_weather.dart';
import 'dart:convert';
import 'package:weather_app/models/weather_data.dart';
import 'package:weather_app/models/weather_state.dart';
import 'package:weather_app/services/location_service.dart';
import 'package:weather_app/services/storage_service.dart';

part 'weather_provider.g.dart';

final Logger _log = Logger('WeatherNotifier');

// 🚀 Initialisiert den HTTP-Client für die Wetter-API
@riverpod
http.Client httpClient(Ref ref) {
  return http.Client();
}

@riverpod
class WeatherNotifier extends _$WeatherNotifier {
  // Städte für manuelle Auswahl (Alternative zu Geolocation)
  static final Map<String, (double lat, double lon)> cities = {
    'Bremen': (53.0793, 8.8017),
    'Berlin': (52.5200, 13.4050),
    'München': (48.1351, 11.5820),
    'Hamburg': (53.5511, 9.9937),
    'Köln': (50.9375, 6.9603),
  };

  /// 🚀 Beim Starten der App wird diese Methode automatisch aufgerufen.
  /// Sie prüft, ob bereits ein Standort gespeichert ist.
  /// - Falls ja, lädt sie die gespeicherten Daten.
  /// - Falls nein, wird der aktuelle Standort ermittelt.
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

  /// 📍 Holt das Wetter für den **aktuellen Standort** des Geräts.
  /// - **Schritte:**
  ///   1. Holt die GPS-Koordinaten.
  ///   2. Wandelt die Koordinaten in einen Ortsnamen um.
  ///   3. Fragt die Wetter-API mit diesen Daten ab.
  ///   4. Speichert den Standort für die Zukunft.
  Future<WeatherState> fetchWeatherForCurrentLocation() async {
    try {
      _log.info('Ermittle aktuellen Standort...');
      state = const AsyncValue.loading();

      final position = await LocationService.determinePosition();
      String locationName = await LocationService.getLocationName(
        position.latitude,
        position.longitude,
      );

      // Falls kein Name gefunden wurde, ersetze mit "Aktueller Standort"
      if (locationName.isEmpty) {
        locationName = AppStrings.currentLocation;
        _log.warning(
          'Standortname nicht gefunden, nutze Fallback: $locationName',
        );
      }

      final weatherData = await fetchWeather(
        position.latitude,
        position.longitude,
        locationName,
      );

      // 💾 Speichere den Standort für zukünftige Abrufe
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

  // Holt Wetterdaten von der Open-Meteo API
  Future<WeatherData> fetchWeather(
    double latitude,
    double longitude,
    String locationName,
  ) async {
    _log.info('🌍 Rufe Wetterdaten für $locationName ab...');
    try {
      final response = await ref
          .read(httpClientProvider)
          .get(
            Uri.parse(
              'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude'
              '&current_weather=true'
              '&hourly=temperature_2m,precipitation_probability'
              '&daily=temperature_2m_min,temperature_2m_max,precipitation_probability_mean,weathercode'
              '&timezone=auto',
            ),
          );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final weatherData = jsonData['current_weather'];
        final hourlyData = jsonData['hourly'];
        final dailyData = jsonData['daily'];

        final String timezone = jsonData['timezone'];

        // 🕒 Liste mit den Zeitstempeln (als Strings) aus der API holen und in `DateTime` umwandeln
        final List<DateTime> hourlyTimes =
            List<String>.from(
                  // 🔄 Die Liste von Strings aus der API holen
                  hourlyData['time'], // 🕒 API liefert z. B. ["2025-03-11T00:00", "2025-03-11T01:00"]
                )
                .map(
                  (time) => DateTime.parse(time),
                ) // 🛠 Jeden Zeit-String in ein `DateTime`-Objekt konvertieren
                .toList(); // ✅ Ergebnis ist eine Liste von `DateTime`-Objekten

        // 🌡 Temperaturen für jede Stunde aus der API holen und in eine `double`-Liste umwandeln
        final List<double> hourlyTemps = List<double>.from(
          hourlyData['temperature_2m'] // 🌡 Holt eine Liste mit Temperaturen, z. B. [5.2, 4.8, 4.3]
              .map(
                (temp) => (temp as num).toDouble(),
              ), // 🔄 Jede Temperatur in `double` umwandeln, falls nötig
        ); // ✅ Ergebnis ist eine `List<double>` mit den Temperaturen für jede Stunde

        // 🌧 Regenwahrscheinlichkeit für jede Stunde aus der API holen und umwandeln
        final List<double> hourlyRain = List<double>.from(
          hourlyData['precipitation_probability'] // 🌧 Liste mit Regenwahrscheinlichkeiten, z. B. [10, 20, 30]
              .map(
                (prob) => (prob as num).toDouble(),
              ), // 🔄 Jede Wahrscheinlichkeit in `double` umwandeln
        ); // ✅ Ergebnis ist eine `List<double>` mit den Regenwahrscheinlichkeiten für jede Stunde

        // ⏰ Holt die aktuelle Zeit aus den Wetterdaten und wandelt sie in ein `DateTime`-Objekt um
        final DateTime nowLocal = DateTime.parse(
          weatherData['time'],
        ); // 🕒 Beispiel: "2025-03-11T14:00"

        // 🔍 Suche den Index der aktuellen Stunde in `hourlyTimes`
        int startIndex = hourlyTimes.indexWhere(
          (time) =>
              time.hour ==
              nowLocal
                  .hour, // 🎯 Vergleicht jede gespeicherte Stunde mit der aktuellen Stunde
        );

        // ❗ Falls die aktuelle Stunde nicht in der Liste gefunden wird, setzen wir den Startindex auf 0
        if (startIndex == -1) startIndex = 0;

        // **📌 Tägliche Werte**
        // 🔥 Erstellt eine Liste von DailyWeather-Objekten für die 7-Tage-Vorhersage.
        final List<DailyWeather> dailyForecast = List.generate(
          // 🕒 Die Länge der Liste entspricht der Anzahl der Tage in den API-Daten.
          dailyData['time'].length,

          // 🔄 Für jeden Tag in der API-Antwort wird ein DailyWeather-Objekt erstellt.
          (index) => DailyWeather(
            // 📅 Das Datum des jeweiligen Tages wird aus der API geholt und in ein DateTime-Objekt umgewandelt.
            date: DateTime.parse(dailyData['time'][index]),

            // 🌡 Die Mindesttemperatur für diesen Tag wird geholt und in ein Double umgewandelt.
            minTemp: (dailyData['temperature_2m_min'][index] as num).toDouble(),

            // 🔥 Die Maximaltemperatur für diesen Tag wird ebenfalls geholt und in ein Double umgewandelt.
            maxTemp: (dailyData['temperature_2m_max'][index] as num).toDouble(),

            // 🌧 Die Regenwahrscheinlichkeit für diesen Tag wird ausgelesen und zu einem Double konvertiert.
            precipitationProbability:
                (dailyData['precipitation_probability_mean'][index] as num)
                    .toDouble(),

            // ☁️ Der Wettercode für diesen Tag wird ausgelesen und als Integer gespeichert.
            //    Dieser Code bestimmt später, welches Icon für das Wetter angezeigt wird.
            weatherCode: dailyData['weathercode'][index] as int,
          ),
        );

        final weather = WeatherData(
          location: locationName,
          temperature: (weatherData['temperature'] ?? 0.0).toDouble(),
          weatherCondition:
              (weatherData['weathercode'] ?? 'Unbekannt').toString(),
          windSpeed: (weatherData['windspeed'] ?? 0.0).toDouble(),
          humidity: (weatherData['relativehumidity_2m'] ?? 0.0).toDouble(),
          hourlyTemperature: hourlyTemps.sublist(startIndex),
          hourlyRainProbabilities: hourlyRain.sublist(startIndex),
          hourlyTimes:
              hourlyTimes
                  .sublist(startIndex)
                  .map((dt) => dt.toIso8601String())
                  .toList(),
          timezone: timezone,
          dailyWeather: dailyForecast, // ✅ Speichern der 7-Tage-Vorhersage
        );

        _log.info('✅ Wetterdaten für $locationName erfolgreich geladen.');
        return weather;
      } else {
        throw Exception(
          '❌ Fehler beim Laden der Wetterdaten für $locationName: ${response.statusCode}',
        );
      }
    } catch (e) {
      _log.severe(
        '❌ Fehler beim Abrufen der Wetterdaten für $locationName: $e',
      );
      throw Exception('Fehler beim Abrufen der Wetterdaten: $e');
    }
  }

  // Aktualisiert Standort & Wetterdaten
  void updateCity(String city) async {
    if (city == 'Aktueller Standort') {
      _log.info('Standort wird auf aktuellen Standort gesetzt...');
      await refreshWeather();
    } else {
      _log.info('Standort auf $city aktualisiert, lade Wetterdaten...');
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
      _log.info('Wetterdaten für $city erfolgreich geladen.');
    }
  }

  /// ✅ Validiert den Stadtnamen und gibt eine gültige Stadt zurück
  String validateCityName(String city) {
    if (cities.containsKey(city) || city == AppStrings.currentLocation) {
      return city;
    }
    _log.warning(
      '⚠️ Ungültige Stadt "$city", zurücksetzen auf ${AppStrings.currentLocation}',
    );
    return AppStrings.currentLocation;
  }

  // Aktualisiert Wetterdaten für den aktuellen Standort
  Future<void> refreshWeather() async {
    _log.info('Wetterdaten werden aktualisiert...');
    state = const AsyncValue.loading();
    state = AsyncValue.data(await fetchWeatherForCurrentLocation());
  }

  // Löscht gespeicherte Wetterdaten & setzt Zustand zurück
  Future<void> clearHistory() async {
    _log.warning('Lösche gespeicherte Wetterdaten und Standort...');
    await StorageService.clearWeatherData();

    state = const AsyncValue.data(
      WeatherState(
        selectedCity: 'Aktueller Standort',
        useGeolocation: true,
        weatherData: null,
        errorMessage: null,
      ),
    );
    _log.info('Gespeicherte Daten erfolgreich gelöscht.');
  }
}
