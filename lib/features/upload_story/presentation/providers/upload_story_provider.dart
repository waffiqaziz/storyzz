import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:storyzz/core/data/repositories/story_repository.dart';
import 'package:storyzz/core/utils/constants.dart';

/// Manages state for uploading user stories, including image selection and camera usage.
///
/// Handles:
/// - Uploading stories with image
/// - Managing loading, success, and error states
/// - Handling caption and image input
/// - Supporting camera integration (mobile and web platform)
///
/// Uses [StoryRepository] to perform the actual upload.
class UploadStoryProvider extends ChangeNotifier {
  final StoryRepository storyRepository;
  final AppService appService;

  UploadStoryProvider({
    required this.storyRepository,
    required this.appService,
  });

  // state properties
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

  // web camera-related properties
  bool _showCamera = false;
  bool _isCameraInitialized = false;
  bool _requestingPermission = false;
  List<CameraDescription>? _cameras;
  bool get showCamera => _showCamera;
  bool get isCameraInitialized => _isCameraInitialized;
  bool get isRequestingPermission => _requestingPermission;
  List<CameraDescription>? get cameras => _cameras;

  // location properties
  bool _includeLocation = false;
  LatLng? _selectedLocation;
  bool get includeLocation => _includeLocation;
  LatLng? get selectedLocation => _selectedLocation;

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

    final result = await storyRepository.uploadStory(
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

  Future<void> uploadStoryWithFile({
    required String token,
    required String description,
    required XFile imageFile,
    double? lat,
    double? lon,
  }) async {
    if (appService.getKIsWeb()) {
      final bytes = await imageFile.readAsBytes();
      return uploadStory(
        token: token,
        description: description,
        photoBytes: bytes,
        fileName: imageFile.name,
        lat: lat,
        lon: lon,
      );
    } else {
      final file = File(imageFile.path);
      return uploadStory(
        token: token,
        description: description,
        photoFile: file,
        fileName: imageFile.name,
        lat: lat,
        lon: lon,
      );
    }
  }

  void toggleLocationIncluded(bool value) {
    _includeLocation = value;
    notifyListeners();
  }

  void setSelectedLocation(LatLng? location) {
    _selectedLocation = location;
    notifyListeners();
  }
}
