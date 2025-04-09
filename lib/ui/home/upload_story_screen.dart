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
  // image picker for mobile and web platform
  final ImagePicker _picker = ImagePicker();

  // Camera controller is kept in UI component since it's a hardware resource
  CameraController? _cameraController;

  @override
  void dispose() {
    _cleanupCamera();
    super.dispose();
  }

  void _cleanupCamera() {
    _cameraController?.dispose();
    _cameraController = null;

    // Reset camera state in provider
    if (mounted) {
      context.read<UploadStoryProvider>().setCameraInitialized(false);
      context.read<UploadStoryProvider>().setShowCamera(false);
    }
  }

  // request camera permission for website
  Future<bool> _requestCameraPermissionWeb() async {
    final provider = context.read<UploadStoryProvider>();
    if (provider.isRequestingPermission) return false;

    provider.setRequestingPermission(true);

    try {
      // request camera permission for web
      await html.window.navigator.mediaDevices!.getUserMedia({
        'video': true,
        'audio': false,
      });

      // get available cameras
      final cameras = await availableCameras();

      if (cameras.isNotEmpty) {
        provider.setCameras(cameras);
        provider.setRequestingPermission(false);
        return true;
      }
      return false;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Camera access denied: $e')));
      }
      provider.setRequestingPermission(false);
      return false;
    }
  }

  Future<void> _initializeCameraWeb() async {
    final provider = context.read<UploadStoryProvider>();
    final cameras = provider.cameras;

    if (cameras != null && cameras.isNotEmpty) {
      _cameraController = CameraController(cameras[0], ResolutionPreset.medium);

      try {
        await _cameraController!.initialize();
        if (mounted) {
          provider.setCameraInitialized(true);
          provider.setShowCamera(true);
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
          final provider = context.read<UploadStoryProvider>();
          provider.setImageFile(picture);
          provider.setShowCamera(false);
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
    final uploadProvider = context.read<UploadStoryProvider>();
    final authProvider = context.read<AuthProvider>();

    final imageFile = uploadProvider.imageFile;
    final caption = uploadProvider.caption;

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
      uploadProvider.reset();
    } else if (uploadProvider.errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(uploadProvider.errorMessage!)));
    }
  }

  Widget _buildCameraViewWeb() {
    final provider = context.watch<UploadStoryProvider>();

    if (provider.isRequestingPermission) {
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

    if (!provider.isCameraInitialized ||
        _cameraController == null ||
        !_cameraController!.value.isInitialized) {
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
                final cameras = provider.cameras;
                if (cameras != null && cameras.length > 1) {
                  final currentLensDirection =
                      _cameraController!.description.lensDirection;
                  CameraDescription newCamera;

                  if (currentLensDirection == CameraLensDirection.back) {
                    newCamera = cameras.firstWhere(
                      (camera) =>
                          camera.lensDirection == CameraLensDirection.front,
                      orElse: () => cameras[0],
                    );
                  } else {
                    newCamera = cameras.firstWhere(
                      (camera) =>
                          camera.lensDirection == CameraLensDirection.back,
                      orElse: () => cameras[0],
                    );
                  }

                  // temporarily set camera as not initialized while switching
                  context.read<UploadStoryProvider>().setCameraInitialized(
                    false,
                  );

                  await _cameraController!.dispose();
                  _cameraController = CameraController(
                    newCamera,
                    ResolutionPreset.medium,
                  );

                  try {
                    await _cameraController!.initialize();
                    // mark camera as initialized again
                    if (mounted) {
                      context.read<UploadStoryProvider>().setCameraInitialized(
                        true,
                      );
                    }
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
    final uploadProvider = context.watch<UploadStoryProvider>();

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
                    uploadProvider.isRequestingPermission
                        ? null
                        : () => _handleCameraButton(),
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
    final uploadProvider = context.watch<UploadStoryProvider>();
    final imageFile = uploadProvider.imageFile;
    final isUploading = uploadProvider.isLoading;
    final showCamera = uploadProvider.showCamera;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Upload Story',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          if (imageFile != null && !showCamera)
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
                    if (showCamera)
                      _buildCameraViewWeb()
                    else
                      _buildImagePreview(imageFile),
                    const SizedBox(height: 16),
                    if (imageFile != null && !showCamera) ...[
                      TextField(
                        decoration: const InputDecoration(
                          hintText: 'Write a caption...',
                        ),
                        maxLines: 3,
                        onChanged: (value) {
                          uploadProvider.setCaption(value);
                        },
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed:
                            isUploading ? null : () => uploadProvider.reset(),
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
