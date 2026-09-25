import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'seed_store.dart';
import 'tables.dart';

/// Carga los catálogos desde una base SQLite preconstruida (móvil) o desde
/// el JSON semilla (web, sin sistema de archivos).
/// No se utilizan servicios externos.
class DatabaseSeed {
  const DatabaseSeed._();

  static const _asset = 'assets/database/aevum_iter_catalog_v15.db';
  static const _jsonAsset = 'assets/database/catalogs_seed.json';

  static const _order = [
    'states',
    'municipalities',
    'schools',
    'languages',
    // Las carreras deben existir antes de insertar preguntas porque
    // questions.related_career_id referencia careers.id.
    'careers',
    'questions',
    'department_open_questions',
    'career_riasec_weights',
    'career_questions',
  ];

  static const _tables = {
    'states': Tables.states,
    'municipalities': Tables.municipalities,
    'schools': Tables.schools,
    'languages': Tables.languages,
    'careers': Tables.careers,
    'questions': Tables.questions,
    'department_open_questions': Tables.departmentQuestions,
    'career_riasec_weights': Tables.careerWeights,
    'career_questions': Tables.careerQuestions,
  };

  static Future<void> apply(DatabaseExecutor db) async {
    if (kIsWeb) {
      await _applyJson(db);
      return;
    }
    final bytes = await rootBundle.load(_asset);
    final databaseRoot = await getDatabasesPath();
    final seedPath = join(databaseRoot, 'aevum_iter_catalog_seed_v15.db');
    final seed = await openSeedDatabase(
      seedPath,
      bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes),
    );
    try {
      final batch = db.batch();
      for (final key in _order) {
        await _copy(seed, batch, _tables[key]!);
      }
      await batch.commit(noResult: true);
    } finally {
      await seed.close();
      await deleteSeedDatabase(seedPath);
    }
  }

  static Future<void> _applyJson(DatabaseExecutor db) async {
    final raw = await rootBundle.loadString(_jsonAsset);
    final data = jsonDecode(raw) as Map<String, dynamic>;
    final batch = db.batch();
    for (final key in _order) {
      final rows = data[key];
      if (rows is! List) continue;
      for (final row in rows) {
        if (row is! Map) continue;
        batch.insert(
          _tables[key]!,
          Map<String, Object?>.from(row),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }
    await batch.commit(noResult: true);
  }

  static Future<void> _copy(
    Database seed,
    Batch batch,
    String table,
  ) async {
    final rows = await seed.query(table);
    for (final row in rows) {
      batch.insert(table, row, conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }
}
