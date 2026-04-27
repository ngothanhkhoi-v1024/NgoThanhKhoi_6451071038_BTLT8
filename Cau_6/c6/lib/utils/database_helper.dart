import 'package:c6/models/image_item.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String dbPath = await getDatabasesPath();
    final String path = p.join(dbPath, 'images.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE images(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            path TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insertImage(ImageItem item) async {
    final Database db = await database;
    return db.insert('images', item.toMap());
  }

  Future<List<ImageItem>> getImages() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'images',
      orderBy: 'id DESC',
    );
    return maps.map(ImageItem.fromMap).toList();
  }
}
