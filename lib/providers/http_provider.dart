import 'package:http/http.dart' as http;
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'http_provider.g.dart'; // 🚀 Automatisch generiert

/// 🛠 **HTTP-Client Provider** (Code-Generated)
/// - Erstellt eine `http.Client` Instanz.
/// - Kann von anderen Services oder Repositories genutzt werden.
@riverpod
http.Client httpClient(Ref ref) => http.Client();
