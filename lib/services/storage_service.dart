import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String temperatureKey = 'temperature';
  static const String weatherConditionKey = 'weatherCondition';
  static const String windSpeedKey = 'windSpeed';
  static const String humidityKey = 'humidity';

  static Future<void> saveWeatherData(
    double temperature,
    String weatherCondition,
    double windSpeed,
    double humidity,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(temperatureKey, temperature);
    await prefs.setString(weatherConditionKey, weatherCondition);
    await prefs.setDouble(windSpeedKey, windSpeed);
    await prefs.setDouble(humidityKey, humidity);
  }

  static Future<Map<String, dynamic>?> loadWeatherData() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(temperatureKey)) return null;

    return {
      'temperature': prefs.getDouble(temperatureKey) ?? 0.0,
      'weatherCondition': prefs.getString(weatherConditionKey) ?? "Unbekannt",
      'windSpeed': prefs.getDouble(windSpeedKey) ?? 0.0,
      'humidity': prefs.getDouble(humidityKey) ?? 0.0,
    };
  }

  static Future<void> clearWeatherData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
