import 'package:flutter_test/flutter_test.dart';
import 'package:wedstyle/main.dart';

void main() {
  testWidgets('WedStyle app boots up smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const WedStyleApp());
    expect(find.byType(WedStyleApp), findsOneWidget);
    // Allow splash timer to complete
    await tester.pump(const Duration(seconds: 4));
  });
}
