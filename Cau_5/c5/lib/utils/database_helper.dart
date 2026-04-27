import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

import '../models/dictionary_entry.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String dbFolder = await getDatabasesPath();
    final String dbPath = path.join(dbFolder, 'dictionary.db');

    return openDatabase(
      dbPath,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE dictionary(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            word TEXT NOT NULL,
            meaning TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<void> seedDataIfNeeded() async {
    final Database db = await database;
    final int count = Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM dictionary'),
        ) ??
        0;

    if (count > 0) {
      return;
    }

    final String rawJson =
        await rootBundle.loadString('assets/data/dictionary.json');
    final List<dynamic> jsonData = jsonDecode(rawJson) as List<dynamic>;

    final Batch batch = db.batch();
    for (final dynamic item in jsonData) {
      final DictionaryEntry entry =
          DictionaryEntry.fromJson(item as Map<String, dynamic>);
      batch.insert(
        'dictionary',
        <String, dynamic>{
          'word': entry.word,
          'meaning': entry.meaning,
        },
      );
    }

    await batch.commit(noResult: true);
  }

  Future<List<DictionaryEntry>> searchWords(String query) async {
    final Database db = await database;
    final String keyword = query.trim();

    final List<Map<String, dynamic>> rows = await db.query(
      'dictionary',
      where: keyword.isEmpty ? null : 'word LIKE ?',
      whereArgs: keyword.isEmpty ? null : <String>['%$keyword%'],
      orderBy: 'word COLLATE NOCASE ASC',
      limit: 50,
    );

    return rows.map(DictionaryEntry.fromMap).toList();
  }
}
