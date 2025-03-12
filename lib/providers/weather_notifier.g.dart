// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$weatherNotifierHash() => r'6a9d3a01ce162122c0037ce11ee04a98b0366b5c';

/// 🌍 **WeatherNotifier** – Verwalte den Wetterzustand (Code-Generated)
/// - Nutzt Repository & Service für API-Calls & lokale Speicherung.
/// - Aktualisiert Wetterdaten und speichert sie, falls nötig.
/// - Nutzt Riverpod für State-Management.
///
/// Copied from [WeatherNotifier].
@ProviderFor(WeatherNotifier)
final weatherNotifierProvider =
    AutoDisposeAsyncNotifierProvider<WeatherNotifier, WeatherState>.internal(
      WeatherNotifier.new,
      name: r'weatherNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$weatherNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$WeatherNotifier = AutoDisposeAsyncNotifier<WeatherState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
