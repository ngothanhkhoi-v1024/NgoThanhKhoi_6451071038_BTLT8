import 'package:c6/models/image_item.dart';
import 'package:c6/utils/database_helper.dart';
import 'package:c6/utils/file_helper.dart';
import 'package:flutter/foundation.dart';

class ImageController extends ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  final FileHelper _fileHelper = FileHelper();

  List<ImageItem> _images = <ImageItem>[];
  bool _isLoading = false;

  List<ImageItem> get images => _images;
  bool get isLoading => _isLoading;

  Future<void> loadImages() async {
    _isLoading = true;
    notifyListeners();

    _images = await _databaseHelper.getImages();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addMockImage() async {
    final String filePath = await _fileHelper.saveMockImage();
    await _databaseHelper.insertImage(ImageItem(path: filePath));
    await loadImages();
  }
}
