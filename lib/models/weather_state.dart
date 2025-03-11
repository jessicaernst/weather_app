import 'package:freezed_annotation/freezed_annotation.dart';
import 'weather_data.dart';

// 🚀 Diese `part`-Datei wird von Freezed automatisch generiert.
// - `weather_state.freezed.dart`: Enthält den generierten Code für Immutable-Objekte (copyWith(), == Operator, etc.).
part 'weather_state.freezed.dart';

// 📌 `@freezed` ist eine Annotation von **Freezed** (ein Code-Generator für Immutable-Klassen).
//    - Diese Klasse kann **nach der Erstellung nicht mehr verändert** werden (Immutable).
//    - Freezed generiert automatisch Funktionen wie `.copyWith()`, `.toString()`, usw.
@freezed
abstract class WeatherState with _$WeatherState {
  /// 🚀 Die `factory WeatherState` Methode erzeugt eine **neue Instanz** der `WeatherState` Klasse.
  /// - Diese Klasse repräsentiert den **aktuellen Zustand der Wetter-App**.
  /// - Alle Werte hier werden von Riverpod verwaltet und aktualisiert.
  /// - Falls Werte nicht explizit gesetzt werden, greifen die **@Default() Werte**.
  const factory WeatherState({
    /// 📍 Der aktuell ausgewählte Standort.
    /// - Standardwert ist **"Aktueller Standort"**, falls kein anderer Standort gewählt wurde.
    @Default('Aktueller Standort') String selectedCity,

    /// 🌍 Gibt an, ob die Geolocation (GPS) verwendet wird oder ein manueller Standort gewählt wurde.
    /// - Standardwert ist `true`, d.h., die App verwendet **automatisch den aktuellen Standort**.
    @Default(true) bool useGeolocation,

    /// 🌦 Die aktuellen Wetterdaten, falls vorhanden.
    /// - `WeatherData?` bedeutet: **Kann `null` sein**, wenn noch keine Daten geladen wurden oder ein Fehler aufgetreten ist.
    WeatherData? weatherData,

    /// ⏳ Zeigt an, ob gerade **Wetterdaten geladen** werden.
    /// - Standardwert ist `false`, d.h., anfangs wird **kein Ladevorgang** ausgeführt.
    /// - Falls die App gerade neue Wetterdaten lädt, wird dieser Wert `true` gesetzt.
    @Default(false) bool isLoading,

    /// ⚠️ Falls ein Fehler auftritt (z. B. API nicht erreichbar), wird die **Fehlermeldung hier gespeichert**.
    /// - `String?` bedeutet: **Kann `null` sein**, wenn kein Fehler vorliegt.
    String? errorMessage,
  }) = _WeatherState;
}
