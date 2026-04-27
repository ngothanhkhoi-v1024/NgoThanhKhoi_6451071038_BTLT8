import 'package:flutter/material.dart';
import '../models/note.dart';
import '../models/note_category.dart';
import '../utils/db_helper.dart';

class NoteEditorScreen extends StatefulWidget {
  const NoteEditorScreen({super.key});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final DBHelper dbHelper = DBHelper();
  List<Category> categories = [];
  int? selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final cats = await dbHelper.getCategories();
    setState(() {
      categories = cats;
      if (cats.isNotEmpty) selectedCategoryId = cats[0].id;
    });
  }

  Future<void> _showAddCategoryDialog() async {
    final TextEditingController categoryController = TextEditingController();
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tạo danh mục'),
          content: TextField(
            controller: categoryController,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Tên danh mục',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () async {
                final String name = categoryController.text.trim();
                if (name.isEmpty) return;
                Navigator.pop(context);
                final int id = await dbHelper.insertCategory(Category(name: name));
                await _loadCategories();
                if (!mounted) return;
                setState(() {
                  selectedCategoryId = id;
                });
              },
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );
    categoryController.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (selectedCategoryId == null) return;
    await dbHelper.insertNote(Note(
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      categoryId: selectedCategoryId!,
    ));
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thêm ghi chú')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<int>(
                key: ValueKey<int?>(selectedCategoryId),
                initialValue: selectedCategoryId,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Danh mục',
                  border: OutlineInputBorder(),
                ),
                items: categories.map((cat) => DropdownMenuItem<int>(
                  value: cat.id,
                  child: Text(cat.name),
                )).toList(),
                hint: const Text('Chọn danh mục'),
                onChanged: categories.isEmpty
                    ? null
                    : (val) => setState(() => selectedCategoryId = val),
                validator: (value) => value == null ? 'Vui lòng chọn danh mục' : null,
              ),
              if (categories.isEmpty) ...[
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: _showAddCategoryDialog,
                    icon: const Icon(Icons.add),
                    label: const Text('Chưa có danh mục, bấm để tạo'),
                  ),
                ),
              ],
              const SizedBox(height: 12),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Tiêu đề',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Vui lòng nhập tiêu đề'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _contentController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Nội dung',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Vui lòng nhập nội dung'
                    : null,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _save,
                  child: const Text('Lưu'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}