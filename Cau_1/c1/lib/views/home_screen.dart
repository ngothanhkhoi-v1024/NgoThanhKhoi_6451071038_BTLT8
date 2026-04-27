import 'package:flutter/material.dart';
import '../models/note.dart';
import '../utils/db_helper.dart';
import 'note_editor_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note> notes = [];
  final dbHelper = DBHelper();

  @override
  void initState() {
    super.initState();
    _refreshNotes();
  }

  _refreshNotes() async {
    final data = await dbHelper.getNotes();
    setState(() {
      notes = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ghi chú - MSSV: 6451071038')),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(notes[index].title),
          subtitle: Text(notes[index].content),
          trailing: IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () async {
              await dbHelper.deleteNote(notes[index].id!);
              _refreshNotes();
            },
          ),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NoteEditorScreen(note: notes[index])),
            );
            _refreshNotes();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NoteEditorScreen()),
          );
          _refreshNotes();
        },
      ),
    );
  }
}