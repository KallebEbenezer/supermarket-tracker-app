import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../_shared/presentation/providers/repository_providers.dart';
import '../../domain/entities/stock_movement_entity.dart';

final stockMovementListProvider =
    FutureProvider.autoDispose.family<List<StockMovementEntity>, String>(
  (ref, companyId) =>
      ref.watch(stockMovementRepositoryProvider).listStockMovements(companyId),
);
