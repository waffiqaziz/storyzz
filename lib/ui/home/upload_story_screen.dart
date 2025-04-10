import 'dart:async';
import 'dart:convert';
import 'dart:developer' show log;
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
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
  CameraController? _cameraController;

  @override
  void dispose() {
    _cleanupCamera();
    super.dispose();
  }

  void _cleanupCamera() {
    _cameraController?.dispose();
    _cameraController = null;

    // reset camera state in provider
    if (mounted) {
      context.read<UploadStoryProvider>().setCameraInitialized(false);
      context.read<UploadStoryProvider>().setShowCamera(false);
    }
  }

  bool _isMobileChrome() {
    if (!kIsWeb) return false;

    try {
      final userAgent = html.window.navigator.userAgent.toLowerCase();
      return userAgent.contains('chrome') &&
          (userAgent.contains('android') || userAgent.contains('mobile'));
    } catch (e) {
      log('Error detecting browser: $e');
      return false;
    }
  }

  // request camera permission for website
  Future<bool> _requestCameraPermissionWeb() async {
    final provider = context.read<UploadStoryProvider>();
    if (provider.isRequestingPermission) return false;

    provider.setRequestingPermission(true);

    try {
      final isChromeMobile = _isMobileChrome();

      // handling for Chrome on mobile
      final videoConstraints = isChromeMobile
          ? {
              'facingMode': {
                'exact': 'environment',
              }, // force to use back camera
              'width': {'ideal': 720, 'max': 1280},
              'height': {'ideal': 480, 'max': 720},
            }
          : true;

      // request camera permission with specific constraints
      await html.window.navigator.mediaDevices!.getUserMedia({
        'video': videoConstraints,
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
      log('Camera access error details: $e');

      if (mounted) {
        String errorMessage =
            '${AppLocalizations.of(context)!.camera_access_denied} $e';
        if (e.toString().contains('notReadable')) {
          errorMessage = AppLocalizations.of(context)!.camera_used_by_other;
        }

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
      }
      provider.setRequestingPermission(false);
      return false;
    }
  }

  // use this approach if _initializeCameraWeb not working
  Future<void> _useFallbackCameraInput() async {
    try {
      // create file input with camera capture attribute
      final inputElement = html.FileUploadInputElement()
        ..accept = 'image/*'
        ..setAttribute('capture', 'environment');

      // add to DOM temporarily
      html.document.body!.append(inputElement);

      // trigger click
      inputElement.click();

      // create a completer to handle async file selection
      final completer = Completer<void>();

      // listen for changes
      inputElement.onChange.listen((event) async {
        if (inputElement.files!.isNotEmpty) {
          final file = inputElement.files![0];
          final reader = html.FileReader();
          reader.readAsArrayBuffer(file);

          reader.onLoad.listen((event) async {
            final bytes = reader.result as Uint8List;
            if (bytes.lengthInBytes > 1048576) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppLocalizations.of(context)!.image_too_large,
                    ),
                  ),
                );
              }
            } else {
              if (mounted) {
                // create XFile from bytes
                final path = 'data:image/jpeg;base64,${base64Encode(bytes)}';
                final xFile = XFile.fromData(
                  bytes,
                  name: file.name,
                  path: path,
                  mimeType: file.type,
                );
                context.read<UploadStoryProvider>().setImageFile(xFile);
              }
            }
            completer.complete();
          });
        } else {
          completer.complete(); // complete even if no file was selected
        }
        // remove from DOM
        inputElement.remove();
      });

      return completer.future;
    } catch (e) {
      log('Fallback camera error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${AppLocalizations.of(context)!.error_accessing_camera} $e',
            ),
          ),
        );
      }
    }
  }

  Future<void> _initializeCameraWeb() async {
    final provider = context.read<UploadStoryProvider>();
    final cameras = provider.cameras;

    if (cameras != null && cameras.isNotEmpty) {
      final isChromeMobile = _isMobileChrome();

      // lower the resolution
      final preset = ResolutionPreset.medium;

      try {
        // find back camera for mobile
        CameraDescription cameraToUse = cameras[0];
        if (isChromeMobile && cameras.length > 1) {
          for (var camera in cameras) {
            if (camera.lensDirection == CameraLensDirection.back) {
              cameraToUse = camera;
              break;
            }
          }
        }

        // tnitialize with proper settings
        _cameraController = CameraController(
          cameraToUse,
          preset,
          enableAudio: false,
          imageFormatGroup: ImageFormatGroup.jpeg,
        );

        // add timeout to prevent hanging
        await _cameraController!.initialize().timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            throw TimeoutException('Camera initialization timed out');
          },
        );

        if (mounted) {
          provider.setCameraInitialized(true);
          provider.setShowCamera(true);
        }
      } catch (e) {
        log('Camera initialization error: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${AppLocalizations.of(context)!.error_initializing_camera} $e',
              ),
            ),
          );
        }
        _cleanupCamera();

        // automatically try fallback on error for mobile Chrome
        if (isChromeMobile) {
          await _useFallbackCameraInput();
        }
      }
    }
  }

  Future<void> _takePictureWeb() async {
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
            SnackBar(
              content: Text(AppLocalizations.of(context)!.image_too_large),
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${AppLocalizations.of(context)!.error_taking_picture} $e',
            ),
          ),
        );
      }
    }
  }

  Future<void> _handleCameraButton() async {
    if (kIsWeb) {
      // check if it's Chrome on Android
      final isChromeMobile = _isMobileChrome();

      if (isChromeMobile) {
        try {
          // try standard camera plugin first
          final bool hasPermission = await _requestCameraPermissionWeb();
          if (hasPermission) {
            await _initializeCameraWeb();
          } else {
            // if that fails, use fallback method
            await _useFallbackCameraInput();
          }
        } catch (e) {
          log('Standard camera access failed, trying fallback: $e');
          await _useFallbackCameraInput();
        }
      } else {
        // for desktop web, use the original implementation
        final bool hasPermission = await _requestCameraPermissionWeb();
        if (hasPermission) {
          await _initializeCameraWeb();
        }
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
        imageQuality: 50,
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
              SnackBar(
                content: Text(AppLocalizations.of(context)!.image_too_large),
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${AppLocalizations.of(context)!.error_picking_image} $e',
            ),
          ),
        );
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
        SnackBar(
          content: Text(AppLocalizations.of(context)!.please_select_image),
        ),
      );
      return;
    }

    if (caption.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.please_write_caption),
        ),
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
      context.read<MyRouteDelegate>().navigateToHome();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.story_upload_success),
        ),
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
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(AppLocalizations.of(context)!.request_camera_permission),
          ],
        ),
      );
    }

    if (!provider.isCameraInitialized ||
        _cameraController == null ||
        !_cameraController!.value.isInitialized) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(AppLocalizations.of(context)!.initializing_camera),
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
              onPressed: _takePictureWeb,
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
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${AppLocalizations.of(context)!.error_switching_camera} $e',
                          ),
                        ),
                      );
                    }
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
                onPressed: uploadProvider.isRequestingPermission
                    ? null
                    : () => _handleCameraButton(),
                icon: Icon(
                  Icons.photo_camera,
                  color: Theme.of(context).colorScheme.onTertiary,
                ),
                label: Text(
                  AppLocalizations.of(context)!.camera,
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
                  AppLocalizations.of(context)!.gallery,
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
      child: kIsWeb
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
        title: Text(
          AppLocalizations.of(context)!.upload_story,
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
                        decoration: InputDecoration(
                          hintText:
                              AppLocalizations.of(context)!.write_a_caption,
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
                          color: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerLowest,
                        ),
                        label: Text(AppLocalizations.of(context)!.change_image),
                      ),
                    ],
                    if (isUploading) ...[
                      const SizedBox(height: 16),
                      const LinearProgressIndicator(),
                      const SizedBox(height: 8),
                      Center(
                        child: Text(
                          AppLocalizations.of(context)!.uploading_story,
                        ),
                      ),
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
