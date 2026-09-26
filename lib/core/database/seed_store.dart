import 'package:sqflite/sqflite.dart';

import 'seed_store_io.dart'
    if (dart.library.js_interop) 'seed_store_web.dart' as impl;

/// Abre la BD semilla preconstruida (solo móvil/escritorio).
Future<Database> openSeedDatabase(String seedPath, List<int> bytes) =>
    impl.openSeedDatabase(seedPath, bytes);

/// Borra el archivo temporal de la semilla (solo móvil/escritorio).
Future<void> deleteSeedDatabase(String seedPath) =>
    impl.deleteSeedDatabase(seedPath);
