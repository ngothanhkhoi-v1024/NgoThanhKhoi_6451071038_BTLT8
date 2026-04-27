import 'package:c3/models/task.dart';
import 'package:c3/utils/storage_utils.dart';
import 'package:sqflite/sqflite.dart';

class TaskController {
  Future<Database> get _db async => StorageUtils.database();

  Future<List<Task>> getTasks() async {
    final db = await _db;
    final rows = await db.query('tasks', orderBy: 'id DESC');
    return rows.map(Task.fromMap).toList();
  }

  Future<void> addTask(String title) async {
    final db = await _db;
    await db.insert(
      'tasks',
      Task(title: title, isDone: false).toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> setDone(Task task, bool done) async {
    final db = await _db;
    await db.update(
      'tasks',
      task.copyWith(isDone: done).toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> deleteTask(int id) async {
    final db = await _db;
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<String> exportTasks() async {
    final tasks = await getTasks();
    return StorageUtils.exportJson(tasks);
  }

  Future<void> importTasks() async {
    final tasks = await StorageUtils.importJson();
    final db = await _db;
    await db.transaction((txn) async {
      await txn.delete('tasks');
      for (final task in tasks) {
        await txn.insert(
          'tasks',
          task.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }
}
