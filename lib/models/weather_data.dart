import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:weather_app/models/daily_weather.dart';

part 'weather_data.freezed.dart';
part 'weather_data.g.dart';

@freezed
abstract class WeatherData with _$WeatherData {
  const factory WeatherData({
    required String location,
    required double temperature,
    required String weatherCondition,
    required double windSpeed,
    required double humidity,
    required List<double> hourlyTemperature,
    required List<double> hourlyRainProbabilities,
    required List<String> hourlyTimes,
    required String timezone,
    required List<DailyWeather> dailyWeather,
  }) = _WeatherData;

  factory WeatherData.fromJson(Map<String, dynamic> json) =>
      _$WeatherDataFromJson(json);
}
