class ExpenseModel {
  const ExpenseModel({
    this.id,
    required this.amount,
    required this.note,
    required this.categoryId,
    this.categoryName,
  });

  final int? id;
  final double amount;
  final String note;
  final int categoryId;
  final String? categoryName;

  factory ExpenseModel.fromMap(Map<String, Object?> map) {
    return ExpenseModel(
      id: map['id'] as int?,
      amount: ((map['amount'] as num?) ?? 0).toDouble(),
      note: (map['note'] as String?) ?? '',
      categoryId: (map['categoryId'] as int?) ?? 0,
      categoryName: map['categoryName'] as String?,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'amount': amount,
      'note': note,
      'categoryId': categoryId,
    };
  }

  ExpenseModel copyWith({
    int? id,
    double? amount,
    String? note,
    int? categoryId,
    String? categoryName,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      note: note ?? this.note,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
    );
  }
}
