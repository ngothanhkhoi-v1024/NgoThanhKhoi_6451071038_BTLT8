import 'package:c6/controller/image_controller.dart';
import 'package:c6/widget/image_tile.dart';
import 'package:flutter/material.dart';

class GalleryView extends StatefulWidget {
  const GalleryView({super.key});

  @override
  State<GalleryView> createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView> {
  late final ImageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ImageController();
    _controller.loadImages();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _addImage() async {
    await _controller.addMockImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bai 6 - MSSV: 6451071038'),
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, _) {
          if (_controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_controller.images.isEmpty) {
            return const Center(
              child: Text('Chua co anh offline. Bam + de tao anh.'),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: _controller.images.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemBuilder: (BuildContext context, int index) {
              return ImageTile(path: _controller.images[index].path);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addImage,
        child: const Icon(Icons.add),
      ),
    );
  }
}
