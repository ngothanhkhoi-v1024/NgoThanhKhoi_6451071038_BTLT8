import 'package:flutter/foundation.dart';

import '../models/category_model.dart';
import '../models/expense_model.dart';
import '../utils/database_helper.dart';

class ExpenseController extends ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  List<CategoryModel> categories = <CategoryModel>[];
  List<ExpenseModel> expenses = <ExpenseModel>[];
  Map<String, double> totalsByCategory = <String, double>{};
  bool isLoading = false;

  Future<void> initialize() async {
    await _loadAllData();
  }

  Future<void> _loadAllData() async {
    isLoading = true;
    notifyListeners();

    categories = await _databaseHelper.getCategories();
    expenses = await _databaseHelper.getExpenses();
    totalsByCategory = await _databaseHelper.getTotalByCategory();

    isLoading = false;
    notifyListeners();
  }

  Future<void> addExpense({
    required double amount,
    required String note,
    required int categoryId,
  }) async {
    final expense = ExpenseModel(
      amount: amount,
      note: note,
      categoryId: categoryId,
    );
    await _databaseHelper.insertExpense(expense);
    await _loadAllData();
  }

  Future<void> editExpense({
    required int id,
    required double amount,
    required String note,
    required int categoryId,
  }) async {
    final expense = ExpenseModel(
      id: id,
      amount: amount,
      note: note,
      categoryId: categoryId,
    );
    await _databaseHelper.updateExpense(expense);
    await _loadAllData();
  }

  Future<void> removeExpense(int id) async {
    await _databaseHelper.deleteExpense(id);
    await _loadAllData();
  }
}
