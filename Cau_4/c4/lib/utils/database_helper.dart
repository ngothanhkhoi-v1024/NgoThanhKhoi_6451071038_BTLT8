import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/category_model.dart';
import '../models/expense_model.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'expense_manager.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE categories(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE expenses(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount REAL NOT NULL,
        note TEXT NOT NULL,
        categoryId INTEGER NOT NULL,
        FOREIGN KEY(categoryId) REFERENCES categories(id) ON DELETE CASCADE
      )
    ''');

    await db.insert('categories', {'name': 'Ăn uống'});
    await db.insert('categories', {'name': 'Di chuyển'});
    await db.insert('categories', {'name': 'Mua sắm'});
    await db.insert('categories', {'name': 'Giải trí'});
  }

  Future<List<CategoryModel>> getCategories() async {
    final db = await database;
    final result = await db.query('categories', orderBy: 'id ASC');
    return result.map(CategoryModel.fromMap).toList();
  }

  Future<List<ExpenseModel>> getExpenses() async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT e.id, e.amount, e.note, e.categoryId, c.name as categoryName
      FROM expenses e
      INNER JOIN categories c ON c.id = e.categoryId
      ORDER BY e.id DESC
    ''');
    return result.map(ExpenseModel.fromMap).toList();
  }

  Future<Map<String, double>> getTotalByCategory() async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT c.name as categoryName, SUM(e.amount) as totalAmount
      FROM categories c
      LEFT JOIN expenses e ON c.id = e.categoryId
      GROUP BY c.id, c.name
      ORDER BY c.id ASC
    ''');

    final totals = <String, double>{};
    for (final row in result) {
      final category = (row['categoryName'] as String?) ?? 'Khác';
      final total = ((row['totalAmount'] as num?) ?? 0).toDouble();
      totals[category] = total;
    }
    return totals;
  }

  Future<void> insertExpense(ExpenseModel expense) async {
    final db = await database;
    await db.insert(
      'expenses',
      expense.toMap()..remove('id'),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateExpense(ExpenseModel expense) async {
    if (expense.id == null) return;
    final db = await database;
    await db.update(
      'expenses',
      expense.toMap()..remove('id'),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  Future<void> deleteExpense(int id) async {
    final db = await database;
    await db.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
