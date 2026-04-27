// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:c6/apps/apps.dart';

void main() {
  testWidgets('App shows title with MSSV', (WidgetTester tester) async {
    await tester.pumpWidget(const Apps());
    await tester.pumpAndSettle();

    expect(find.text('Bai 6 - MSSV: 6451071038'), findsOneWidget);
  });
}
