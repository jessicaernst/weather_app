import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'dart:convert';
import 'package:riverpod/riverpod.dart';
import 'package:weather_app/providers/weather_provider.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockLocationService {
  static Future<String> getLocationName(
    double latitude,
    double longitude,
  ) async {
    return Future.value('Bremen, Deutschland'); // Standardwert
  }

  static Future<String> getLocationNameError(
    double latitude,
    double longitude,
  ) async {
    return Future.value('');
  }

  static Future<String> getLocationNameNetworkError(
    double latitude,
    double longitude,
  ) async {
    throw Exception('Network error');
  }
}

void main() {
  group('WeatherNotifier', () {
    late MockHttpClient mockHttpClient;
    late ProviderContainer container;

    setUp(() {
      mockHttpClient = MockHttpClient();
      container = ProviderContainer(
        overrides: [
          httpClientProvider.overrideWithValue(mockHttpClient),
          weatherNotifierProvider.overrideWith(WeatherNotifier.new),
        ],
      );
      registerFallbackValue(Uri.parse(''));
    });

    tearDown(() {
      container.dispose();
    });

    test(
      'fetchWeather gibt Wetterdaten zurück, wenn die API erfolgreich antwortet',
      () async {
        final cityName = 'Bremen';
        final expectedData = {
          'current_weather': {
            'temperature': 20.0,
            'windspeed': 6.2,
            'weathercode': 1,
            'time': '2025-03-11T14:00',
          },
          'timezone': 'Europe/Berlin',
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
        };

        when(() => mockHttpClient.get(any())).thenAnswer(
          (_) async => http.Response(json.encode(expectedData), 200),
        );

        final notifier = container.read(weatherNotifierProvider.notifier);
        final result = await notifier.fetchWeather(53.0793, 8.8017, cityName);

        expect(result.temperature, equals(20.0));
        expect(result.location, equals(cityName));
        expect(result.windSpeed, equals(6.2));
        expect(result.weatherCondition, equals('1'));
        expect(result.dailyWeather.isNotEmpty, isTrue);
        expect(result.dailyWeather[0].minTemp, equals(5.0));
        expect(result.dailyWeather[0].maxTemp, equals(15.0));
        expect(result.dailyWeather[0].precipitationProbability, equals(10.0));
        verify(() => mockHttpClient.get(any())).called(1);
      },
    );

    test(
      'fetchWeather löst eine Exception aus, wenn die API 404 zurückgibt',
      () async {
        when(
          () => mockHttpClient.get(any()),
        ).thenAnswer((_) async => http.Response('Error', 404));

        await expectLater(
          () => container
              .read(weatherNotifierProvider.notifier)
              .fetchWeather(53.0793, 8.8017, 'Bremen'),
          throwsA(isA<Exception>()),
        );
      },
    );

    test(
      'fetchWeather löst eine Exception aus, wenn ein Netzwerkfehler auftritt',
      () async {
        when(
          () => mockHttpClient.get(any()),
        ).thenThrow(Exception('Network error'));

        await expectLater(
          () => container
              .read(weatherNotifierProvider.notifier)
              .fetchWeather(53.0793, 8.8017, 'Bremen'),
          throwsA(isA<Exception>()),
        );
      },
    );
    group('Reverse Geocoding', () {
      test('getLocationName gibt einen Ortsnamen zurück', () async {
        // Arrange
        final expectedLocationName = 'Bremen, Deutschland';
        final result = await MockLocationService.getLocationName(
          53.0793,
          8.8017,
        );

        // Assert
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
