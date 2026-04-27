import 'package:flutter/material.dart';

import '../models/dictionary_entry.dart';

class DictionaryItem extends StatelessWidget {
  const DictionaryItem({
    super.key,
    required this.entry,
  });

  final DictionaryEntry entry;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        title: Text(
          entry.word,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(entry.meaning),
        ),
      ),
    );
  }
}
