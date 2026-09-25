import 'package:http/http.dart' as http;

import '../constants/app_constants.dart';

class NetworkInfo {
  static Future<bool> hasConnection() async {
    try {
      final response = await http
          .get(Uri.parse('https://www.google.com/generate_204'))
          .timeout(const Duration(seconds: 5));
      return response.statusCode >= 200 && response.statusCode < 400;
    } catch (_) {
      return false;
    }
  }

  /// Verifica contra el backend real (panel web, p. ej. túnel ngrok) en vez
  /// de un host externo. Evita falsos positivos cuando hay internet pero el
  /// túnel está caído, y falsos negativos en redes que bloquean Google.
  static Future<bool> hasBackendConnection({Duration timeout = const Duration(seconds: 3)}) async {
    try {
      var base = AppConstants.apiBaseUrl.trim();
      while (base.endsWith('/')) {
        base = base.substring(0, base.length - 1);
      }
      final root = base.endsWith('/api') ? base.substring(0, base.length - 4) : base;
      final response = await http
          .get(Uri.parse('$root/health'))
          .timeout(timeout);
      return response.statusCode >= 200 && response.statusCode < 500;
    } catch (_) {
      return false;
    }
  }
}
