// ignore_for_file: avoid_print

import 'package:logging/logging.dart';

/// Ein Dienst zum Protokollieren von Nachrichten, Warnungen und Fehlern.
class LoggingService {
  final Logger _logger;

  /// Erstellt eine neue Instanz des [LoggingService] mit dem angegebenen [name].
  LoggingService(String name) : _logger = Logger(name);

  /// Initialisiert den Loggingdienst.
  void init() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      print(
        '${record.time}: ${record.level.name}: ${record.loggerName}: ${record.message}',
      );
      if (record.error != null) {
        print(record.error);
      }
      if (record.stackTrace != null) {
        print(record.stackTrace);
      }
    });
  }

  /// Protokolliert eine sehr detaillierte Nachricht mit optionalem [error] und [stackTrace].
  void finest(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.finest(message, error, stackTrace);
  }

  /// Protokolliert eine detaillierte Nachricht mit optionalem [error] und [stackTrace].
  void finer(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.finer(message, error, stackTrace);
  }

  /// Protokolliert eine detaillierte Nachricht mit optionalem [error] und [stackTrace].
  void fine(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.fine(message, error, stackTrace);
  }

  /// Protokolliert eine Konfigurationsnachricht mit optionalem [error] und [stackTrace].
  void config(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.config(message, error, stackTrace);
  }

  /// Protokolliert eine Informationsnachricht mit optionalem [error] und [stackTrace].
  void info(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.info(message, error, stackTrace);
  }

  /// Protokolliert eine Warnmeldung mit optionalem [error] und [stackTrace].
  void warning(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.warning(message, error, stackTrace);
  }

  /// Protokolliert eine schwerwiegende Fehlermeldung mit optionalem [error] und [stackTrace].
  void severe(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.severe(message, error, stackTrace);
  }

  /// Protokolliert eine sehr schwerwiegende Fehlermeldung mit optionalem [error] und [stackTrace].
  void shout(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.shout(message, error, stackTrace);
  }
}
