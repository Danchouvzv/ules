import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ules/main.dart';

void main() {
  testWidgets('Ules app starts', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: UlesApp()));
    await tester.pump();

    expect(tester.takeException(), isNull);
  });
}
