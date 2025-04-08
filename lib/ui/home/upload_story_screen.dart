import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/provider/auth_provider.dart';
import 'package:storyzz/core/provider/story_provider.dart';
import 'package:storyzz/core/provider/upload_story_provider.dart';
import 'package:storyzz/core/routes/my_route_delegate.dart';
import 'package:universal_html/html.dart' as html;

class UploadStoryScreen extends StatefulWidget {
  const UploadStoryScreen({super.key});

  @override
  State<UploadStoryScreen> createState() => _UploadStoryScreenState();
}

class _UploadStoryScreenState extends State<UploadStoryScreen> {
  // image picker for mobile and web plaform, camera for mobile platform
  final ImagePicker _picker = ImagePicker();

  // camera for web platform
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false; // flag
  bool _showCamera = false; // flag for show camera permission
  bool _requestingPermission = false; // flag for camera web permission

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  void _cleanupCamera() {
    _cameraController?.dispose();
    _cameraController = null;
    _isCameraInitialized = false;
    _showCamera = false;
    if (mounted) {
      setState(() {});
    }
  }

  // request camera permission for website
  Future<bool> _requestCameraPermissionWeb() async {
    if (_requestingPermission) return false;

    setState(() {
      _requestingPermission = true;
    });

    try {
      // request camera permission for web
      await html.window.navigator.mediaDevices!.getUserMedia({
        'video': true,
        'audio': false,
      });

      // get available cameras
      final cameras = await availableCameras();

      if (cameras.isNotEmpty) {
        setState(() {
          _cameras = cameras;
          _requestingPermission = false;
        });
        return true;
      }
      return false;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Camera access denied: $e')));
      }
      setState(() {
        _requestingPermission = false;
      });
      return false;
    }
  }

  Future<void> _initializeCameraWeb() async {
    if (_cameras != null && _cameras!.isNotEmpty) {
      _cameraController = CameraController(
        _cameras![0],
        ResolutionPreset.medium,
      );

      try {
        await _cameraController!.initialize();
        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
            _showCamera = true;
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error initializing camera: $e')),
          );
        }
        _cleanupCamera();
      }
    }
  }

  Future<void> _takePicture() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      final XFile picture = await _cameraController!.takePicture();

      int fileSize = 0;
      Uint8List? bytes = await picture.readAsBytes();
      fileSize = bytes.lengthInBytes;

      if (fileSize > 1048576) {
        // file too big
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Image is too large. Maximum size is 1MB.'),
            ),
          );
        }
      } else {
        if (mounted) {
          context.read<UploadStoryProvider>().setImageFile(picture);
          setState(() {
            _showCamera = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error taking picture: $e')));
      }
    }
  }

  Future<void> _handleCameraButton() async {
    if (kIsWeb) {
      // for web, request permission and initialize camera only when button is pressed
      final bool hasPermission = await _requestCameraPermissionWeb();
      if (hasPermission) {
        await _initializeCameraWeb();
      }
    } else {
      // for mobile, use the standard image picker
      _pickImage(ImageSource.camera);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    // for web platform and camera source, use custom camera implementation
    if (kIsWeb && source == ImageSource.camera) {
      await _handleCameraButton();
      return;
    }

    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        int fileSize = 0;

        if (kIsWeb) {
          // Web: use `readAsBytes()` to get size
          Uint8List bytes = await pickedFile.readAsBytes();
          fileSize = bytes.lengthInBytes;
        } else {
          // Mobile: use File
          final file = File(pickedFile.path);
          fileSize = await file.length();
        }

        if (fileSize > 1048576) {
          // File too big
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Image is too large. Maximum size is 1MB.'),
              ),
            );
          }
        } else {
          if (mounted) {
            context.read<UploadStoryProvider>().setImageFile(pickedFile);
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
      }
    }
  }

  Future<void> _uploadStory() async {
    final formProvider = context.read<UploadStoryProvider>();
    final uploadProvider = context.read<UploadStoryProvider>();
    final authProvider = context.read<AuthProvider>();

    final imageFile = formProvider.imageFile;
    final caption = formProvider.caption;

    if (imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image first')),
      );
      return;
    }

    authProvider.getUser();
    uploadProvider.reset();

    final token = authProvider.user?.token ?? "";

    if (kIsWeb) {
      final bytes = await imageFile.readAsBytes();
      await uploadProvider.uploadStory(
        token: token,
        description: caption,
        photoBytes: bytes,
        fileName: imageFile.name,
      );
    } else {
      final file = File(imageFile.path);
      await uploadProvider.uploadStory(
        token: token,
        description: caption,
        photoFile: file,
        fileName: imageFile.name,
      );
    }

    if (!mounted) return;

    if (uploadProvider.isSuccess) {
      _cleanupCamera();

      // refresh to get the latest story
      context.read<StoryProvider>().refreshStories(user: authProvider.user!);

      // navigate to home screen
      final routeDelegate =
          Router.of(context).routerDelegate as MyRouteDelegate;
      routeDelegate.navigateToHome();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Story uploaded successfully!')),
      );
      formProvider.reset();
    } else if (uploadProvider.errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(uploadProvider.errorMessage!)));
    }
  }

  Widget _buildCameraViewWeb() {
    if (_requestingPermission) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Requesting camera permission...'),
          ],
        ),
      );
    }

    if (!_isCameraInitialized || _cameraController == null) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Initializing camera...'),
          ],
        ),
      );
    }

    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CameraPreview(_cameraController!),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                _cleanupCamera();
              },
            ),
            ElevatedButton(
              onPressed: _takePicture,
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(16),
              ),
              child: Icon(
                Icons.camera_alt,
                size: 32,
                color: Theme.of(context).colorScheme.onTertiary,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.flip_camera_android),
              onPressed: () async {
                if (_cameras != null && _cameras!.length > 1) {
                  final currentLensDirection =
                      _cameraController!.description.lensDirection;
                  CameraDescription newCamera;

                  if (currentLensDirection == CameraLensDirection.back) {
                    newCamera = _cameras!.firstWhere(
                      (camera) =>
                          camera.lensDirection == CameraLensDirection.front,
                      orElse: () => _cameras![0],
                    );
                  } else {
                    newCamera = _cameras!.firstWhere(
                      (camera) =>
                          camera.lensDirection == CameraLensDirection.back,
                      orElse: () => _cameras![0],
                    );
                  }

                  await _cameraController!.dispose();
                  _cameraController = CameraController(
                    newCamera,
                    ResolutionPreset.medium,
                  );

                  try {
                    await _cameraController!.initialize();
                    setState(() {});
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error switching camera: $e')),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.image, size: 80, color: Colors.grey),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed:
                    _requestingPermission ? null : () => _handleCameraButton(),
                icon: Icon(
                  Icons.photo_camera,
                  color: Theme.of(context).colorScheme.onTertiary,
                ),
                label: Text(
                  'Camera',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onTertiary,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () => _pickImage(ImageSource.gallery),
                icon: Icon(
                  Icons.photo_library,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
                label: Text(
                  'Gallery',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview(XFile? imageFile) {
    if (imageFile == null) {
      return _buildImagePlaceholder();
    }

    return Container(
      constraints: const BoxConstraints(maxHeight: 400),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child:
          kIsWeb
              ? Image.network(imageFile.path)
              : Image.file(File(imageFile.path)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formProvider = context.watch<UploadStoryProvider>();
    final isUploading = context.watch<UploadStoryProvider>().isLoading;
    final imageFile = formProvider.imageFile;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Upload Story',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          if (imageFile != null && !_showCamera)
            Container(
              margin: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                icon: const Icon(Icons.check),
                onPressed: isUploading ? null : _uploadStory,
              ),
            ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 475),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_showCamera)
                      _buildCameraViewWeb()
                    else
                      _buildImagePreview(imageFile),
                    const SizedBox(height: 16),
                    if (imageFile != null && !_showCamera) ...[
                      TextField(
                        decoration: const InputDecoration(
                          hintText: 'Write a caption...',
                        ),
                        maxLines: 3,
                        onChanged: (value) {
                          formProvider.setCaption(value);
                        },
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed:
                            isUploading ? null : () => formProvider.reset(),
                        icon: Icon(
                          Icons.refresh,
                          color:
                              Theme.of(
                                context,
                              ).colorScheme.surfaceContainerLowest,
                        ),
                        label: const Text('Change Image'),
                      ),
                    ],
                    if (isUploading) ...[
                      const SizedBox(height: 16),
                      const LinearProgressIndicator(),
                      const SizedBox(height: 8),
                      const Center(child: Text('Uploading story...')),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
