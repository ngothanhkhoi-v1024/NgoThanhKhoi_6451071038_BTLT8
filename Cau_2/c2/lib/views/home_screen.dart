import 'package:flutter/material.dart';
import '../models/note.dart';
import '../models/note_category.dart';
import '../utils/db_helper.dart';
import 'note_editor_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DBHelper dbHelper = DBHelper();
  List<Note> notes = [];
  List<Category> categories = [];
  int? selectedFilterId;

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
              hintText: 'Ví dụ: Học tập',
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
                await dbHelper.insertCategory(Category(name: name));
                await _loadData();
              },
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );
    categoryController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final cats = await dbHelper.getCategories();
    final data = await dbHelper.getNotes(categoryId: selectedFilterId);
    setState(() {
      categories = cats;
      notes = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ghi chú theo danh mục'),
        actions: [
          IconButton(
            tooltip: 'Tạo danh mục',
            onPressed: _showAddCategoryDialog,
            icon: const Icon(Icons.create_new_folder_outlined),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: FilterChip(
                    label: const Text('Tất cả'),
                    selected: selectedFilterId == null,
                    onSelected: (_) {
                      setState(() => selectedFilterId = null);
                      _loadData();
                    },
                  ),
                ),
                ...categories.map((cat) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: FilterChip(
                    label: Text(cat.name),
                    selected: selectedFilterId == cat.id,
                    onSelected: (_) {
                      setState(() => selectedFilterId = cat.id);
                      _loadData();
                    },
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
      body: notes.isEmpty
          ? const Center(
              child: Text('Chưa có ghi chú. Bấm + để thêm mới.'),
            )
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(notes[index].title),
                subtitle: Text('${notes[index].categoryName} - ${notes[index].content}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    await dbHelper.deleteNote(notes[index].id!);
                    _loadData();
                  },
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => const NoteEditorScreen()));
          _loadData();
        },
      ),
    );
  }
}