import 'package:freezed_annotation/freezed_annotation.dart';
import 'weather_data.dart';

part 'weather_state.freezed.dart';

@freezed
abstract class WeatherState with _$WeatherState {
  const factory WeatherState({
    @Default('Aktueller Standort') String selectedCity,
    @Default(true) bool useGeolocation,
    WeatherData? weatherData,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _WeatherState;
}
