import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logging/logging.dart';

final Logger _log = Logger('LocationService');

class LocationService {
  // 🔑 Schlüssel für gespeicherte Standortwerte in SharedPreferences
  static const String latitudeKey = 'latitude';
  static const String longitudeKey = 'longitude';
  static const String useGeolocationKey = 'useGeolocation';

  /// 📍 Holt die aktuelle Position des Geräts
  /// Falls Standortdienste deaktiviert oder Berechtigungen verweigert sind, wird ein Fehler zurückgegeben
  static Future<Position> determinePosition() async {
    _log.info('Überprüfe Standortdienste...');
    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _log.severe('Standortdienste sind deaktiviert!');
      return Future.error('Standortdienste sind deaktiviert.');
    }

    _log.info('Überprüfe Standort-Berechtigungen...');
    LocationPermission permission = await Geolocator.checkPermission();

    // Falls keine Berechtigung erteilt wurde, fragen wir erneut nach
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

    // Falls Berechtigungen dauerhaft verweigert wurden, kann die App den Standort nicht abrufen
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
  ) async {
    _log.info(
      'Speichere letzte bekannte Position: Lat=$latitude, Lon=$longitude, useGeolocation=$useGeolocation...',
    );
    final prefs = await SharedPreferences.getInstance();

    await prefs.setDouble(latitudeKey, latitude);
    await prefs.setDouble(longitudeKey, longitude);
    await prefs.setBool(useGeolocationKey, useGeolocation);

    _log.info('Standort erfolgreich gespeichert.');
  }

  /// 🔄 Lädt die zuletzt gespeicherte Position aus SharedPreferences
  /// Falls keine Position gespeichert wurde, wird `null` zurückgegeben
  static Future<Map<String, dynamic>?> loadLastLocation() async {
    _log.info('Lade letzte bekannte Position aus SharedPreferences...');
    final prefs = await SharedPreferences.getInstance();

    // Falls kein gespeicherter Standort vorhanden ist, wird `null` zurückgegeben
    if (!prefs.containsKey(latitudeKey) || !prefs.containsKey(longitudeKey)) {
      _log.warning('Keine gespeicherte Position gefunden.');
      return null;
    }

    final latitude = prefs.getDouble(latitudeKey)!;
    final longitude = prefs.getDouble(longitudeKey)!;
    final useGeolocation = prefs.getBool(useGeolocationKey) ?? true;

    _log.info(
      'Gespeicherte Position geladen: Lat=$latitude, Lon=$longitude, useGeolocation=$useGeolocation.',
    );
    return {
      'latitude': latitude,
      'longitude': longitude,
      'useGeolocation': useGeolocation,
    };
  }
}
