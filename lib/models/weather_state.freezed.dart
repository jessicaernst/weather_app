// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weather_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WeatherState {

 String get selectedCity; bool get useGeolocation; WeatherData? get weatherData; bool get isLoading; String? get errorMessage;
/// Create a copy of WeatherState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeatherStateCopyWith<WeatherState> get copyWith => _$WeatherStateCopyWithImpl<WeatherState>(this as WeatherState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeatherState&&(identical(other.selectedCity, selectedCity) || other.selectedCity == selectedCity)&&(identical(other.useGeolocation, useGeolocation) || other.useGeolocation == useGeolocation)&&(identical(other.weatherData, weatherData) || other.weatherData == weatherData)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,selectedCity,useGeolocation,weatherData,isLoading,errorMessage);

@override
String toString() {
  return 'WeatherState(selectedCity: $selectedCity, useGeolocation: $useGeolocation, weatherData: $weatherData, isLoading: $isLoading, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $WeatherStateCopyWith<$Res>  {
  factory $WeatherStateCopyWith(WeatherState value, $Res Function(WeatherState) _then) = _$WeatherStateCopyWithImpl;
@useResult
$Res call({
 String selectedCity, bool useGeolocation, WeatherData? weatherData, bool isLoading, String? errorMessage
});


$WeatherDataCopyWith<$Res>? get weatherData;

}
/// @nodoc
class _$WeatherStateCopyWithImpl<$Res>
    implements $WeatherStateCopyWith<$Res> {
  _$WeatherStateCopyWithImpl(this._self, this._then);

  final WeatherState _self;
  final $Res Function(WeatherState) _then;

/// Create a copy of WeatherState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? selectedCity = null,Object? useGeolocation = null,Object? weatherData = freezed,Object? isLoading = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
selectedCity: null == selectedCity ? _self.selectedCity : selectedCity // ignore: cast_nullable_to_non_nullable
as String,useGeolocation: null == useGeolocation ? _self.useGeolocation : useGeolocation // ignore: cast_nullable_to_non_nullable
as bool,weatherData: freezed == weatherData ? _self.weatherData : weatherData // ignore: cast_nullable_to_non_nullable
as WeatherData?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of WeatherState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeatherDataCopyWith<$Res>? get weatherData {
    if (_self.weatherData == null) {
    return null;
  }

  return $WeatherDataCopyWith<$Res>(_self.weatherData!, (value) {
    return _then(_self.copyWith(weatherData: value));
  });
}
}


/// @nodoc


class _WeatherState implements WeatherState {
  const _WeatherState({this.selectedCity = 'Aktueller Standort', this.useGeolocation = true, this.weatherData, this.isLoading = false, this.errorMessage});
  

@override@JsonKey() final  String selectedCity;
@override@JsonKey() final  bool useGeolocation;
@override final  WeatherData? weatherData;
@override@JsonKey() final  bool isLoading;
@override final  String? errorMessage;

/// Create a copy of WeatherState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeatherStateCopyWith<_WeatherState> get copyWith => __$WeatherStateCopyWithImpl<_WeatherState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeatherState&&(identical(other.selectedCity, selectedCity) || other.selectedCity == selectedCity)&&(identical(other.useGeolocation, useGeolocation) || other.useGeolocation == useGeolocation)&&(identical(other.weatherData, weatherData) || other.weatherData == weatherData)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,selectedCity,useGeolocation,weatherData,isLoading,errorMessage);

@override
String toString() {
  return 'WeatherState(selectedCity: $selectedCity, useGeolocation: $useGeolocation, weatherData: $weatherData, isLoading: $isLoading, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$WeatherStateCopyWith<$Res> implements $WeatherStateCopyWith<$Res> {
  factory _$WeatherStateCopyWith(_WeatherState value, $Res Function(_WeatherState) _then) = __$WeatherStateCopyWithImpl;
@override @useResult
$Res call({
 String selectedCity, bool useGeolocation, WeatherData? weatherData, bool isLoading, String? errorMessage
});


@override $WeatherDataCopyWith<$Res>? get weatherData;

}
/// @nodoc
class __$WeatherStateCopyWithImpl<$Res>
    implements _$WeatherStateCopyWith<$Res> {
  __$WeatherStateCopyWithImpl(this._self, this._then);

  final _WeatherState _self;
  final $Res Function(_WeatherState) _then;

/// Create a copy of WeatherState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? selectedCity = null,Object? useGeolocation = null,Object? weatherData = freezed,Object? isLoading = null,Object? errorMessage = freezed,}) {
  return _then(_WeatherState(
selectedCity: null == selectedCity ? _self.selectedCity : selectedCity // ignore: cast_nullable_to_non_nullable
as String,useGeolocation: null == useGeolocation ? _self.useGeolocation : useGeolocation // ignore: cast_nullable_to_non_nullable
as bool,weatherData: freezed == weatherData ? _self.weatherData : weatherData // ignore: cast_nullable_to_non_nullable
as WeatherData?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of WeatherState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeatherDataCopyWith<$Res>? get weatherData {
    if (_self.weatherData == null) {
    return null;
  }

  return $WeatherDataCopyWith<$Res>(_self.weatherData!, (value) {
    return _then(_self.copyWith(weatherData: value));
  });
}
}

// dart format on
