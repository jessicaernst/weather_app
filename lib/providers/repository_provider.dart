import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:weather_app/repositories/weather_repository.dart';
import 'package:weather_app/providers/http_provider.dart';

part 'repository_provider.g.dart'; // 🚀 Automatisch generiert

/// 🛠 **WeatherRepository Provider** (Code-Generated)
/// - Erstellt eine Instanz von `WeatherRepository` mit `httpClient`.
@riverpod
WeatherRepository weatherRepository(Ref ref) {
  final client = ref.watch(httpClientProvider);
  return WeatherRepository(client: client);
}
