import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../_shared/presentation/providers/repository_providers.dart';
import '../../domain/entities/sale_entity.dart';

final saleListProvider =
    FutureProvider.autoDispose.family<List<SaleEntity>, String>(
  (ref, companyId) =>
      ref.watch(saleRepositoryProvider).listSales(companyId),
);
