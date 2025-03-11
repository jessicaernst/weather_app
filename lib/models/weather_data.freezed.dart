// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weather_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WeatherData {

 String get location;// 📍 Name des Standorts (z.B. "Berlin, Deutschland")
 double get temperature;// 🌡 Aktuelle Temperatur in °C
 String get weatherCondition;// 🌤 Beschreibung des aktuellen Wetters ("Bewölkt", "Sonnig", etc.)
 double get windSpeed;// 💨 Windgeschwindigkeit in km/h
 double get humidity;// 💦 Luftfeuchtigkeit in %
// 📌 Stündliche Vorhersagewerte (für die nächsten 24 Stunden)
 List<double> get hourlyTemperature;// 🌡 Temperaturen pro Stunde (Liste von °C-Werten)
 List<double> get hourlyRainProbabilities;// 🌧 Regenwahrscheinlichkeit pro Stunde (%)
 List<String> get hourlyTimes;// ⏰ Zeitpunkte für die stündlichen Werte (z.B. ["10:00", "11:00", ...])
 String get timezone;// 🌍 Zeitzone des Standorts (z.B. "Europe/Berlin")
// 🔥 7-Tage-Vorhersage (Liste von DailyWeather-Objekten, siehe `daily_weather.dart`)
 List<DailyWeather> get dailyWeather;
/// Create a copy of WeatherData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeatherDataCopyWith<WeatherData> get copyWith => _$WeatherDataCopyWithImpl<WeatherData>(this as WeatherData, _$identity);

  /// Serializes this WeatherData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeatherData&&(identical(other.location, location) || other.location == location)&&(identical(other.temperature, temperature) || other.temperature == temperature)&&(identical(other.weatherCondition, weatherCondition) || other.weatherCondition == weatherCondition)&&(identical(other.windSpeed, windSpeed) || other.windSpeed == windSpeed)&&(identical(other.humidity, humidity) || other.humidity == humidity)&&const DeepCollectionEquality().equals(other.hourlyTemperature, hourlyTemperature)&&const DeepCollectionEquality().equals(other.hourlyRainProbabilities, hourlyRainProbabilities)&&const DeepCollectionEquality().equals(other.hourlyTimes, hourlyTimes)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&const DeepCollectionEquality().equals(other.dailyWeather, dailyWeather));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,location,temperature,weatherCondition,windSpeed,humidity,const DeepCollectionEquality().hash(hourlyTemperature),const DeepCollectionEquality().hash(hourlyRainProbabilities),const DeepCollectionEquality().hash(hourlyTimes),timezone,const DeepCollectionEquality().hash(dailyWeather));

@override
String toString() {
  return 'WeatherData(location: $location, temperature: $temperature, weatherCondition: $weatherCondition, windSpeed: $windSpeed, humidity: $humidity, hourlyTemperature: $hourlyTemperature, hourlyRainProbabilities: $hourlyRainProbabilities, hourlyTimes: $hourlyTimes, timezone: $timezone, dailyWeather: $dailyWeather)';
}


}

