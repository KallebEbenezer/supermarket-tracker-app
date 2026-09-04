import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supermarket_tracker_android/features/sale/domain/entities/pix_payment_entity.dart';
import 'package:supermarket_tracker_android/features/sale/domain/repositories/sale_repository.dart';
import 'package:supermarket_tracker_android/features/sale/presentation/providers/pix_payment_provider.dart';

class MockSaleRepository extends Mock implements SaleRepository {}

void main() {
  late ProviderContainer container;
  late MockSaleRepository mockRepository;
  final getIt = GetIt.instance;

  setUp(() {
    mockRepository = MockSaleRepository();
    if (!getIt.isRegistered<SaleRepository>()) {
      getIt.registerLazySingleton<SaleRepository>(() => mockRepository);
    } else {
      getIt.unregister<SaleRepository>();
      getIt.registerLazySingleton<SaleRepository>(() => mockRepository);
    }
    container = ProviderContainer();
  });

  tearDown(() {
    // Clean up any pending timers
    final notifier = container.read(pixPaymentProvider.notifier);
    container.dispose();
  });

  group('PixPaymentNotifier', () {
    test('initial state is loading', () {
      expect(container.read(pixPaymentProvider).status, PixPaymentStatus.loading);
    });

    test('sets approved state if payment is already approved', () async {
      when(() => mockRepository.getPixDetails('sale-1')).thenAnswer(
        (_) async => const PixPaymentEntity(
          qrCode: 'qr-code-123',
          copiaCola: 'copia-cola-123',
          status: 'APROVADO',
        ),
      );

      final notifier = container.read(pixPaymentProvider.notifier);
      await notifier.startPayment('sale-1');

      final state = container.read(pixPaymentProvider);
      expect(state.status, PixPaymentStatus.approved);
    });

    test('sets expired state if PIX is expired', () async {
      when(() => mockRepository.getPixDetails('sale-1')).thenAnswer(
        (_) async => PixPaymentEntity(
          qrCode: 'qr-code-123',
          copiaCola: 'copia-cola-123',
          status: 'PENDENTE',
          expiracao: DateTime.now().subtract(const Duration(minutes: 1)),
        ),
      );

      final notifier = container.read(pixPaymentProvider.notifier);
      await notifier.startPayment('sale-1');

      final state = container.read(pixPaymentProvider);
      expect(state.status, PixPaymentStatus.expired);
    });

    test('sets error state on failure', () async {
      when(() => mockRepository.getPixDetails('sale-1')).thenThrow(
        Exception('Network error'),
      );

      final notifier = container.read(pixPaymentProvider.notifier);
      await notifier.startPayment('sale-1');

      final state = container.read(pixPaymentProvider);
      expect(state.status, PixPaymentStatus.error);
      expect(state.errorMessage, contains('Network error'));
    });
  });

  group('PixPaymentEntity', () {
    test('fromJson parses correctly', () {
      final json = {
        'qrCode': 'qr-123',
        'copiaCola': 'copia-123',
        'status': 'PENDENTE',
        'expiracao': '2024-12-31T23:59:59.000Z',
      };

      final entity = PixPaymentEntity.fromJson(json);
      expect(entity.qrCode, 'qr-123');
      expect(entity.copiaCola, 'copia-123');
      expect(entity.status, 'PENDENTE');
      expect(entity.expiracao, isNotNull);
    });

    test('isApproved returns true for APROVADO status', () {
      const entity = PixPaymentEntity(
        qrCode: 'qr',
        copiaCola: 'copia',
        status: 'APROVADO',
      );
      expect(entity.isApproved, isTrue);
    });

    test('isPending returns true for PENDENTE status', () {
      const entity = PixPaymentEntity(
        qrCode: 'qr',
        copiaCola: 'copia',
        status: 'PENDENTE',
      );
      expect(entity.isPending, isTrue);
    });

    test('isExpiredByTime returns true when expiracao is in the past', () {
      final entity = PixPaymentEntity(
        qrCode: 'qr',
        copiaCola: 'copia',
        status: 'PENDENTE',
        expiracao: DateTime.now().subtract(const Duration(minutes: 1)),
      );
      expect(entity.isExpiredByTime, isTrue);
    });

    test('isExpiredByTime returns false when expiracao is in the future', () {
      final entity = PixPaymentEntity(
        qrCode: 'qr',
        copiaCola: 'copia',
        status: 'PENDENTE',
        expiracao: DateTime.now().add(const Duration(minutes: 30)),
      );
      expect(entity.isExpiredByTime, isFalse);
    });
  });
}
