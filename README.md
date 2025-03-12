# ✨ Weather App

## 📨 Übersicht
Die **Weather App** ist eine Flutter-App zur Anzeige aktueller Wetterdaten sowie einer **stündlichen** und **7-Tage-Vorhersage**. Sie nutzt **Open-Meteo** für Wetterdaten und **OpenStreetMap** für Reverse Geocoding, um den Standortnamen aus den GPS-Koordinaten zu bestimmen.

## ✨ Features
- 📍 **Standorterkennung:** Automatische Ermittlung des aktuellen Standorts mit **Geolocator**.
- 🔄 **Dropdown zur Städteauswahl:** Wechsel zwischen festen Städten und dem aktuellen Standort.
- 🌬 **Aktuelles Wetter:** Anzeige von Temperatur, Wetterlage, Windgeschwindigkeit und Luftfeuchtigkeit.
- ⏳ **Stündliche Vorhersage:** Wetterdaten für die kommenden Stunden inklusive Uhrzeit.
- 🗓 **7-Tage-Vorhersage:** Wetterdaten für die nächsten 7 Tage.
- 💾 **Speicherung des Standorts und der Wetterdaten** zur Wiederverwendung.
- 🛡 **Lösch-Funktion für den Wetterverlauf**.

## 📂 Projektstruktur
```
/lib
 ├── core/
 │   ├── utils/
 │   │   ├── logging_setup.dart (Logging-Konfiguration)
 │   │   ├── app_strings.dart (App-weit genutzte Strings)
 ├── models/
 │   ├── weather_data.dart (Wetterdaten-Modell)
 │   ├── weather_state.dart (State-Management-Modell)
 │   ├── daily_weather.dart (Tägliche Wettervorhersage)
 ├── presentation/
 │   ├── screens/
 │   │   ├── weather_page.dart (Hauptbildschirm der Wetter-App)
 │   ├── widgets/
 │   │   ├── city_dropdown.dart (Dropdown zur Standortwahl)
 │   │   ├── clear_history_btn.dart (Button zum Löschen des Wetterverlaufs)
 │   │   ├── current_weather_info.dart (Anzeige der aktuellen Wetterdaten)
 │   │   ├── hourly_forecast.dart (Stündliche Wettervorhersage)
 │   │   ├── refresh_btn.dart (Button zum Aktualisieren des Wetters)
 │   │   ├── seven_day_forecast.dart (7-Tage-Vorhersage Widget)
 │   │   ├── weather_page_content.dart (Aufbau der Wetter-UI)
 ├── providers/
 │   ├── weather_notifier.dart (State Management mit Riverpod)
 │   ├── repository_provider.dart (Provider für das Repository)
 │   ├── service_provider.dart (Provider für Services)
 │   ├── http_provider.dart (Provider für HTTP-Client)
 ├── repositories/
 │   ├── weather_repository.dart (HTTP-Anfragen für Wetterdaten)
 ├── services/
 │   ├── location_service.dart (Standort-Handling & Reverse Geocoding)
 │   ├── storage_service.dart (Speicherung von Wetter- und Standortdaten)
 │   ├── weather_service.dart (Verarbeitung der API-Daten)
 ├── main.dart (App-Startpunkt)
```

## 👆 Abhängigkeiten
Diese App verwendet folgende **Flutter Packages**:
```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  build_runner: ^2.4.15
  http: ^1.3.0
  riverpod: ^2.6.1
  riverpod_annotation: ^2.6.1
  flutter_riverpod: ^2.6.1
  shared_preferences: ^2.5.2
  geolocator: ^13.0.2
  logging: ^1.3.0
  json_serializable: ^6.9.4
  freezed: ^3.0.3
  freezed_annotation: ^3.0.0
  mocktail: ^1.0.3
```

## 🔧 Installation & Setup
### 📂 Repository klonen
```bash
git clone https://github.com/dein-repo/weather-app.git
cd weather-app
```

### 💾 Abhängigkeiten installieren
```bash
flutter pub get
```

### 🛠 Code generieren (falls nötig)
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 🏰 **Berechtigungen setzen (Android & iOS)**
#### ✅ iOS: `ios/Runner/Info.plist` bearbeiten
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Diese App benötigt Zugriff auf deinen Standort für die Wettervorhersage.</string>
```

#### ✅ Android: `android/app/src/main/AndroidManifest.xml`
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

### ⚡ App starten
```bash
flutter run
```

## 🌐 API-Nutzung
### 🔄 Open-Meteo API (Wetterdaten)
```sh
https://api.open-meteo.com/v1/forecast?latitude={LAT}&longitude={LON}&current_weather=true
```

### 🌍 OpenStreetMap API (Reverse Geocoding)
```sh
https://nominatim.openstreetmap.org/reverse?format=json&lat={LAT}&lon={LON}
```

## ✨ Logging mit `logging`-Package
Die App nutzt das `logging`-Paket, um Logs für verschiedene Ereignisse aufzuzeichnen.
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

## 🛠️ Fehlerbehebung & Debugging
- **Fehlende Berechtigungen?** Stelle sicher, dass du die erforderlichen Standortberechtigungen gesetzt hast.
- **App stürzt ab?** Nutze `flutter run --verbose`, um detaillierte Logs zu sehen.
- **API gibt falsche Daten zurück?** Überprüfe, ob die Open-Meteo-API erreichbar ist.

## ⚠ Hinweis
Dieses Projekt erfordert noch **Refactoring**, um den `WeatherNotifier` weiter zu optimieren.

## 📷 Screenshots

![Screenshot 2025-03-12 at 12 47 27](https://github.com/user-attachments/assets/bca1ca3a-3a7a-4a03-bcfe-11801fa3549c)











