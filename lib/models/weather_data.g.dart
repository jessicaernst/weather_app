// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WeatherData _$WeatherDataFromJson(Map<String, dynamic> json) => _WeatherData(
  location: json['location'] as String,
  temperature: (json['temperature'] as num).toDouble(),
  weatherCode: (json['weatherCode'] as num).toInt(),
  windSpeed: (json['windSpeed'] as num).toDouble(),
  hourlyTemperature:
      (json['hourlyTemperature'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
  hourlyRainProbabilities:
      (json['hourlyRainProbabilities'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
  hourlyTimes:
      (json['hourlyTimes'] as List<dynamic>).map((e) => e as String).toList(),
  utcOffsetSeconds: (json['utcOffsetSeconds'] as num).toInt(),
  timezone: json['timezone'] as String,
  dailyWeather:
      (json['dailyWeather'] as List<dynamic>)
          .map((e) => DailyWeather.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$WeatherDataToJson(_WeatherData instance) =>
    <String, dynamic>{
      'location': instance.location,
      'temperature': instance.temperature,
      'weatherCode': instance.weatherCode,
      'windSpeed': instance.windSpeed,
      'hourlyTemperature': instance.hourlyTemperature,
      'hourlyRainProbabilities': instance.hourlyRainProbabilities,
      'hourlyTimes': instance.hourlyTimes,
      'utcOffsetSeconds': instance.utcOffsetSeconds,
      'timezone': instance.timezone,
      'dailyWeather': instance.dailyWeather,
    };