/// @nodoc
abstract mixin class $WeatherDataCopyWith<$Res>  {
  factory $WeatherDataCopyWith(WeatherData value, $Res Function(WeatherData) _then) = _$WeatherDataCopyWithImpl;
@useResult
$Res call({
 String location, double temperature, String weatherCondition, double windSpeed, double humidity, List<double> hourlyTemperature, List<double> hourlyRainProbabilities, List<String> hourlyTimes, String timezone, List<DailyWeather> dailyWeather
});




}
/// @nodoc
class _$WeatherDataCopyWithImpl<$Res>
    implements $WeatherDataCopyWith<$Res> {
  _$WeatherDataCopyWithImpl(this._self, this._then);

  final WeatherData _self;
  final $Res Function(WeatherData) _then;

/// Create a copy of WeatherData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? location = null,Object? temperature = null,Object? weatherCondition = null,Object? windSpeed = null,Object? humidity = null,Object? hourlyTemperature = null,Object? hourlyRainProbabilities = null,Object? hourlyTimes = null,Object? timezone = null,Object? dailyWeather = null,}) {
  return _then(_self.copyWith(
location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,temperature: null == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as double,weatherCondition: null == weatherCondition ? _self.weatherCondition : weatherCondition // ignore: cast_nullable_to_non_nullable
as String,windSpeed: null == windSpeed ? _self.windSpeed : windSpeed // ignore: cast_nullable_to_non_nullable
as double,humidity: null == humidity ? _self.humidity : humidity // ignore: cast_nullable_to_non_nullable
as double,hourlyTemperature: null == hourlyTemperature ? _self.hourlyTemperature : hourlyTemperature // ignore: cast_nullable_to_non_nullable
as List<double>,hourlyRainProbabilities: null == hourlyRainProbabilities ? _self.hourlyRainProbabilities : hourlyRainProbabilities // ignore: cast_nullable_to_non_nullable
as List<double>,hourlyTimes: null == hourlyTimes ? _self.hourlyTimes : hourlyTimes // ignore: cast_nullable_to_non_nullable
as List<String>,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,dailyWeather: null == dailyWeather ? _self.dailyWeather : dailyWeather // ignore: cast_nullable_to_non_nullable
as List<DailyWeather>,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _WeatherData implements WeatherData {
  const _WeatherData({required this.location, required this.temperature, required this.weatherCondition, required this.windSpeed, required this.humidity, required final  List<double> hourlyTemperature, required final  List<double> hourlyRainProbabilities, required final  List<String> hourlyTimes, required this.timezone, required final  List<DailyWeather> dailyWeather}): _hourlyTemperature = hourlyTemperature,_hourlyRainProbabilities = hourlyRainProbabilities,_hourlyTimes = hourlyTimes,_dailyWeather = dailyWeather;
  factory _WeatherData.fromJson(Map<String, dynamic> json) => _$WeatherDataFromJson(json);

@override final  String location;
// 📍 Name des Standorts (z.B. "Berlin, Deutschland")
@override final  double temperature;
// 🌡 Aktuelle Temperatur in °C
@override final  String weatherCondition;
// 🌤 Beschreibung des aktuellen Wetters ("Bewölkt", "Sonnig", etc.)
@override final  double windSpeed;
// 💨 Windgeschwindigkeit in km/h
@override final  double humidity;
// 💦 Luftfeuchtigkeit in %
// 📌 Stündliche Vorhersagewerte (für die nächsten 24 Stunden)
 final  List<double> _hourlyTemperature;
// 💦 Luftfeuchtigkeit in %
// 📌 Stündliche Vorhersagewerte (für die nächsten 24 Stunden)
@override List<double> get hourlyTemperature {
  if (_hourlyTemperature is EqualUnmodifiableListView) return _hourlyTemperature;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_hourlyTemperature);
}

// 🌡 Temperaturen pro Stunde (Liste von °C-Werten)
 final  List<double> _hourlyRainProbabilities;
// 🌡 Temperaturen pro Stunde (Liste von °C-Werten)
@override List<double> get hourlyRainProbabilities {
  if (_hourlyRainProbabilities is EqualUnmodifiableListView) return _hourlyRainProbabilities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_hourlyRainProbabilities);
}

// 🌧 Regenwahrscheinlichkeit pro Stunde (%)
 final  List<String> _hourlyTimes;
// 🌧 Regenwahrscheinlichkeit pro Stunde (%)
@override List<String> get hourlyTimes {
  if (_hourlyTimes is EqualUnmodifiableListView) return _hourlyTimes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_hourlyTimes);
}

// ⏰ Zeitpunkte für die stündlichen Werte (z.B. ["10:00", "11:00", ...])
@override final  String timezone;
// 🌍 Zeitzone des Standorts (z.B. "Europe/Berlin")
// 🔥 7-Tage-Vorhersage (Liste von DailyWeather-Objekten, siehe `daily_weather.dart`)
 final  List<DailyWeather> _dailyWeather;
// 🌍 Zeitzone des Standorts (z.B. "Europe/Berlin")
// 🔥 7-Tage-Vorhersage (Liste von DailyWeather-Objekten, siehe `daily_weather.dart`)
@override List<DailyWeather> get dailyWeather {
  if (_dailyWeather is EqualUnmodifiableListView) return _dailyWeather;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dailyWeather);
}


