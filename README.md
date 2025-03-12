# 🌦 Weather App

## 💌 Übersicht
Die **Weather App** ist eine Flutter-App zur Anzeige aktueller Wetterdaten sowie einer **stündlichen** und **7-Tage-Vorhersage**. Sie nutzt **Open-Meteo** für Wetterdaten und **OpenStreetMap** für Reverse Geocoding, um den Standortnamen aus den GPS-Koordinaten zu bestimmen.

## ✨ Features
- 📍 **Standorterkennung:** Automatische Ermittlung des aktuellen Standorts mit **Geolocator**.
- 🔄 **Dropdown zur Städteauswahl:** Wechsel zwischen festen Städten und dem aktuellen Standort.
- 🌡 **Aktuelles Wetter:** Anzeige von Temperatur, Wetterlage, Windgeschwindigkeit und Luftfeuchtigkeit.
- ⏳ **Stündliche Vorhersage:** Wetterdaten für die kommenden Stunden inklusive Uhrzeit.
- 📅 **7-Tage-Vorhersage:** Wetterdaten für die nächsten 7 Tage.
- 💾 **Speicherung des Standorts und der Wetterdaten** zur Wiederverwendung.
- 🛡 **Lösch-Funktion für den Wetterverlauf**.

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
/test
 ├── weather_service_test.dart (Unit-Tests für WeatherNotifier, Reverse Geocoding)
main.dart (App-Startpunkt)
```

## 📦 Abhängigkeiten
Diese App verwendet folgende **Flutter Packages**:
```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  build_runner: ^2.4.15
  http: ^1.3.0
  riverpod: ^2.6.1
  logging: ^1.3.0
  riverpod_lint: ^2.6.5
  riverpod_annotation: ^2.6.1
  flutter_riverpod: ^2.6.1
  hooks_riverpod: ^2.6.1
  shared_preferences: ^2.5.2
  shimmer: ^3.0.0
  google_fonts: ^6.2.1
  json_serializable: ^6.9.4
  freezed: ^3.0.3
  freezed_lint: ^0.0.9
  freezed_annotation: ^3.0.0
  json_annotation: ^4.9.0
  geolocator: ^13.0.2
```

## 🔧 Unit-Tests mit Mocktail
Die App enthält Unit-Tests für den `WeatherNotifier`, die mit `mocktail` simulierte API-Antworten testen.

### 🌟 Unit-Test-Beispiel:
```dart
class MockHttpClient extends Mock implements http.Client {}

void main() {
  group('WeatherNotifier', () {
    late MockHttpClient mockHttpClient;
    late ProviderContainer container;

    setUp(() {
      mockHttpClient = MockHttpClient();
      container = ProviderContainer(
        overrides: [
          httpClientProvider.overrideWithValue(mockHttpClient),
          weatherNotifierProvider.overrideWith(WeatherNotifier.new),
        ],
      );
      registerFallbackValue(Uri.parse(''));
    });

    tearDown(() {
      container.dispose();
    });

    test(
      'fetchWeather gibt Wetterdaten zurück, wenn die API erfolgreich antwortet',
      () async {
        final cityName = 'Bremen';
        final expectedData = {
          'current_weather': {
            'temperature': 20.0,
            'windspeed': 6.2,
            'weathercode': 1,
            'time': '2025-03-11T14:00',
          },
          'timezone': 'Europe/Berlin',
          'hourly': {
            'time': ['2025-03-11T14:00', '2025-03-11T15:00'],
            'temperature_2m': [20.0, 21.0],
            'precipitation_probability': [5.0, 6.0],
          },
        };

        when(() => mockHttpClient.get(any())).thenAnswer(
          (_) async => http.Response(json.encode(expectedData), 200),
        );

        final notifier = container.read(weatherNotifierProvider.notifier);
        final result = await notifier.fetchWeather(53.0793, 8.8017, cityName);

        expect(result.temperature, equals(20.0));
        expect(result.location, equals(cityName));
        expect(result.windSpeed, equals(6.2));
        expect(result.weatherCondition, equals('1'));
        verify(() => mockHttpClient.get(any())).called(1);
      },
    );
  });
}
```

Diese Tests stellen sicher, dass der `WeatherNotifier` korrekt mit der API interagiert und Fehler korrekt behandelt werden.



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

## ⚠️ Hinweis:
Da es sich nur um ein Übungsprojekt handelt und es mir eher um API's und die Logik ging habe ich darauf Verzichtet TextStyles und ColorStyles auszulagern.

Für die Möglichkeit auch kleinere Orte und Stadtteile mit ausgeben zu können habe ich mich für open street map entschieden beim Reverse Geocoding, ist aber aktuell nicht so weit implementiert.

---

## ‼️ TO DO:
Und das Projekt braucht noch finales Refactoring, es ist zuviel im Notifier noch und noch 1-2 fixes, die im UI nicht sauber sind. Aber ansonsten fehlt eigentlich ein repository und noch ein service um den Notifier schlanker zu machen, die Testkomplexität auch zu senken. Das muss ich hier bei Gelegenheit noch machen.

---

## 🖼️ Screenshots:

![Screenshot 2025-03-12 at 12 30 05](https://github.com/user-attachments/assets/1adf80a2-6d3f-42e6-b526-ebf301a5a520)









