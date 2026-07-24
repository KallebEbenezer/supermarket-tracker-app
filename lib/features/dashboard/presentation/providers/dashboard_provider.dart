import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../_shared/presentation/constants.dart';
import '../../../_shared/presentation/providers/repository_providers.dart';
import '../../domain/entities/dashboard_entity.dart';

/// Painel da empresa. `companyId` vem de [kDefaultCompanyId] (placeholder).
final dashboardProvider = FutureProvider.autoDispose.family<DashboardEntity, String>(
  (ref, companyId) =>
      ref.watch(dashboardRepositoryProvider).getDashboard(companyId: companyId),
);
