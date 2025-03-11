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

part 'weather_provider.g.dart'; // 🚀 Automatisch generierte Datei durch Riverpod

final Logger _log = Logger('WeatherNotifier');

// 🚀 Initialisiert den HTTP-Client für die Wetter-API
@riverpod
http.Client httpClient(Ref ref) {
  return http.Client();
}

// Ein Riverpod-Provider, der eine Instanz von `WeatherNotifier` erstellt.
// ein Notifier ist ein spezieller Provider, der den Zustand einer App verwalten kann.
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

  /// 🚀 Diese Methode wird **automatisch** beim Start der App aufgerufen.
  /// - **Was passiert hier?**
  ///   1️⃣ Die Methode prüft, ob bereits ein gespeicherter Standort existiert.
  ///   2️⃣ Falls ja → Wird dieser Standort verwendet, um die Wetterdaten zu laden.
  ///   3️⃣ Falls nein → Wird der aktuelle Standort über GPS ermittelt.
  @override
  Future<WeatherState> build() async {
    _log.info('🔍 Lade gespeicherte Standortinformationen...');

    // 💾 Versuche, die zuletzt gespeicherte Standortinformation aus dem Speicher zu laden.
    final storedLocation = await LocationService.loadLastLocation();

    // ✅ Prüfe, ob ein gespeicherter Standort vorhanden ist.
    if (storedLocation != null) {
      _log.info('✅ Gespeicherter Standort gefunden, lade Wetterdaten...');

      // 🏙 Extrahiere die gespeicherten Informationen
      final useGeolocation =
          storedLocation['useGeolocation']; // 🌍 Wurde GPS genutzt oder ein manuell eingegebener Ort?
      final selectedCity =
          storedLocation['locationName'] ??
          'Unbekannter Ort'; // 📍 Name des gespeicherten Standorts

      // 🌤 Wetterdaten für den gespeicherten Standort abrufen
      final weatherData = await fetchWeather(
        storedLocation['latitude'], // 📌 Breitenkoordinate (Latitude)
        storedLocation['longitude'], // 📌 Längenkoordinate (Longitude)
        selectedCity, // 📍 Name des Standorts
      );

      // 🌤 Gibt den aktuellen Wetterzustand basierend auf dem gespeicherten Standort zurück.
      return WeatherState(
        selectedCity:
            selectedCity, // 📍 Setzt den aktuellen Standortnamen im State.
        useGeolocation:
            useGeolocation, // ✅ Speichert, ob GPS genutzt wurde oder nicht.
        weatherData: weatherData, // ☀️ Speichert die abgerufenen Wetterdaten.
      );
    }

    // ❗ Falls kein gespeicherter Standort existiert, müssen wir ihn neu ermitteln.
    _log.warning(
      '⚠️ Kein gespeicherter Standort gefunden, verwende aktuellen Standort...',
    );

    // 🛰️ Holt die aktuellen GPS-Koordinaten und lädt die Wetterdaten.
    return fetchWeatherForCurrentLocation();
  }

  /// 📍 Holt das Wetter für den **aktuellen Standort** des Geräts.
  /// - **Ablauf:**
  ///   1. 🛰 Holt die GPS-Koordinaten des Geräts.
  ///   2. 🏙 Wandelt die Koordinaten in einen echten Ortsnamen um.
  ///   3. 🌍 Fragt die Wetter-API mit diesen Standortdaten ab.
  ///   4. 💾 Speichert den Standort für zukünftige Abrufe.
  Future<WeatherState> fetchWeatherForCurrentLocation() async {
    try {
      _log.info('📡 Ermittle aktuellen Standort...');
      state =
          const AsyncValue.loading(); // ⏳ Setzt den UI-Status auf "Laden", um anzuzeigen, dass Daten abgerufen werden.

      // 🛰 Holt die aktuelle Position des Geräts (Latitude & Longitude).
      final position = await LocationService.determinePosition();

      // 📍 Bestimmt den Namen des Standorts anhand der Koordinaten (z. B. "Berlin, Germany").
      String locationName = await LocationService.getLocationName(
        position.latitude,
        position.longitude,
      );

      // ❗ Falls kein gültiger Standortname gefunden wurde, nutze "Aktueller Standort" als Fallback.
      if (locationName.isEmpty) {
        locationName = AppStrings.currentLocation;
        _log.warning(
          '⚠️ Standortname nicht gefunden, nutze Fallback: $locationName',
        );
      }

      // 🌍 Holt die Wetterdaten von der API für diesen Standort.
      final weatherData = await fetchWeather(
        position.latitude,
        position.longitude,
        locationName,
      );

      // 💾 Speichert den Standort in SharedPreferences für zukünftige Abrufe.
      await LocationService.saveLastLocation(
        position.latitude,
        position.longitude,
        true, // ✅ true = GPS-Koordinaten werden genutzt, nicht manuell eingegebene Stadt.
        locationName,
      );

      _log.info(
        '✅ Wetter für aktuellen Standort ($locationName) erfolgreich geladen.',
      );

      // 🌤 Gibt den aktuellen Wetterzustand zurück, inklusive Standortname & Wetterdaten.
      return WeatherState(
        selectedCity:
            locationName, // 📍 Setzt den aktuellen Standort in den State.
        useGeolocation:
            true, // ✅ Speichert, dass der Standort per GPS bestimmt wurde.
        weatherData: weatherData, // ☀️ Speichert die aktuellen Wetterdaten.
      );
    } catch (e) {
      _log.severe(
        '❌ Fehler beim Abrufen des Standorts: $e',
      ); // ❗ Fehlerprotokollierung, falls etwas schiefgeht.

      // ❗ Falls ein Fehler auftritt (z. B. keine Standortberechtigung), wird dies in der UI angezeigt.
      state = AsyncValue.error(
        'Fehler beim Abrufen des Standorts: $e',
        StackTrace.current,
      );

      // ❌ Gibt einen Fehlerzustand zurück, der in der UI behandelt werden kann.
      return WeatherState(
        errorMessage:
            'Fehler beim Abrufen des Standorts: $e', // 📢 Zeigt den Fehler in der App an.
      );
    }
  }

  /// 🌍 Holt die Wetterdaten für eine bestimmte Stadt oder einen Standort anhand von Latitude und Longitude.
  /// Diese Methode macht eine HTTP-Anfrage an die Open-Meteo API und verarbeitet die Antwort.
  Future<WeatherData> fetchWeather(
    double latitude, // 📌 Breitengrad der gewünschten Stadt oder des Standorts
    double longitude, // 📌 Längengrad der gewünschten Stadt oder des Standorts
    String
    locationName, // 📌 Der Name des Standorts (z. B. "Berlin" oder "Aktueller Standort")
  ) async {
    _log.info('🌍 Rufe Wetterdaten für $locationName ab...');

    try {
      // 📌 Führt eine GET-Anfrage an die Open-Meteo API aus, um aktuelle Wetterdaten zu erhalten.
      final response = await ref
          .read(
            httpClientProvider,
          ) // 🛠 Verwendet den HTTP-Client aus Riverpod.
          .get(
            Uri.parse(
              'https://api.open-meteo.com/v1/forecast'
              '?latitude=$latitude' // 🌍 Standort-Breitengrad (z. B. 52.52 für Berlin)
              '&longitude=$longitude' // 🌍 Standort-Längengrad (z. B. 13.4050 für Berlin)
              '&current_weather=true' // ⏳ Holt die aktuellen Wetterbedingungen (Temperatur, Wind usw.)
              '&hourly=temperature_2m,precipitation_probability' // ⏳ Stündliche Temperatur- und Regenwahrscheinlichkeit
              '&daily=temperature_2m_min,temperature_2m_max,precipitation_probability_mean,weathercode' // 📆 Holt die 7-Tage-Vorhersage mit Min-/Max-Temperatur, Regenwahrscheinlichkeit und Wettercode
              '&timezone=auto', // 🕒 Automatische Zeitzonenerkennung basierend auf dem Standort
            ),
          );

      // ✅ Überprüft, ob die API erfolgreich geantwortet hat (Statuscode 200 = OK).
      if (response.statusCode == 200) {
        // 📌 Konvertiert die API-Antwort von JSON in eine Dart-Map.
        final jsonData = json.decode(response.body);

        // 📌 Extrahiert verschiedene Wetterdaten aus der API-Antwort:
        final weatherData =
            jsonData['current_weather']; // 🌡 Aktuelle Wetterbedingungen (z. B. Temperatur)
        final hourlyData = jsonData['hourly']; // ⏳ Stündliche Wettervorhersage
        final dailyData = jsonData['daily']; // 📆 7-Tage-Vorhersage

        // 🕒 Holt die Zeitzone des Standorts (z. B. "Europe/Berlin" oder "America/Los_Angeles").
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

        // 🌍 Ein `WeatherData`-Objekt wird ertsellt, das alle wichtigen Wetterinformationen speichert.
        final weather = WeatherData(
          // 🏙 Name des Ortes (z. B. "Berlin" oder "Aktueller Standort")
          location: locationName,
          // 🌡 Temperatur in Celsius. Falls kein Wert vorhanden ist, wird 0.0 gesetzt, um Abstürze zu vermeiden.
          temperature: (weatherData['temperature'] ?? 0.0).toDouble(),
          // ⛅ Der Wettercode wird als String gespeichert.
          // Falls kein Code vorhanden ist, wird "Unbekannt" als Standardwert gesetzt.
          weatherCondition:
              (weatherData['weathercode'] ?? 'Unbekannt').toString(),
          // 🌬 Windgeschwindigkeit in km/h. Falls kein Wert vorhanden ist, wird 0.0 als Standard gesetzt.
          windSpeed: (weatherData['windspeed'] ?? 0.0).toDouble(),
          // 💧 Luftfeuchtigkeit in %. Falls kein Wert vorhanden ist, wird 0.0 als Standardwert gesetzt.
          humidity: (weatherData['relativehumidity_2m'] ?? 0.0).toDouble(),
          // 📊 Holt die Temperaturen für die nächsten Stunden, beginnend mit der aktuellen Stunde (`startIndex`).
          hourlyTemperature: hourlyTemps.sublist(startIndex),
          // 📊 Holt die Regenwahrscheinlichkeiten für die nächsten Stunden, beginnend mit der aktuellen Stunde (`startIndex`).
          hourlyRainProbabilities: hourlyRain.sublist(startIndex),
          // ⏰ Konvertiert die Liste der Zeitstempel in Strings für eine einfachere Darstellung.
          hourlyTimes:
              hourlyTimes
                  .sublist(startIndex)
                  .map((dt) => dt.toIso8601String())
                  .toList(),
          // 🌍 Speichert die Zeitzone des Ortes (z. B. "Europe/Berlin").
          timezone: timezone,
          // 📅 Speichert die tägliche Wettervorhersage (z. B. Min-/Max-Temperatur, Regenwahrscheinlichkeit)
          dailyWeather: dailyForecast,
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

  // 📌 Aktualisiert den Standort und lädt die entsprechenden Wetterdaten neu.
  void updateCity(String city) async {
    // ✅ Überprüft, ob die Stadt "Aktueller Standort" ist.
    // Falls ja, wird die Standorterkennung verwendet, anstatt einen festen Ort zu wählen.
    if (city == 'Aktueller Standort') {
      _log.info('🌍 Standort wird auf "Aktueller Standort" gesetzt...');

      // 🔄 Holt die aktuellen GPS-Koordinaten und aktualisiert das Wetter.
      await refreshWeather();
    } else {
      _log.info('📍 Standort wird auf $city gesetzt, lade Wetterdaten...');

      // 🗺 Holt die gespeicherten Koordinaten (Latitude & Longitude) der ausgewählten Stadt.
      final (lat, lon) =
          cities[city]!; // Das `!` stellt sicher, dass die Stadt existiert.

      // 🔄 Setzt den State auf "Lädt...", damit die UI während des Abrufs weiß, dass neue Daten kommen.
      state = const AsyncValue.loading();

      // 💾 Speichert die neue Stadt als Standardstandort in den lokalen Speicher,
      // damit sie beim nächsten Start direkt geladen werden kann.
      await LocationService.saveLastLocation(lat, lon, false, city);

      // 🌍 Fragt die Wetter-API nach den neuesten Wetterdaten für die neue Stadt.
      final weather = await fetchWeather(lat, lon, city);

      // ✅ Speichert die abgerufenen Wetterdaten in den `state`, damit sie in der UI angezeigt werden.
      state = AsyncValue.data(
        WeatherState(
          selectedCity: city, // Der Name der gewählten Stadt.
          useGeolocation: false, // Manuelle Standortwahl, kein GPS.
          weatherData: weather, // Die neuen Wetterdaten.
        ),
      );

      _log.info('✅ Wetterdaten für $city erfolgreich geladen.');
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
    // 🔄 Setzt den State auf "Lädt...", damit die UI während des Abrufs weiß, dass neue Daten kommen.
    state = const AsyncValue.loading();
    // 🌍 Fragt die Wetter-API nach den neuesten Wetterdaten für den aktuellen Standort.
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
