import 'package:flutter/material.dart';

import '../controller/expense_controller.dart';
import '../models/category_model.dart';
import '../models/expense_model.dart';
import '../widget/expense_card.dart';
import '../widget/total_by_category_card.dart';

class ExpenseHomeView extends StatefulWidget {
  const ExpenseHomeView({super.key});

  @override
  State<ExpenseHomeView> createState() => _ExpenseHomeViewState();
}

class _ExpenseHomeViewState extends State<ExpenseHomeView> {
  final ExpenseController _controller = ExpenseController();

  @override
  void initState() {
    super.initState();
    _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Quản lý chi tiêu - MSSV: 6451071038'),
          ),
          body: _controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: TotalByCategoryCard(
                        totals: _controller.totalsByCategory,
                      ),
                    ),
                    Expanded(
                      child: _controller.expenses.isEmpty
                          ? const Center(
                              child: Text('Chưa có khoản chi tiêu nào'),
                            )
                          : ListView.builder(
                              itemCount: _controller.expenses.length,
                              itemBuilder: (context, index) {
                                final expense = _controller.expenses[index];
                                return ExpenseCard(
                                  expense: expense,
                                  onEdit: () => _openExpenseDialog(expense),
                                  onDelete: () =>
                                      _controller.removeExpense(expense.id!),
                                );
                              },
                            ),
                    ),
                  ],
                ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _openExpenseDialog(),
            icon: const Icon(Icons.add),
            label: const Text('Thêm chi tiêu'),
          ),
        );
      },
    );
  }

  Future<void> _openExpenseDialog([ExpenseModel? editingExpense]) async {
    final amountController = TextEditingController(
      text: editingExpense?.amount.toStringAsFixed(0) ?? '',
    );
    final noteController = TextEditingController(
      text: editingExpense?.note ?? '',
    );

    int? selectedCategoryId =
        editingExpense?.categoryId ??
        (_controller.categories.isNotEmpty ? _controller.categories.first.id : null);

    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text(editingExpense == null ? 'Thêm chi tiêu' : 'Sửa chi tiêu'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Số tiền',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: noteController,
                      decoration: const InputDecoration(
                        labelText: 'Ghi chú',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<int>(
                      initialValue: selectedCategoryId,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                      items: _controller.categories
                          .where((c) => c.id != null)
                          .map(
                            (CategoryModel category) => DropdownMenuItem<int>(
                              value: category.id!,
                              child: Text(category.name),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setStateDialog(() {
                          selectedCategoryId = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Hủy'),
                ),
                FilledButton(
                  onPressed: () async {
                    final navigator = Navigator.of(context);
                    final amount = double.tryParse(amountController.text.trim());
                    final note = noteController.text.trim();
                    final categoryId = selectedCategoryId;

                    if (amount == null || amount <= 0 || note.isEmpty || categoryId == null) {
                      return;
                    }

                    if (editingExpense == null) {
                      await _controller.addExpense(
                        amount: amount,
                        note: note,
                        categoryId: categoryId,
                      );
                    } else {
                      await _controller.editExpense(
                        id: editingExpense.id!,
                        amount: amount,
                        note: note,
                        categoryId: categoryId,
                      );
                    }

                    navigator.pop();
                  },
                  child: const Text('Lưu'),
                ),
              ],
            );
          },
        );
      },
    );

    amountController.dispose();
    noteController.dispose();
  }
}
