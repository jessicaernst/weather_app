# 🌦 Weather App

## 📌 Übersicht
Die **Weather App** ist eine Flutter-App zur Anzeige aktueller Wetterdaten sowie einer **stündlichen** und **7-Tage-Vorhersage**. Sie nutzt **Open-Meteo** für Wetterdaten und **OpenStreetMap** für Reverse Geocoding, um den Standortnamen aus den GPS-Koordinaten zu bestimmen.

## ✨ Features
- 📍 **Standorterkennung:** Automatische Ermittlung des aktuellen Standorts mit **Geolocator**.
- 🔄 **Dropdown zur Städteauswahl:** Wechsel zwischen festen Städten und dem aktuellen Standort.
- 🌡 **Aktuelles Wetter:** Anzeige von Temperatur, Wetterlage, Windgeschwindigkeit und Luftfeuchtigkeit.
- ⏳ **Stündliche Vorhersage:** Wetterdaten für die kommenden Stunden inklusive Uhrzeit.
- 📅 **7-Tage-Vorhersage:** Wetterdaten für die nächsten 7 Tage.
- 💾 **Speicherung des Standorts und der Wetterdaten** zur Wiederverwendung.
- 🗑 **Lösch-Funktion für den Wetterverlauf**.

## 📂 Projektstruktur
```
/core
 ├── styles/ (Design und Theme-Definitionen)
 ├── utils/ (Hilfsfunktionen und Konstante Strings)
 ├── app_strings.dart (App-weit genutzte Strings)
/models
 ├── weather_data.dart (Wetterdaten-Modell)
 ├── weather_data.freezed.dart (Generierte Freezed-Datei)
 ├── weather_data.g.dart (Generierte JSON-Serialisierung)
 ├── weather_state.dart (State-Management-Modell)
 ├── weather_state.freezed.dart (Generierte Freezed-Datei)
/presentation
 ├── screens/
 │   ├── weather_page.dart (Hauptbildschirm der Wetter-App)
 ├── widgets/
 │   ├── city_dropdown.dart (Dropdown zur Standortwahl)
 │   ├── clear_history_btn.dart (Button zum Löschen des Wetterverlaufs)
 │   ├── current_weather_info.dart (Anzeige der aktuellen Wetterdaten)
 │   ├── error_msg.dart (Anzeige von Fehlermeldungen)
 │   ├── hourly_forecast.dart (Stündliche Wettervorhersage)
 │   ├── refresh_btn.dart (Button zum Aktualisieren des Wetters)
 │   ├── seven_day_forecast.dart (7-Tage-Vorhersage Widget)
 │   ├── weather_page_content.dart (Aufbau der Wetter-UI)
/providers
 ├── weather_provider.dart (State Management mit Riverpod)
 ├── weather_provider.g.dart (Generierte Datei für Riverpod)
/services
 ├── location_service.dart (Standort-Handling & Reverse Geocoding)
 ├── storage_service.dart (Speicherung von Wetter- und Standortdaten)
main.dart (App-Startpunkt)
```

## 📦 Abhängigkeiten
Diese App verwendet folgende **Flutter Packages**:
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.3.2
  hooks_riverpod: ^2.3.2
  http: ^0.14.0
  json_serializable: ^6.1.4
  freezed_annotation: ^2.2.0
  geolocator: ^9.0.2
  shared_preferences: ^2.2.0
  logging: ^1.1.1
```

## 🔧 Installation & Setup
### 📥 Repository klonen
```bash
git clone https://github.com/dein-repo/weather-app.git
cd weather-app
```

### 📦 Abhängigkeiten installieren
```bash
flutter pub get
```

### 🛠 Code generieren (falls nötig)
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 📍 **Berechtigungen setzen (Android & iOS)**

#### ✅ iOS: `ios/Runner/Info.plist` bearbeiten
Füge die folgenden Berechtigungen hinzu, damit die App Standortdaten abrufen kann:
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Diese App benötigt Zugriff auf deinen Standort für die Wettervorhersage.</string>
```

#### ✅ Android: `android/app/src/main/AndroidManifest.xml`
Füge die Standortberechtigungen hinzu:
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

### 🚀 App starten
```bash
flutter run
```

## 📡 API-Nutzung
### 🔄 Open-Meteo API (Wetterdaten)
```sh
https://api.open-meteo.com/v1/forecast?latitude={LAT}&longitude={LON}&current_weather=true
```

### 🌍 OpenStreetMap API (Reverse Geocoding)
```sh
https://nominatim.openstreetmap.org/reverse?format=json&lat={LAT}&lon={LON}
```
**Hinweis:** Reverse Geocoding ermittelt den echten Ortsnamen basierend auf den GPS-Koordinaten.

---

## 📝 Logging mit `logging`-Package
Die App nutzt das `logging`-Paket, um Logs für verschiedene Ereignisse aufzuzeichnen.

### 📊 Log-Level Bedeutung
- **FINEST** (detaillierteste Logs, Debugging-Infos)
- **FINER** (mehr Details als FINE, weniger als FINEST)
- **FINE** (detaillierte Debugging-Infos)
- **CONFIG** (Konfigurationsdetails)
- **INFO** (Allgemeine Informationen zum App-Status)
- **WARNING** (Warnungen, die möglicherweise Probleme verursachen könnten)
- **SEVERE** (Fehlermeldungen, die die App betreffen)
- **SHOUT** (kritische Fehler, die sofortige Aufmerksamkeit erfordern)

### 🔍 Beispiel-Logging in der App
```dart
final Logger _log = Logger('WeatherNotifier');

void fetchWeather() {
  try {
    _log.info('Starte Wetterabfrage...');
    // API Call
    _log.fine('Wetterdaten erfolgreich abgerufen.');
  } catch (e) {
    _log.severe('Fehler beim Abrufen der Wetterdaten: $e');
  }
}
```

---

## 🐞 Fehlerbehebung & Debugging
- **Fehlende Berechtigungen?** Stelle sicher, dass du die erforderlichen Standortberechtigungen gesetzt hast.
- **App stürzt ab?** Nutze `flutter run --verbose`, um detaillierte Logs zu sehen.
- **Fehlermeldung `type 'int' is not a subtype of type 'double'`?** Stelle sicher, dass du `.toDouble()` für numerische Werte in JSON verwendest.
- **API gibt falsche Daten zurück?** Überprüfe, ob die Open-Meteo-API erreichbar ist.

---

## Hinweis:
Da es sich nur um ein Übungsprojekt handelt und es mir eher um API's und die Logik ging habe ich darauf Verzichtet TextStyles und ColorStyles auszulagern.

Für die Möglichkeit auch kleinere Orte und Stadtteile mit ausgeben zu können habe ich mich für open street map entschieden beim Reverse Geocoding, ist aber aktuell nicht so weit implementiert.

---

## Screenshots:

![Screenshot 2025-03-10 at 19 07 16](https://github.com/user-attachments/assets/7d26706d-03cc-4b26-8820-0c177d50bf9f)








