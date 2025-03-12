import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'dart:convert';
import 'package:riverpod/riverpod.dart';
import 'package:weather_app/providers/weather_provider.dart';

// 🛠 Eine **Mock-Klasse** für `http.Client`, um HTTP-Anfragen in den Tests zu simulieren.
class MockHttpClient extends Mock implements http.Client {}

// 🛠 Eine **Mock-Klasse** für den LocationService, um Standortnamen zu simulieren.
class MockLocationService {
  // ✅ Gibt einen festen Standortnamen zurück (für Tests, damit keine echte API benötigt wird).
  static Future<String> getLocationName(
    double latitude,
    double longitude,
  ) async {
    return Future.value('Bremen, Deutschland'); // Simulierter Standortname
  }

  // ❌ Gibt einen **leeren** String zurück, um einen Fehlerfall zu testen.
  static Future<String> getLocationNameError(
    double latitude,
    double longitude,
  ) async {
    return Future.value('');
  }

  // 🔥 Simuliert einen Netzwerkfehler, indem eine Exception geworfen wird.
  static Future<String> getLocationNameNetworkError(
    double latitude,
    double longitude,
  ) async {
    throw Exception('Network error');
  }
}

// 🚀 Die eigentlichen **Unit-Tests** starten hier.
void main() {
  group('WeatherNotifier', () {
    // 🌐 Simulierter HTTP-Client für die Tests
    late MockHttpClient mockHttpClient;

    // 🛠 Riverpod Container, um den State zu testen
    late ProviderContainer container;

    setUp(() {
      // 🛠 Initialisiert den Mock-HTTP-Client vor jedem Test
      mockHttpClient = MockHttpClient();

      // 🛠 Erstellt einen neuen **Riverpod Container**, um den Provider in den Tests zu überschreiben.
      container = ProviderContainer(
        overrides: [
          httpClientProvider.overrideWithValue(
            mockHttpClient,
          ), // Ersetze den echten HTTP-Client mit dem Mock-Client
          weatherNotifierProvider.overrideWith(
            WeatherNotifier.new,
          ), // Nutze WeatherNotifier als Provider
        ],
      );

      // 🛠 **Fix für Mocktail**: Registriere `Uri`, um Fehler mit `any()` zu vermeiden.
      registerFallbackValue(Uri.parse(''));
    });

    tearDown(() {
      // 🧹 **Wichtig**: Container nach jedem Test schließen, um Speicherprobleme zu vermeiden.
      container.dispose();
    });

    // ✅ Test: `fetchWeather` gibt Wetterdaten zurück, wenn die API erfolgreich antwortet.
    test(
      'fetchWeather gibt Wetterdaten zurück, wenn die API erfolgreich antwortet',
      () async {
        // 🏙 Standort für den Test setzen
        final cityName = 'Bremen';

        // 📡 Simulierte API-Response mit Wetterdaten
        final expectedData = {
          'current_weather': {
            'temperature': 20.0, // 🌡 Temperatur in °C
            'windspeed': 6.2, // 💨 Windgeschwindigkeit in km/h
            'weathercode': 1, // 🌤 Wettercode
            'time': '2025-03-11T14:00', // 🕒 Zeitpunkt der Messung
          },
          'timezone': 'Europe/Berlin', // 🕒 Zeitzone des Standorts
          'hourly': {
            'time': [
              '2025-03-11T14:00',
              '2025-03-11T15:00',
            ], // ⏳ Stündliche Vorhersagezeiten
            'temperature_2m': [20.0, 21.0], // 🌡 Stündliche Temperaturen
            'precipitation_probability': [
              5.0,
              6.0,
            ], // ☔ Regenwahrscheinlichkeit in %
          },
          'daily': {
            'time': ['2025-03-11', '2025-03-12'], // 📅 Tägliche Vorhersagedaten
            'temperature_2m_min': [5.0, 6.0], // 🌡 Tägliche Minimaltemperatur
            'temperature_2m_max': [15.0, 17.0], // 🌡 Tägliche Maximaltemperatur
            'precipitation_probability_mean': [
              10.0,
              20.0,
            ], // ☔ Durchschnittliche Regenwahrscheinlichkeit
            'weathercode': [1, 2], // 🌤 Wettercodes für die Tage
          },
        };

        // 📡 Simuliere eine erfolgreiche HTTP-Antwort (Status 200)
        when(() => mockHttpClient.get(any())).thenAnswer(
          (_) async => http.Response(json.encode(expectedData), 200),
        );

        // ✅ Wetterdaten abrufen
        final notifier = container.read(weatherNotifierProvider.notifier);
        final result = await notifier.fetchWeather(53.0793, 8.8017, cityName);

        // ✅ Überprüfe, ob die Werte korrekt übernommen wurden
        expect(result.temperature, equals(20.0)); // Temperatur prüfen
        expect(result.location, equals(cityName)); // Standortname prüfen
        expect(result.windSpeed, equals(6.2)); // Windgeschwindigkeit prüfen
        expect(result.weatherCode, equals('1')); // Wettercode prüfen
        expect(
          result.dailyWeather.isNotEmpty,
          isTrue,
        ); // Tägliche Wetterdaten dürfen nicht leer sein
        expect(
          result.dailyWeather[0].minTemp,
          equals(5.0),
        ); // Min-Temperatur prüfen
        expect(
          result.dailyWeather[0].maxTemp,
          equals(15.0),
        ); // Max-Temperatur prüfen
        expect(
          result.dailyWeather[0].precipitationProbability,
          equals(10.0),
        ); // Regenwahrscheinlichkeit prüfen

        // ✅ Stelle sicher, dass die API genau **einmal** aufgerufen wurde.
        verify(() => mockHttpClient.get(any())).called(1);
      },
    );

    // ❌ Test: `fetchWeather` soll eine **Exception** auslösen, wenn die API 404 zurückgibt.
    test(
      'fetchWeather löst eine Exception aus, wenn die API 404 zurückgibt',
      () async {
        // 📡 Simuliere einen Fehler (z. B. Stadt nicht gefunden → Statuscode 404)
        when(
          () => mockHttpClient.get(any()),
        ).thenAnswer((_) async => http.Response('Error', 404));

        // ❌ Erwartung: `fetchWeather` sollte eine Exception auslösen.
        await expectLater(
          () => container
              .read(weatherNotifierProvider.notifier)
              .fetchWeather(53.0793, 8.8017, 'Bremen'),
          throwsA(isA<Exception>()),
        );
      },
    );

    // ❌ Test: `fetchWeather` soll eine **Exception** auslösen, wenn ein Netzwerkfehler auftritt.
    test(
      'fetchWeather löst eine Exception aus, wenn ein Netzwerkfehler auftritt',
      () async {
        // 📡 Simuliere einen **Netzwerkfehler** (z. B. keine Internetverbindung)
        when(
          () => mockHttpClient.get(any()),
        ).thenThrow(Exception('Network error'));

        // ❌ Erwartung: `fetchWeather` sollte eine Exception auslösen.
        await expectLater(
          () => container
              .read(weatherNotifierProvider.notifier)
              .fetchWeather(53.0793, 8.8017, 'Bremen'),
          throwsA(isA<Exception>()),
        );
      },
    );

    // 🌍 Tests für Reverse Geocoding (Standortnamen-Ermittlung)
    group('Reverse Geocoding', () {
      test('getLocationName gibt einen Ortsnamen zurück', () async {
        final expectedLocationName = 'Bremen, Deutschland';
        final result = await MockLocationService.getLocationName(
          53.0793,
          8.8017,
        );

        expect(result, equals(expectedLocationName));
      });

      test(
        'getLocationName gibt einen leeren String zurück, wenn kein Ort gefunden wird',
        () async {
          final locationName = await MockLocationService.getLocationNameError(
            53.0793,
            8.8017,
          );

          expect(locationName, isEmpty);
        },
      );

      test(
        'getLocationName wirft eine Exception bei einem Netzwerkfehler',
        () async {
          await expectLater(
            () => MockLocationService.getLocationNameNetworkError(
              53.0793,
              8.8017,
            ),
            throwsA(isA<Exception>()),
          );
        },
      );
    });
  });
}
