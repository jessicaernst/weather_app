import 'package:freezed_annotation/freezed_annotation.dart';

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
  }) = _WeatherData;

  factory WeatherData.fromJson(Map<String, dynamic> json) =>
      _$WeatherDataFromJson(json);
}
