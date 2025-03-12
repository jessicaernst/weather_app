import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:weather_app/services/weather_service.dart';

part 'service_provider.g.dart'; // 🚀 Automatisch generiert

/// 🛠 **WeatherService Provider** (Code-Generated)
/// - Erstellt eine Instanz von `WeatherService`.
@riverpod
WeatherService weatherService(Ref ref) {
  return WeatherService();
}
