import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/app/weather_app.dart';
import 'package:weather_app/core/utils/logging_setup.dart';

void main() async {
  // Setup logging for the application
  LoggerUtil.setupLogging();

  WidgetsFlutterBinding.ensureInitialized();

  // Set the preferred device orientations
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const ProviderScope(child: WeatherApp()));
}
