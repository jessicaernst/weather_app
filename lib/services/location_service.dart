import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logging/logging.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

final _log = Logger('LocationService');

class LocationService {
  // 🔑 Keys für gespeicherte Standortwerte in SharedPreferences
  static const String latitudeKey = 'latitude';
  static const String longitudeKey = 'longitude';
  static const String useGeolocationKey = 'useGeolocation';
  static const String locationNameKey = 'locationName';

  /// 📍 Holt die aktuelle Position des Geräts mit Berechtigungsprüfung
  static Future<Position> determinePosition() async {
    _log.info('Überprüfe Standortdienste...');
    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _log.severe('Standortdienste sind deaktiviert!');
      return Future.error('Standortdienste sind deaktiviert.');
    }

    _log.info('Überprüfe Standort-Berechtigungen...');
    LocationPermission permission = await Geolocator.checkPermission();

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

    if (permission == LocationPermission.deniedForever) {
      _log.severe(
        'Standort-Berechtigung dauerhaft verweigert. Manuelle Aktivierung in den Einstellungen erforderlich.',
      );
      return Future.error('Standortberechtigungen sind dauerhaft verweigert.');
    }

    // ✅ Alle Berechtigungen erteilt – Standort abrufen
    _log.info('Berechtigungen erteilt, Standort wird ermittelt...');
    return await Geolocator.getCurrentPosition();
  }

  /// 💾 Speichert die zuletzt genutzte Position sowie die Einstellung, ob Geolocation genutzt wird
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

    await prefs.setDouble(latitudeKey, latitude);
    await prefs.setDouble(longitudeKey, longitude);
    await prefs.setBool(useGeolocationKey, useGeolocation);
    await prefs.setString(locationNameKey, locationName);

    _log.info('Standort erfolgreich gespeichert.');
  }

  /// 🔄 Lädt die zuletzt gespeicherte Position aus SharedPreferences
  /// Falls keine Position gespeichert wurde, wird `null` zurückgegeben
  static Future<Map<String, dynamic>?> loadLastLocation() async {
    _log.info('Lade letzte bekannte Position aus SharedPreferences...');
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey(latitudeKey) || !prefs.containsKey(longitudeKey)) {
      _log.warning('Keine gespeicherte Position gefunden.');
      return null;
    }

    final latitude = prefs.getDouble(latitudeKey)!;
    final longitude = prefs.getDouble(longitudeKey)!;
    final useGeolocation = prefs.getBool(useGeolocationKey) ?? true;
    final locationName = prefs.getString(locationNameKey) ?? 'Unbekannter Ort';

    _log.info(
      'Gespeicherte Position geladen: Lat=$latitude, Lon=$longitude, useGeolocation=$useGeolocation, Location=$locationName.',
    );
    return {
      'latitude': latitude,
      'longitude': longitude,
      'useGeolocation': useGeolocation,
      'locationName': locationName,
    };
  }

  /// 🔄 Wandelt Koordinaten in einen echten Ortsnamen um (Reverse Geocoding) mit Fehlerhandling
  static Future<String> getLocationName(
    double latitude,
    double longitude,
  ) async {
    try {
      _log.info('Reverse Geocoding für Lat=$latitude, Lon=$longitude...');
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitude&lon=$longitude',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // 🔍 Versuche, die Stadt / den Ort aus der Antwort zu extrahieren
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
