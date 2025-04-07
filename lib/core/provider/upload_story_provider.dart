import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:storyzz/core/data/repository/story_repository.dart';

class UploadStoryProvider extends ChangeNotifier {
  final StoryRepository _storyRepository;

  UploadStoryProvider(this._storyRepository);

  bool _isLoading = false;
  String? _errorMessage;
  bool _isSuccess = false;

  String _caption = '';
  XFile? _imageFile;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSuccess => _isSuccess;
  String get caption => _caption;
  XFile? get imageFile => _imageFile;

  void setCaption(String caption) {
    _caption = caption;
    notifyListeners();
  }

  void setImageFile(XFile? file) {
    _imageFile = file;
    notifyListeners();
  }

  void reset() {
    _isLoading = false;
    _isSuccess = false;
    _errorMessage = null;
    _caption = '';
    _imageFile = null;
    notifyListeners();
  }

  Future<void> uploadStory({
    required String token,
    required String description,
    File? photoFile,
    Uint8List? photoBytes,
    required String fileName,
    double? lat,
    double? lon,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _isSuccess = false;
    notifyListeners();

    final result = await _storyRepository.uploadStory(
      token: token,
      description: description,
      photoFile: photoFile,
      photoBytes: photoBytes,
      fileName: fileName,
      lat: lat,
      lon: lon,
    );

    if (result.data != null) {
      _isSuccess = true;
    } else {
      _errorMessage = result.message ?? "Unknown error occurred";
    }

    _isLoading = false;
    notifyListeners();
  }
}
