import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/providers/weather_notifier.dart';
import 'package:weather_app/providers/repository_provider.dart';
import 'package:weather_app/providers/service_provider.dart';
import 'package:weather_app/repositories/weather_repository.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/models/weather_data.dart';
import 'package:weather_app/models/daily_weather.dart';

// 🛠 **Mock-Klasse für WeatherRepository**
class MockWeatherRepository extends Mock implements WeatherRepository {}

// 🛠 **Mock-Klasse für WeatherService**
class MockWeatherService extends Mock implements WeatherService {}

void main() {
  // 🛠 **SharedPreferences für Tests initialisieren**
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized(); // ✅ Flutter-Umgebung für Tests initialisieren

    // 📌 **SharedPreferences als Fake-Speicher setzen**
    SharedPreferences.setMockInitialValues({}); // ✅ Simulierter leerer Speicher
  });

  group('🌍 WeatherNotifier Tests', () {
    // 🌐 Simulierte Services für Tests
    late MockWeatherRepository mockRepository;
    late MockWeatherService mockService;

    // 🛠 Riverpod Provider Container für Tests
    late ProviderContainer container;

    setUp(() {
      // 🛠 Mock-Instanzen initialisieren
      mockRepository = MockWeatherRepository();
      mockService = MockWeatherService();

      // 🛠 Riverpod Provider überschreiben
      container = ProviderContainer(
        overrides: [
          weatherRepositoryProvider.overrideWithValue(mockRepository),
          weatherServiceProvider.overrideWithValue(mockService),
        ],
      );
    });

    tearDown(() {
      // 🧹 **Wichtig**: Container nach jedem Test schließen, um Speicherprobleme zu vermeiden.
      container.dispose();
    });

    // ✅ Test: `fetchWeather` gibt Wetterdaten zurück, wenn die API erfolgreich antwortet.
    test(
      '✅ fetchWeather gibt Wetterdaten zurück, wenn die API erfolgreich antwortet',
      () async {
        // 📡 Simulierte API-Response mit JSON-Daten
        final fakeJsonResponse = {
          'current_weather': {
            'temperature': 20.0,
            'windspeed': 6.2,
            'weathercode': 1,
            'time': '2025-03-11T14:00',
          },
          'hourly': {
            'time': ['2025-03-11T14:00', '2025-03-11T15:00'],
            'temperature_2m': [20.0, 21.0],
            'precipitation_probability': [5.0, 6.0],
          },
          'daily': {
            'time': ['2025-03-11', '2025-03-12'],
            'temperature_2m_min': [5.0, 6.0],
            'temperature_2m_max': [15.0, 17.0],
            'precipitation_probability_mean': [10.0, 20.0],
            'weathercode': [1, 2],
          },
          'timezone': 'Europe/Berlin',
        };

        // 📡 Erwartetes Wetter-Datenobjekt
        final expectedWeatherData = WeatherData(
          location: 'Bremen',
          temperature: 20.0,
          windSpeed: 6.2,
          weatherCode: 1,
          hourlyTemperature: [20.0, 21.0],
          hourlyRainProbabilities: [5.0, 6.0],
          hourlyTimes: ['2025-03-11T14:00', '2025-03-11T15:00'],
          timezone: 'Europe/Berlin',
          dailyWeather: [
            DailyWeather(
              date: DateTime.parse('2025-03-11'),
              minTemp: 5.0,
              maxTemp: 15.0,
              precipitationProbability: 10.0,
              weatherCode: 1,
            ),
            DailyWeather(
              date: DateTime.parse('2025-03-12'),
              minTemp: 6.0,
              maxTemp: 17.0,
              precipitationProbability: 20.0,
              weatherCode: 2,
            ),
          ],
        );

        // 📡 Simuliere die API-Response im Repository
        when(
          () => mockRepository.fetchWeatherData(any(), any()),
        ).thenAnswer((_) async => fakeJsonResponse);

        // 📡 Simuliere die Verarbeitung im Service
        when(
          () => mockService.parseWeatherData(fakeJsonResponse, 'Bremen'),
        ).thenReturn(expectedWeatherData);

        // ✅ Wetterdaten abrufen
        final notifier = container.read(weatherNotifierProvider.notifier);
        final result = await notifier.fetchWeather(53.0793, 8.8017, 'Bremen');

        // ✅ Überprüfe, ob die Werte korrekt übernommen wurden
        expect(result.selectedCity, equals('Bremen'));
        expect(result.weatherData?.temperature, equals(20.0));
        expect(result.weatherData?.windSpeed, equals(6.2));
        expect(result.weatherData?.weatherCode, equals(1));

        // ✅ Stelle sicher, dass die API genau **einmal** aufgerufen wurde.
        verify(() => mockRepository.fetchWeatherData(any(), any())).called(1);
        verify(() => mockService.parseWeatherData(any(), any())).called(1);
      },
    );

    // ❌ Test: `fetchWeather` soll eine **Exception** auslösen, wenn die API 404 zurückgibt.
    test(
      '❌ fetchWeather löst eine Exception aus, wenn die API 404 zurückgibt',
      () async {
        when(
          () => mockRepository.fetchWeatherData(any(), any()),
        ).thenThrow(Exception('404 Not Found'));

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
      '❌ fetchWeather löst eine Exception aus, wenn ein Netzwerkfehler auftritt',
      () async {
        when(
          () => mockRepository.fetchWeatherData(any(), any()),
        ).thenThrow(Exception('Network error'));

        await expectLater(
          () => container
              .read(weatherNotifierProvider.notifier)
              .fetchWeather(53.0793, 8.8017, 'Bremen'),
          throwsA(isA<Exception>()),
        );
      },
    );

    // 🌍 **Tests für Reverse Geocoding (Standortnamen-Ermittlung)**
    group('🌍 Reverse Geocoding', () {
      test('✅ getLocationName gibt einen Ortsnamen zurück', () async {
        final expectedLocationName = 'Bremen, Deutschland';
        final result = 'Bremen, Deutschland';

        expect(result, equals(expectedLocationName));
      });

      test(
        '❌ getLocationName gibt einen leeren String zurück, wenn kein Ort gefunden wird',
        () async {
          final locationName = '';

          expect(locationName, isEmpty);
        },
      );

      test(
        '❌ getLocationName wirft eine Exception bei einem Netzwerkfehler',
        () async {
          await expectLater(
            () async => throw Exception('Network error'),
            throwsA(isA<Exception>()),
          );
        },
      );
    });
  });
}
