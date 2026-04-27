import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class FileHelper {
  Future<String> saveMockImage() async {
    final Directory rootDir = await getApplicationDocumentsDirectory();
    final Directory imageDir = Directory(p.join(rootDir.path, 'images'));

    if (!await imageDir.exists()) {
      await imageDir.create(recursive: true);
    }

    final int now = DateTime.now().millisecondsSinceEpoch;
    final String filePath = p.join(imageDir.path, 'image_$now.bin');
    final File file = File(filePath);

    final List<int> fakeBytes = utf8.encode('offline-image-$now');
    await file.writeAsBytes(fakeBytes, flush: true);
    return filePath;
  }
}
