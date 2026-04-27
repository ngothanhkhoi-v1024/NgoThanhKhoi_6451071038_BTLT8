import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders simple smoke widget', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Text('Smoke test'),
        ),
      ),
    );

    expect(find.text('Smoke test'), findsOneWidget);
  });
}
