import 'package:sqflite/sqflite.dart';

/// Implementación web: sin sistema de archivos (la semilla entra por JSON).
Future<Database> openSeedDatabase(String seedPath, List<int> bytes) {
  throw UnsupportedError('Sin semilla SQLite en web');
}

Future<void> deleteSeedDatabase(String seedPath) async {}
