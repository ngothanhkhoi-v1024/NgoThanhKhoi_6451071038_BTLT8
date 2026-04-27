import 'dart:convert';
import 'dart:io';

import 'package:c3/models/task.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class StorageUtils {
  StorageUtils._();

  static Database? _db;

  static Future<Database> database() async {
    if (_db != null) {
      return _db!;
    }
    final dbDir = await getDatabasesPath();
    final dbPath = join(dbDir, 'tasks.db');
    _db = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tasks(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            isDone INTEGER NOT NULL
          )
        ''');
      },
    );
    return _db!;
  }

  static Future<String> exportJson(List<Task> tasks) async {
    final docs = await getApplicationDocumentsDirectory();
    final filePath = join(docs.path, 'tasks_backup.json');
    final file = File(filePath);
    final data = tasks.map((task) => task.toJson()).toList();
    await file.writeAsString(jsonEncode(data), flush: true);
    return file.path;
  }

  static Future<List<Task>> importJson() async {
    final docs = await getApplicationDocumentsDirectory();
    final filePath = join(docs.path, 'tasks_backup.json');
    final file = File(filePath);
    if (!await file.exists()) {
      return [];
    }
    final content = await file.readAsString();
    if (content.trim().isEmpty) {
      return [];
    }
    final raw = jsonDecode(content) as List<dynamic>;
    return raw.map((e) => Task.fromJson(e as Map<String, dynamic>)).toList();
  }
}
