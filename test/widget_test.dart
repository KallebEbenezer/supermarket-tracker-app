import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supermarket_tracker_android/app/app.dart';

void main() {
  testWidgets('app builds without a business screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: App()));
    await tester.pump();

    expect(find.byType(App), findsOneWidget);
  });
}
