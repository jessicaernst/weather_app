import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logging/logging.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

final _log = Logger('LocationService');

class LocationService {
  // 🔑 Diese Konstanten definieren die Schlüssel, unter denen die Standortdaten
  // in SharedPreferences gespeichert werden.
  static const String latitudeKey = 'latitude';
  static const String longitudeKey = 'longitude';
  static const String useGeolocationKey = 'useGeolocation';
  static const String locationNameKey = 'locationName';

  /// 📍 Holt die aktuelle Position des Geräts mit Berechtigungsprüfung
  /// Falls die Berechtigungen nicht erteilt wurden, wird eine Fehlermeldung zurückgegeben.
  static Future<Position> determinePosition() async {
    _log.info('Überprüfe Standortdienste...');
    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    // ❌ Falls der Standortdienst ausgeschaltet ist, breche hier mit einer Fehlermeldung ab.
    if (!serviceEnabled) {
      _log.severe('Standortdienste sind deaktiviert!');
      return Future.error('Standortdienste sind deaktiviert.');
    }

    _log.info('Überprüfe Standort-Berechtigungen...');
    LocationPermission permission = await Geolocator.checkPermission();

    // 📌 Falls die Berechtigung abgelehnt wurde, frage sie erneut an.
    if (permission == LocationPermission.denied) {
      _log.warning(
        'Standort-Berechtigungen wurden abgelehnt, fordere erneut an...',
      );
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _log.severe('Standort-Berechtigung erneut verweigert!');
        return Future.error('Standortberechtigungen wurden verweigert.');
      }
    }

    // 🚫 Falls die Berechtigung dauerhaft verweigert wurde, kann die App nichts tun.
    if (permission == LocationPermission.deniedForever) {
      _log.severe(
        'Standort-Berechtigung dauerhaft verweigert. Manuelle Aktivierung in den Einstellungen erforderlich.',
      );
      return Future.error('Standortberechtigungen sind dauerhaft verweigert.');
    }

    // ✅ Falls alle Berechtigungen da sind -> Standort abrufen.
    _log.info('Berechtigungen erteilt, Standort wird ermittelt...');
    return await Geolocator.getCurrentPosition();
  }

  /// 💾 Speichert die zuletzt verwendete Position zusammen mit der Info,
  /// ob Geolocation genutzt wurde und welchem Ortsnamen die Koordinaten entsprechen.
  static Future<void> saveLastLocation(
    double latitude,
    double longitude,
    bool useGeolocation,
    String locationName,
  ) async {
    _log.info(
      'Speichere letzte bekannte Position: Lat=$latitude, Lon=$longitude, useGeolocation=$useGeolocation, Location=$locationName...',
    );

    final prefs = await SharedPreferences.getInstance();

    // 📌 Standortwerte in SharedPreferences speichern
    await prefs.setDouble(latitudeKey, latitude);
    await prefs.setDouble(longitudeKey, longitude);
    await prefs.setBool(useGeolocationKey, useGeolocation);
    await prefs.setString(locationNameKey, locationName);

    _log.info('Standort erfolgreich gespeichert.');
  }

  /// 🔄 Lädt die zuletzt gespeicherte Position aus SharedPreferences.
  /// Falls keine Position gespeichert wurde, gibt die Methode `null` zurück.
  static Future<Map<String, dynamic>?> loadLastLocation() async {
    _log.info('Lade letzte bekannte Position aus SharedPreferences...');
    final prefs = await SharedPreferences.getInstance();

    // ❌ Falls es keine gespeicherten Standortdaten gibt, gebe `null` zurück.
    if (!prefs.containsKey(latitudeKey) || !prefs.containsKey(longitudeKey)) {
      _log.warning('Keine gespeicherte Position gefunden.');
      return null;
    }

    // 📌 Werte aus SharedPreferences abrufen
    final latitude = prefs.getDouble(latitudeKey)!;
    final longitude = prefs.getDouble(longitudeKey)!;
    final useGeolocation = prefs.getBool(useGeolocationKey) ?? true;
    final locationName = prefs.getString(locationNameKey) ?? 'Unbekannter Ort';

    _log.info(
      'Gespeicherte Position geladen: Lat=$latitude, Lon=$longitude, useGeolocation=$useGeolocation, Location=$locationName.',
    );

    // 🔄 Rückgabe als Map mit den Standortinfos
    return {
      'latitude': latitude,
      'longitude': longitude,
      'useGeolocation': useGeolocation,
      'locationName': locationName,
    };
  }

  /// 🔄 Wandelt Koordinaten in einen echten Ortsnamen um (Reverse Geocoding)
  /// Falls die API keinen Namen findet, wird "Unbekannter Ort" zurückgegeben.
  static Future<String> getLocationName(
    double latitude,
    double longitude,
  ) async {
    try {
      _log.info('Reverse Geocoding für Lat=$latitude, Lon=$longitude...');

      // 🌍 API-URL für das Reverse Geocoding mit OpenStreetMap
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitude&lon=$longitude',
      );

      // 📡 Anfrage an die API senden
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // 🔍 Versuche, die Stadt oder den Ort aus der Antwort zu extrahieren
        final String? city =
            data['address']?['city'] ??
            data['address']?['town'] ??
            data['address']?['village'];
        final String? country = data['address']?['country'];

        if (city != null && country != null) {
          _log.info('Standort ermittelt: $city, $country');
          return '$city, $country';
        } else {
          _log.warning(
            'Kein genauer Ortsname gefunden. Rückgabe: "Unbekannter Ort"',
          );
          return 'Unbekannter Ort';
        }
      } else {
        _log.severe(
          'Reverse Geocoding fehlgeschlagen! HTTP-Status: ${response.statusCode}',
        );
        return 'Ort nicht gefunden';
      }
    } catch (e) {
      _log.severe('Fehler beim Reverse Geocoding: $e');
      return 'Ort konnte nicht bestimmt werden';
    }
  }
}
