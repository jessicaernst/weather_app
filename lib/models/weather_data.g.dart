// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WeatherData _$WeatherDataFromJson(Map<String, dynamic> json) => _WeatherData(
  location: json['location'] as String,
  temperature: (json['temperature'] as num).toDouble(),
  weatherCondition: json['weatherCondition'] as String,
  windSpeed: (json['windSpeed'] as num).toDouble(),
  humidity: (json['humidity'] as num).toDouble(),
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
);

Map<String, dynamic> _$WeatherDataToJson(_WeatherData instance) =>
    <String, dynamic>{
      'location': instance.location,
      'temperature': instance.temperature,
      'weatherCondition': instance.weatherCondition,
      'windSpeed': instance.windSpeed,
      'humidity': instance.humidity,
      'hourlyTemperature': instance.hourlyTemperature,
      'hourlyRainProbabilities': instance.hourlyRainProbabilities,
      'hourlyTimes': instance.hourlyTimes,
    };
