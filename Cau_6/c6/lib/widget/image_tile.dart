import 'dart:io';

import 'package:flutter/material.dart';

class ImageTile extends StatelessWidget {
  final String path;

  const ImageTile({
    super.key,
    required this.path,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        color: Colors.grey.shade200,
        child: Image.file(
          File(path),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Icon(Icons.broken_image_outlined),
            );
          },
        ),
      ),
    );
  }
}
