import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_weather.freezed.dart';
part 'daily_weather.g.dart';

@freezed
abstract class DailyWeather with _$DailyWeather {
  const factory DailyWeather({
    required DateTime date,
    required double minTemp,
    required double maxTemp,
    required double precipitationProbability,
    required int weatherCode,
  }) = _DailyWeather;

  factory DailyWeather.fromJson(Map<String, dynamic> json) =>
      _$DailyWeatherFromJson(json);
}