/// Create a copy of WeatherData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeatherDataCopyWith<_WeatherData> get copyWith => __$WeatherDataCopyWithImpl<_WeatherData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeatherDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeatherData&&(identical(other.location, location) || other.location == location)&&(identical(other.temperature, temperature) || other.temperature == temperature)&&(identical(other.weatherCondition, weatherCondition) || other.weatherCondition == weatherCondition)&&(identical(other.windSpeed, windSpeed) || other.windSpeed == windSpeed)&&(identical(other.humidity, humidity) || other.humidity == humidity)&&const DeepCollectionEquality().equals(other._hourlyTemperature, _hourlyTemperature)&&const DeepCollectionEquality().equals(other._hourlyRainProbabilities, _hourlyRainProbabilities)&&const DeepCollectionEquality().equals(other._hourlyTimes, _hourlyTimes)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&const DeepCollectionEquality().equals(other._dailyWeather, _dailyWeather));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,location,temperature,weatherCondition,windSpeed,humidity,const DeepCollectionEquality().hash(_hourlyTemperature),const DeepCollectionEquality().hash(_hourlyRainProbabilities),const DeepCollectionEquality().hash(_hourlyTimes),timezone,const DeepCollectionEquality().hash(_dailyWeather));

@override
String toString() {
  return 'WeatherData(location: $location, temperature: $temperature, weatherCondition: $weatherCondition, windSpeed: $windSpeed, humidity: $humidity, hourlyTemperature: $hourlyTemperature, hourlyRainProbabilities: $hourlyRainProbabilities, hourlyTimes: $hourlyTimes, timezone: $timezone, dailyWeather: $dailyWeather)';
}


}

/// @nodoc
abstract mixin class _$WeatherDataCopyWith<$Res> implements $WeatherDataCopyWith<$Res> {
  factory _$WeatherDataCopyWith(_WeatherData value, $Res Function(_WeatherData) _then) = __$WeatherDataCopyWithImpl;
@override @useResult
$Res call({
 String location, double temperature, String weatherCondition, double windSpeed, double humidity, List<double> hourlyTemperature, List<double> hourlyRainProbabilities, List<String> hourlyTimes, String timezone, List<DailyWeather> dailyWeather
});




}
/// @nodoc
class __$WeatherDataCopyWithImpl<$Res>
    implements _$WeatherDataCopyWith<$Res> {
  __$WeatherDataCopyWithImpl(this._self, this._then);

  final _WeatherData _self;
  final $Res Function(_WeatherData) _then;

/// Create a copy of WeatherData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? location = null,Object? temperature = null,Object? weatherCondition = null,Object? windSpeed = null,Object? humidity = null,Object? hourlyTemperature = null,Object? hourlyRainProbabilities = null,Object? hourlyTimes = null,Object? timezone = null,Object? dailyWeather = null,}) {
  return _then(_WeatherData(
location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,temperature: null == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as double,weatherCondition: null == weatherCondition ? _self.weatherCondition : weatherCondition // ignore: cast_nullable_to_non_nullable
as String,windSpeed: null == windSpeed ? _self.windSpeed : windSpeed // ignore: cast_nullable_to_non_nullable
as double,humidity: null == humidity ? _self.humidity : humidity // ignore: cast_nullable_to_non_nullable
as double,hourlyTemperature: null == hourlyTemperature ? _self._hourlyTemperature : hourlyTemperature // ignore: cast_nullable_to_non_nullable
as List<double>,hourlyRainProbabilities: null == hourlyRainProbabilities ? _self._hourlyRainProbabilities : hourlyRainProbabilities // ignore: cast_nullable_to_non_nullable
as List<double>,hourlyTimes: null == hourlyTimes ? _self._hourlyTimes : hourlyTimes // ignore: cast_nullable_to_non_nullable
as List<String>,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,dailyWeather: null == dailyWeather ? _self._dailyWeather : dailyWeather // ignore: cast_nullable_to_non_nullable
as List<DailyWeather>,
  ));
}


}

// dart format on
