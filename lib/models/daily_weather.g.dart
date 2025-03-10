// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_weather.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DailyWeather _$DailyWeatherFromJson(Map<String, dynamic> json) =>
    _DailyWeather(
      date: DateTime.parse(json['date'] as String),
      minTemp: (json['minTemp'] as num).toDouble(),
      maxTemp: (json['maxTemp'] as num).toDouble(),
      precipitationProbability:
          (json['precipitationProbability'] as num).toDouble(),
      weatherCode: (json['weatherCode'] as num).toInt(),
    );

Map<String, dynamic> _$DailyWeatherToJson(_DailyWeather instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'minTemp': instance.minTemp,
      'maxTemp': instance.maxTemp,
      'precipitationProbability': instance.precipitationProbability,
      'weatherCode': instance.weatherCode,
    };
