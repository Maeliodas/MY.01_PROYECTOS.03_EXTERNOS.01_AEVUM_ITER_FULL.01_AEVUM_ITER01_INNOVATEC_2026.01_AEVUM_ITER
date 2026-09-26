import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'core/constants/app_constants.dart';
import 'app/app.dart';
import 'core/sync/sync_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    // SQLite en IndexedDB para la versión web/demo.
    databaseFactory = databaseFactoryFfiWeb;
  }
  debugPrint('AEVUM_ITER_API_URL: ${AppConstants.apiBaseUrl}');
  debugPrint(
  'AEVUM_ITER_API_KEY cargada: ${AppConstants.apiKey.isNotEmpty}',
);
  runApp(const ProviderScope(child: AevumIterApp()));
  unawaited(SyncService().syncPendingQueue());
}
