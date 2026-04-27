import '../models/dictionary_entry.dart';
import '../utils/database_helper.dart';

class DictionaryController {
  DictionaryController({DatabaseHelper? dbHelper})
      : _dbHelper = dbHelper ?? DatabaseHelper.instance;

  final DatabaseHelper _dbHelper;

  Future<void> initialize() async {
    await _dbHelper.seedDataIfNeeded();
  }

  Future<List<DictionaryEntry>> search(String query) async {
    return _dbHelper.searchWords(query);
  }
}
