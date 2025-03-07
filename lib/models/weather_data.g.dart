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
);

Map<String, dynamic> _$WeatherDataToJson(_WeatherData instance) =>
    <String, dynamic>{
      'location': instance.location,
      'temperature': instance.temperature,
      'weatherCondition': instance.weatherCondition,
      'windSpeed': instance.windSpeed,
      'humidity': instance.humidity,
    };
