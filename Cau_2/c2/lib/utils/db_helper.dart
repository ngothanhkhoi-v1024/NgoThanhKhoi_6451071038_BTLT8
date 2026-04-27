import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:path/path.dart';
import '../models/note.dart';
import '../models/note_category.dart';

class DBHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final DatabaseFactory factory = kIsWeb ? databaseFactoryFfiWeb : databaseFactory;
    String path = join(await getDatabasesPath(), 'notes_v2.db');

    return await factory.openDatabase(path, options: OpenDatabaseOptions(
      version: 1,
      onCreate: (db, version) async {
        await db.execute('CREATE TABLE categories(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)');
        await db.execute('''
          CREATE TABLE notes(
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            title TEXT, 
            content TEXT, 
            categoryId INTEGER,
            FOREIGN KEY (categoryId) REFERENCES categories (id) ON DELETE CASCADE
          )
        ''');
        await db.insert('categories', {'name': 'Công việc'});
        await db.insert('categories', {'name': 'Cá nhân'});
      },
    ));
  }

  Future<int> insertCategory(Category cat) async {
    final db = await database;
    return await db.insert('categories', cat.toMap());
  }

  Future<List<Category>> getCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('categories');
    return List.generate(maps.length, (i) => Category.fromMap(maps[i]));
  }

  Future<int> insertNote(Note note) async {
    final db = await database;
    return await db.insert('notes', note.toMap());
  }

  Future<List<Note>> getNotes({int? categoryId}) async {
    final db = await database;
    String query = '''
      SELECT notes.*, categories.name as categoryName 
      FROM notes 
      JOIN categories ON notes.categoryId = categories.id
    ''';
    if (categoryId != null) {
      query += ' WHERE notes.categoryId = $categoryId';
    }
    final List<Map<String, dynamic>> maps = await db.rawQuery(query);
    return List.generate(maps.length, (i) => Note.fromMap(maps[i]));
  }

  Future<int> deleteNote(int id) async {
    final db = await database;
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
}