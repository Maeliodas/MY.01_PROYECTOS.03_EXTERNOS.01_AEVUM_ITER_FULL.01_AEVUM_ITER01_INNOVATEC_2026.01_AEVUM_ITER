import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/sync/catalog_sync_service.dart';
import '../../data/catalog_repository.dart';
import '../../domain/models/catalog_models.dart';

final catalogRepositoryProvider = Provider<CatalogRepository>(
  (ref) => CatalogRepository(),
);

final catalogSyncServiceProvider = Provider<CatalogSyncService>(
  (ref) => CatalogSyncService(repository: ref.watch(catalogRepositoryProvider)),
);

final careersCatalogProvider = FutureProvider<List<CareerCatalog>>((ref) {
  return ref.watch(catalogRepositoryProvider).getCareers();
});
