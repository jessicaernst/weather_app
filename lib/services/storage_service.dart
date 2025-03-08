import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 📌 Logger für Debugging & Fehleranalyse
final Logger _log = Logger('StorageService');

class StorageService {
  // 🔑 Schlüssel für die gespeicherten Wetterdaten in SharedPreferences
  static const String temperatureKey = 'temperature';
  static const String weatherConditionKey = 'weatherCondition';
  static const String windSpeedKey = 'windSpeed';
  static const String humidityKey = 'humidity';

  /// 💾 **Speichert die aktuellen Wetterdaten in SharedPreferences**
  /// Falls ein Fehler auftritt, wird dies im Log erfasst
  static Future<void> saveWeatherData(
    double temperature,
    String weatherCondition,
    double windSpeed,
    double humidity,
  ) async {
    try {
      _log.info(
        '📌 Speichere Wetterdaten: Temperatur=$temperature°C, Zustand=$weatherCondition, Wind=${windSpeed}m/s, Luftfeuchtigkeit=${humidity}%',
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(temperatureKey, temperature);
      await prefs.setString(weatherConditionKey, weatherCondition);
      await prefs.setDouble(windSpeedKey, windSpeed);
      await prefs.setDouble(humidityKey, humidity);

      _log.info('✅ Wetterdaten erfolgreich gespeichert.');
    } catch (e) {
      _log.severe('❌ Fehler beim Speichern der Wetterdaten: $e');
    }
  }

  /// 🔄 **Lädt die zuletzt gespeicherten Wetterdaten aus SharedPreferences**
  /// Falls keine Daten vorhanden sind, gibt die Methode `null` zurück
  static Future<Map<String, dynamic>?> loadWeatherData() async {
    try {
      _log.info('📌 Lade gespeicherte Wetterdaten aus SharedPreferences...');

      final prefs = await SharedPreferences.getInstance();

      // Falls keine Temperatur gespeichert wurde, existieren keine Wetterdaten
      if (!prefs.containsKey(temperatureKey)) {
        _log.warning('⚠️ Keine gespeicherten Wetterdaten gefunden.');
        return null;
      }

      final temperature = prefs.getDouble(temperatureKey) ?? 0.0;
      final weatherCondition =
          prefs.getString(weatherConditionKey) ?? 'Unbekannt';
      final windSpeed = prefs.getDouble(windSpeedKey) ?? 0.0;
      final humidity = prefs.getDouble(humidityKey) ?? 0.0;

      _log.info(
        '✅ Wetterdaten geladen: Temperatur=$temperature°C, Zustand=$weatherCondition, Wind=${windSpeed}m/s, Luftfeuchtigkeit=${humidity}%',
      );

      return {
        'temperature': temperature,
        'weatherCondition': weatherCondition,
        'windSpeed': windSpeed,
        'humidity': humidity,
      };
    } catch (e) {
      _log.severe('❌ Fehler beim Laden der Wetterdaten: $e');
      return null; // Falls ein Fehler auftritt, gibt die Methode `null` zurück
    }
  }

  /// 🗑 **Löscht alle gespeicherten Wetterdaten aus SharedPreferences**
  /// Falls etwas schiefgeht, wird dies im Log erfasst
  static Future<void> clearWeatherData() async {
    try {
      _log.warning('⚠️ Lösche gespeicherte Wetterdaten...');

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(temperatureKey);
      await prefs.remove(weatherConditionKey);
      await prefs.remove(windSpeedKey);
      await prefs.remove(humidityKey);

      _log.info('✅ Gespeicherte Wetterdaten erfolgreich gelöscht.');
    } catch (e) {
      _log.severe('❌ Fehler beim Löschen der Wetterdaten: $e');
    }
  }
}
