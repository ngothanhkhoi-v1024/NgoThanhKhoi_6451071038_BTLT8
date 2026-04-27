import 'package:flutter/material.dart';

import '../controller/dictionary_controller.dart';
import '../models/dictionary_entry.dart';
import '../widget/dictionary_item.dart';

class DictionaryView extends StatefulWidget {
  const DictionaryView({super.key});

  @override
  State<DictionaryView> createState() => _DictionaryViewState();
}

class _DictionaryViewState extends State<DictionaryView> {
  final TextEditingController _searchController = TextEditingController();
  final DictionaryController _controller = DictionaryController();

  List<DictionaryEntry> _results = <DictionaryEntry>[];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await _controller.initialize();
    final List<DictionaryEntry> items = await _controller.search('');
    if (!mounted) {
      return;
    }
    setState(() {
      _results = items;
      _isLoading = false;
    });
  }

  Future<void> _onSearchChanged(String keyword) async {
    final List<DictionaryEntry> items = await _controller.search(keyword);
    if (!mounted) {
      return;
    }
    setState(() {
      _results = items;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Từ điển offline - MSSV: 6451071038'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: const InputDecoration(
                labelText: 'Nhập từ cần tìm',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _results.isEmpty
                    ? const Center(child: Text('Không tìm thấy kết quả'))
                    : ListView.builder(
                        itemCount: _results.length,
                        itemBuilder: (BuildContext context, int index) {
                          return DictionaryItem(entry: _results[index]);
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
