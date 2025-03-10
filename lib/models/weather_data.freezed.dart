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

 String get location; double get temperature; String get weatherCondition; double get windSpeed; double get humidity; List<double> get hourlyTemperature; List<double> get hourlyRainProbabilities; List<String> get hourlyTimes; String get timezone;
/// Create a copy of WeatherData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeatherDataCopyWith<WeatherData> get copyWith => _$WeatherDataCopyWithImpl<WeatherData>(this as WeatherData, _$identity);

  /// Serializes this WeatherData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeatherData&&(identical(other.location, location) || other.location == location)&&(identical(other.temperature, temperature) || other.temperature == temperature)&&(identical(other.weatherCondition, weatherCondition) || other.weatherCondition == weatherCondition)&&(identical(other.windSpeed, windSpeed) || other.windSpeed == windSpeed)&&(identical(other.humidity, humidity) || other.humidity == humidity)&&const DeepCollectionEquality().equals(other.hourlyTemperature, hourlyTemperature)&&const DeepCollectionEquality().equals(other.hourlyRainProbabilities, hourlyRainProbabilities)&&const DeepCollectionEquality().equals(other.hourlyTimes, hourlyTimes)&&(identical(other.timezone, timezone) || other.timezone == timezone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,location,temperature,weatherCondition,windSpeed,humidity,const DeepCollectionEquality().hash(hourlyTemperature),const DeepCollectionEquality().hash(hourlyRainProbabilities),const DeepCollectionEquality().hash(hourlyTimes),timezone);

@override
String toString() {
  return 'WeatherData(location: $location, temperature: $temperature, weatherCondition: $weatherCondition, windSpeed: $windSpeed, humidity: $humidity, hourlyTemperature: $hourlyTemperature, hourlyRainProbabilities: $hourlyRainProbabilities, hourlyTimes: $hourlyTimes, timezone: $timezone)';
}


}

/// @nodoc
abstract mixin class $WeatherDataCopyWith<$Res>  {
  factory $WeatherDataCopyWith(WeatherData value, $Res Function(WeatherData) _then) = _$WeatherDataCopyWithImpl;
@useResult
$Res call({
 String location, double temperature, String weatherCondition, double windSpeed, double humidity, List<double> hourlyTemperature, List<double> hourlyRainProbabilities, List<String> hourlyTimes, String timezone
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
@pragma('vm:prefer-inline') @override $Res call({Object? location = null,Object? temperature = null,Object? weatherCondition = null,Object? windSpeed = null,Object? humidity = null,Object? hourlyTemperature = null,Object? hourlyRainProbabilities = null,Object? hourlyTimes = null,Object? timezone = null,}) {
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
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _WeatherData implements WeatherData {
  const _WeatherData({required this.location, required this.temperature, required this.weatherCondition, required this.windSpeed, required this.humidity, required final  List<double> hourlyTemperature, required final  List<double> hourlyRainProbabilities, required final  List<String> hourlyTimes, required this.timezone}): _hourlyTemperature = hourlyTemperature,_hourlyRainProbabilities = hourlyRainProbabilities,_hourlyTimes = hourlyTimes;
  factory _WeatherData.fromJson(Map<String, dynamic> json) => _$WeatherDataFromJson(json);

@override final  String location;
@override final  double temperature;
@override final  String weatherCondition;
@override final  double windSpeed;
@override final  double humidity;
 final  List<double> _hourlyTemperature;
@override List<double> get hourlyTemperature {
  if (_hourlyTemperature is EqualUnmodifiableListView) return _hourlyTemperature;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_hourlyTemperature);
}

 final  List<double> _hourlyRainProbabilities;
@override List<double> get hourlyRainProbabilities {
  if (_hourlyRainProbabilities is EqualUnmodifiableListView) return _hourlyRainProbabilities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_hourlyRainProbabilities);
}

 final  List<String> _hourlyTimes;
@override List<String> get hourlyTimes {
  if (_hourlyTimes is EqualUnmodifiableListView) return _hourlyTimes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_hourlyTimes);
}

@override final  String timezone;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeatherData&&(identical(other.location, location) || other.location == location)&&(identical(other.temperature, temperature) || other.temperature == temperature)&&(identical(other.weatherCondition, weatherCondition) || other.weatherCondition == weatherCondition)&&(identical(other.windSpeed, windSpeed) || other.windSpeed == windSpeed)&&(identical(other.humidity, humidity) || other.humidity == humidity)&&const DeepCollectionEquality().equals(other._hourlyTemperature, _hourlyTemperature)&&const DeepCollectionEquality().equals(other._hourlyRainProbabilities, _hourlyRainProbabilities)&&const DeepCollectionEquality().equals(other._hourlyTimes, _hourlyTimes)&&(identical(other.timezone, timezone) || other.timezone == timezone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,location,temperature,weatherCondition,windSpeed,humidity,const DeepCollectionEquality().hash(_hourlyTemperature),const DeepCollectionEquality().hash(_hourlyRainProbabilities),const DeepCollectionEquality().hash(_hourlyTimes),timezone);

@override
String toString() {
  return 'WeatherData(location: $location, temperature: $temperature, weatherCondition: $weatherCondition, windSpeed: $windSpeed, humidity: $humidity, hourlyTemperature: $hourlyTemperature, hourlyRainProbabilities: $hourlyRainProbabilities, hourlyTimes: $hourlyTimes, timezone: $timezone)';
}


}

/// @nodoc
abstract mixin class _$WeatherDataCopyWith<$Res> implements $WeatherDataCopyWith<$Res> {
  factory _$WeatherDataCopyWith(_WeatherData value, $Res Function(_WeatherData) _then) = __$WeatherDataCopyWithImpl;
@override @useResult
$Res call({
 String location, double temperature, String weatherCondition, double windSpeed, double humidity, List<double> hourlyTemperature, List<double> hourlyRainProbabilities, List<String> hourlyTimes, String timezone
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
@override @pragma('vm:prefer-inline') $Res call({Object? location = null,Object? temperature = null,Object? weatherCondition = null,Object? windSpeed = null,Object? humidity = null,Object? hourlyTemperature = null,Object? hourlyRainProbabilities = null,Object? hourlyTimes = null,Object? timezone = null,}) {
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
as String,
  ));
}


}

// dart format on
