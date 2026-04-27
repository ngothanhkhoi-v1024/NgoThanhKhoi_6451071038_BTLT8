// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:c5/models/dictionary_entry.dart';

void main() {
  test('DictionaryEntry parses json correctly', () {
    final DictionaryEntry entry = DictionaryEntry.fromJson(
      <String, dynamic>{
        'word': 'flutter',
        'meaning': 'UI toolkit',
      },
    );

    expect(entry.word, 'flutter');
    expect(entry.meaning, 'UI toolkit');
  });
}
