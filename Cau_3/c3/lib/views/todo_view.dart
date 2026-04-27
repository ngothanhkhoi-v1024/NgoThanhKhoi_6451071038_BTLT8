import 'package:c3/controller/task_controller.dart';
import 'package:c3/models/task.dart';
import 'package:c3/widget/task_item.dart';
import 'package:flutter/material.dart';

class TodoView extends StatefulWidget {
  const TodoView({super.key});

  @override
  State<TodoView> createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView> {
  final TaskController _controller = TaskController();
  final TextEditingController _inputController = TextEditingController();
  List<Task> _tasks = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final data = await _controller.getTasks();
    if (!mounted) {
      return;
    }
    setState(() {
      _tasks = data;
      _loading = false;
    });
  }

  Future<void> _add() async {
    final title = _inputController.text.trim();
    if (title.isEmpty) {
      return;
    }
    await _controller.addTask(title);
    _inputController.clear();
    await _load();
  }

  Future<void> _toggle(Task task, bool? value) async {
    await _controller.setDone(task, value ?? false);
    await _load();
  }

  Future<void> _delete(Task task) async {
    if (task.id == null) {
      return;
    }
    await _controller.deleteTask(task.id!);
    await _load();
  }

  Future<void> _export() async {
    final path = await _controller.exportTasks();
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Export thành công: $path')));
  }

  Future<void> _import() async {
    await _controller.importTasks();
    await _load();
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Import thành công')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('To-do List Backup JSON - MSSV: 6451071038')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _inputController,
                    decoration: const InputDecoration(
                      labelText: 'Nhập task',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _add(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: _add, child: const Text('Thêm')),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _export,
                    child: const Text('Export'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _import,
                    child: const Text('Import'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _tasks.isEmpty
                  ? const Center(child: Text('Chưa có task nào'))
                  : ListView.builder(
                      itemCount: _tasks.length,
                      itemBuilder: (context, index) {
                        final task = _tasks[index];
                        return TaskItem(
                          task: task,
                          onChanged: (value) => _toggle(task, value),
                          onDelete: () => _delete(task),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
