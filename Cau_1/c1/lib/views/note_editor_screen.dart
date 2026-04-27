import 'package:flutter/material.dart';
import '../models/note.dart';
import '../utils/db_helper.dart';

class NoteEditorScreen extends StatefulWidget {
  final Note? note;
  NoteEditorScreen({this.note});

  @override
  _NoteEditorScreenState createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final dbHelper = DBHelper();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
  }

  _saveNote() async {
    final title = _titleController.text;
    final content = _contentController.text;

    if (title.isEmpty) {
      // Thông báo nếu để trống tiêu đề để biết nút CÓ ĐƯỢC ẤN
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng nhập tiêu đề')),
      );
      return;
    }

    if (widget.note == null) {
      await dbHelper.insertNote(Note(title: title, content: content));
    } else {
      await dbHelper.updateNote(Note(id: widget.note!.id, title: title, content: content));
    }

    // Kiểm tra xem Widget còn tồn tại không trước khi Pop
    if (!mounted) return;
    Navigator.pop(context, true); // Trả về 'true' để báo cho HomeScreen biết cần load lại
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.note == null ? 'Thêm mới' : 'Chỉnh sửa')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _titleController, decoration: InputDecoration(labelText: 'Tiêu đề')),
            TextField(controller: _contentController, decoration: InputDecoration(labelText: 'Nội dung')),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _saveNote, child: Text('Lưu'))
          ],
        ),
      ),
    );
  }
}