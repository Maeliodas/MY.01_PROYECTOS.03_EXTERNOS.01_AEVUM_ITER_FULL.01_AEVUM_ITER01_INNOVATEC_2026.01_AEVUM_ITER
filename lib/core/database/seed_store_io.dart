import 'dart:io';

import 'package:sqflite/sqflite.dart';

/// Implementación móvil/escritorio: la semilla se materializa en archivo.
Future<Database> openSeedDatabase(String seedPath, List<int> bytes) async {
  final file = File(seedPath);
  await file.writeAsBytes(bytes, flush: true);
  return openDatabase(seedPath, readOnly: true);
}

Future<void> deleteSeedDatabase(String seedPath) async {
  final file = File(seedPath);
  if (await file.exists()) await file.delete();
}
