import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest_10y.dart' as tz;
import 'package:weather_app/app/weather_app.dart';
import 'package:weather_app/core/utils/logging_setup.dart';

void main() async {
  // Setup logging muss vor dem Start der App erfolgen
  LoggerUtil.setupLogging();

  // Initialisiere die Flutter-App
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisiere die Zeitzonen-Datenbank
  tz.initializeTimeZones();

  // Setze die bevorzugte Orientierung auf Portrait
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const ProviderScope(child: WeatherApp()));
}
