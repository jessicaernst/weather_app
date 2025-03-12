import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

// 📌 Logger für Debugging-Zwecke
final Logger _log = Logger('WeatherRepository');

/// 🏗 **WeatherRepository** – Diese Klasse führt die HTTP-Requests aus.
/// - Sie ist für die **Kommunikation mit der API** verantwortlich.
/// - Sie verwendet einen **HTTP-Client**, um die Anfragen zu senden.
class WeatherRepository {
  /// 📌 **Konstruktor** – Erzeugt eine Instanz des `WeatherRepository`
  WeatherRepository({required this.client});

  final http.Client client; // 📌 HTTP-Client für API-Anfragen

  /// 🌍 **Holt Wetterdaten von Open-Meteo für eine bestimmte Koordinate.**
  /// - **Parameter:**
  ///   - `latitude` → Breitengrad des Standorts.
  ///   - `longitude` → Längengrad des Standorts.
  /// - **Rückgabe:** Map mit den Wetterdaten (`current_weather`, `hourly`, `daily`).
  Future<Map<String, dynamic>> fetchWeatherData(
    double latitude,
    double longitude,
  ) async {
    // 🌍 API-URL mit den gewünschten Wetterdaten zusammenbauen
    final uri = Uri.parse(
      'https://api.open-meteo.com/v1/forecast'
      '?latitude=$latitude' // 📌 Standort-Breitengrad
      '&longitude=$longitude' // 📌 Standort-Längengrad
      '&current_weather=true' // 🌡 Holt aktuelle Wetterdaten (Temperatur, Wind)
      '&hourly=temperature_2m,precipitation_probability' // ⏳ Holt stündliche Werte
      '&daily=temperature_2m_min,temperature_2m_max,precipitation_probability_mean,weathercode' // 📆 Holt die 7-Tage-Vorhersage
      '&timezone=auto', // ⏰ Automatische Zeitzonen-Erkennung
    );

    _log.info(
      '🌍 Sende Anfrage an Open-Meteo für Koordinaten: ($latitude, $longitude)',
    );

    // 📌 API-Request senden
    final response = await client.get(uri);

    // ✅ Überprüfen, ob die Antwort erfolgreich war (Statuscode 200 = OK)
    if (response.statusCode == 200) {
      _log.info('✅ Wetterdaten erfolgreich geladen.');
      return json.decode(response.body)
          as Map<String, dynamic>; // 🔄 JSON-Daten umwandeln
    } else {
      throw Exception(
        '❌ Fehler beim Laden der Wetterdaten: ${response.statusCode}',
      );
    }
  }
}
