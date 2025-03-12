// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'http_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$httpClientHash() => r'7f0620a393673068316af3b9d3fe7fff063ec774';

/// 🛠 **HTTP-Client Provider** (Code-Generated)
/// - Erstellt eine `http.Client` Instanz.
/// - Kann von anderen Services oder Repositories genutzt werden.
///
/// Copied from [httpClient].
@ProviderFor(httpClient)
final httpClientProvider = AutoDisposeProvider<http.Client>.internal(
  httpClient,
  name: r'httpClientProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$httpClientHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HttpClientRef = AutoDisposeProviderRef<http.Client>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
