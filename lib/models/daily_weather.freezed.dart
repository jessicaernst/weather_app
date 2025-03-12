// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_weather.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DailyWeather {

 DateTime get date;// 📅 Das Datum des jeweiligen Tages (z.B. 2025-03-12)
 double get minTemp;// 🌡 Die **Minimaltemperatur** des Tages (°C)
 double get maxTemp;// 🔥 Die **Maximaltemperatur** des Tages (°C)
 double get precipitationProbability;// 🌧 Die Regenwahrscheinlichkeit (%)
 int get weatherCode;
/// Create a copy of DailyWeather
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyWeatherCopyWith<DailyWeather> get copyWith => _$DailyWeatherCopyWithImpl<DailyWeather>(this as DailyWeather, _$identity);

  /// Serializes this DailyWeather to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyWeather&&(identical(other.date, date) || other.date == date)&&(identical(other.minTemp, minTemp) || other.minTemp == minTemp)&&(identical(other.maxTemp, maxTemp) || other.maxTemp == maxTemp)&&(identical(other.precipitationProbability, precipitationProbability) || other.precipitationProbability == precipitationProbability)&&(identical(other.weatherCode, weatherCode) || other.weatherCode == weatherCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,minTemp,maxTemp,precipitationProbability,weatherCode);

@override
String toString() {
  return 'DailyWeather(date: $date, minTemp: $minTemp, maxTemp: $maxTemp, precipitationProbability: $precipitationProbability, weatherCode: $weatherCode)';
}


}

/// @nodoc
abstract mixin class $DailyWeatherCopyWith<$Res>  {
  factory $DailyWeatherCopyWith(DailyWeather value, $Res Function(DailyWeather) _then) = _$DailyWeatherCopyWithImpl;
@useResult
$Res call({
 DateTime date, double minTemp, double maxTemp, double precipitationProbability, int weatherCode
});




}
/// @nodoc
class _$DailyWeatherCopyWithImpl<$Res>
    implements $DailyWeatherCopyWith<$Res> {
  _$DailyWeatherCopyWithImpl(this._self, this._then);

  final DailyWeather _self;
  final $Res Function(DailyWeather) _then;

/// Create a copy of DailyWeather
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? minTemp = null,Object? maxTemp = null,Object? precipitationProbability = null,Object? weatherCode = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,minTemp: null == minTemp ? _self.minTemp : minTemp // ignore: cast_nullable_to_non_nullable
as double,maxTemp: null == maxTemp ? _self.maxTemp : maxTemp // ignore: cast_nullable_to_non_nullable
as double,precipitationProbability: null == precipitationProbability ? _self.precipitationProbability : precipitationProbability // ignore: cast_nullable_to_non_nullable
as double,weatherCode: null == weatherCode ? _self.weatherCode : weatherCode // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _DailyWeather extends DailyWeather {
  const _DailyWeather({required this.date, required this.minTemp, required this.maxTemp, required this.precipitationProbability, required this.weatherCode}): super._();
  factory _DailyWeather.fromJson(Map<String, dynamic> json) => _$DailyWeatherFromJson(json);

@override final  DateTime date;
// 📅 Das Datum des jeweiligen Tages (z.B. 2025-03-12)
@override final  double minTemp;
// 🌡 Die **Minimaltemperatur** des Tages (°C)
@override final  double maxTemp;
// 🔥 Die **Maximaltemperatur** des Tages (°C)
@override final  double precipitationProbability;
// 🌧 Die Regenwahrscheinlichkeit (%)
@override final  int weatherCode;

/// Create a copy of DailyWeather
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyWeatherCopyWith<_DailyWeather> get copyWith => __$DailyWeatherCopyWithImpl<_DailyWeather>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DailyWeatherToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyWeather&&(identical(other.date, date) || other.date == date)&&(identical(other.minTemp, minTemp) || other.minTemp == minTemp)&&(identical(other.maxTemp, maxTemp) || other.maxTemp == maxTemp)&&(identical(other.precipitationProbability, precipitationProbability) || other.precipitationProbability == precipitationProbability)&&(identical(other.weatherCode, weatherCode) || other.weatherCode == weatherCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,minTemp,maxTemp,precipitationProbability,weatherCode);

@override
String toString() {
  return 'DailyWeather(date: $date, minTemp: $minTemp, maxTemp: $maxTemp, precipitationProbability: $precipitationProbability, weatherCode: $weatherCode)';
}


}

/// @nodoc
abstract mixin class _$DailyWeatherCopyWith<$Res> implements $DailyWeatherCopyWith<$Res> {
  factory _$DailyWeatherCopyWith(_DailyWeather value, $Res Function(_DailyWeather) _then) = __$DailyWeatherCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, double minTemp, double maxTemp, double precipitationProbability, int weatherCode
});




}
/// @nodoc
class __$DailyWeatherCopyWithImpl<$Res>
    implements _$DailyWeatherCopyWith<$Res> {
  __$DailyWeatherCopyWithImpl(this._self, this._then);

  final _DailyWeather _self;
  final $Res Function(_DailyWeather) _then;

/// Create a copy of DailyWeather
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? minTemp = null,Object? maxTemp = null,Object? precipitationProbability = null,Object? weatherCode = null,}) {
  return _then(_DailyWeather(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,minTemp: null == minTemp ? _self.minTemp : minTemp // ignore: cast_nullable_to_non_nullable
as double,maxTemp: null == maxTemp ? _self.maxTemp : maxTemp // ignore: cast_nullable_to_non_nullable
as double,precipitationProbability: null == precipitationProbability ? _self.precipitationProbability : precipitationProbability // ignore: cast_nullable_to_non_nullable
as double,weatherCode: null == weatherCode ? _self.weatherCode : weatherCode // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
