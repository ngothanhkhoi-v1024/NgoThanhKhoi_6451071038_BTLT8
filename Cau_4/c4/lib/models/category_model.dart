class CategoryModel {
  const CategoryModel({
    this.id,
    required this.name,
  });

  final int? id;
  final String name;

  factory CategoryModel.fromMap(Map<String, Object?> map) {
    return CategoryModel(
      id: map['id'] as int?,
      name: (map['name'] as String?) ?? '',
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
