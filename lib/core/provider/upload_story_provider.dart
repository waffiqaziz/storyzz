import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:storyzz/core/data/repository/story_repository.dart';

class UploadStoryProvider extends ChangeNotifier {
  final StoryRepository _storyRepository;

  UploadStoryProvider(this._storyRepository);

  bool _isLoading = false;
  String? _errorMessage;
  bool _isSuccess = false;
  String _caption = '';
  XFile? _imageFile;

  // web camera-related properties
  bool _showCamera = false;
  bool _isCameraInitialized = false;
  bool _requestingPermission = false;
  List<CameraDescription>? _cameras;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSuccess => _isSuccess;
  String get caption => _caption;
  XFile? get imageFile => _imageFile;

  bool get showCamera => _showCamera;
  bool get isCameraInitialized => _isCameraInitialized;
  bool get isRequestingPermission => _requestingPermission;
  List<CameraDescription>? get cameras => _cameras;

  void setCaption(String caption) {
    _caption = caption;
    notifyListeners();
  }

  void setImageFile(XFile? file) {
    _imageFile = file;
    notifyListeners();
  }

  void setShowCamera(bool show) {
    _showCamera = show;
    notifyListeners();
  }

  void setCameraInitialized(bool initialized) {
    _isCameraInitialized = initialized;
    notifyListeners();
  }

  void setRequestingPermission(bool requesting) {
    _requestingPermission = requesting;
    notifyListeners();
  }

  void setCameras(List<CameraDescription> cameras) {
    _cameras = cameras;
    notifyListeners();
  }

  // reset all state
  void reset() {
    _isLoading = false;
    _isSuccess = false;
    _errorMessage = null;
    _caption = '';
    _imageFile = null;
    notifyListeners();
  }

  // reset camera-related state
  void resetCamera() {
    _showCamera = false;
    _isCameraInitialized = false;
    _requestingPermission = false;
    notifyListeners();
  }

  // reset all state including camera
  void resetAll() {
    reset();
    resetCamera();
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
