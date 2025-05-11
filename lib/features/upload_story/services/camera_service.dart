import 'dart:async';
import 'dart:developer' show log;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/utils/constants.dart';
import 'package:storyzz/features/upload_story/presentation/providers/upload_story_provider.dart';
import 'package:storyzz/features/upload_story/utils/web_utils.dart';

class CameraService {
  CameraController? _cameraController;
  BuildContext? _context;
  late final WebUtils _webUtils = WebUtils();
  late AppLocalizations _localizations;
  late UploadStoryProvider _uploadStoryProvider;
  final AppService appService = AppService();

  void initialize(BuildContext context) {
    _context = context;
    _localizations = AppLocalizations.of(_context!)!;
    _uploadStoryProvider = Provider.of<UploadStoryProvider>(
      context,
      listen: false,
    );
  }

  void cleanup() {
    _cameraController?.dispose();
    _cameraController = null;

    if (_context != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _uploadStoryProvider.setCameraInitialized(false);
        _uploadStoryProvider.setShowCamera(false);
      });
    }
  }

  Future<void> handleWebCamera() async {
    if (!appService.getKIsWeb() || _context == null) return;

    final context = _context!;

    // if it's mobile Chrome
    if (_webUtils.isMobileChrome()) {
      try {
        // try standard camera plugin first
        final bool hasPermission = await _requestCameraPermissionWeb();
        if (hasPermission) {
          await _initializeCameraWeb();
        } else {
          // if that fails, use fallback method
          if (context.mounted) {
            await _webUtils.useFallbackCameraInput(context);
          }
        }
      } catch (e) {
        log('Standard camera access failed, trying fallback: $e');
        if (context.mounted) {
          await _webUtils.useFallbackCameraInput(context);
        }
      }
    } else {
      // for desktop web and others, use the original implementation
      final bool hasPermission = await _requestCameraPermissionWeb();
      if (hasPermission) {
        await _initializeCameraWeb();
      }
    }
  }

  Future<bool> _requestCameraPermissionWeb() async {
    if (_context == null) return false;
    final context = _context!;
    final provider = Provider.of<UploadStoryProvider>(context, listen: false);

    if (provider.isRequestingPermission) return false;

    provider.setRequestingPermission(true);

    try {
      final hasPermission = await _webUtils.requestCameraPermissionWeb();

      if (hasPermission) {
        // get available cameras
        final cameras = await availableCameras();

        if (cameras.isNotEmpty) {
          provider.setCameras(cameras);
          provider.setRequestingPermission(false);
          return true;
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_localizations.camera_access_denied)),
          );
        }
      }

      provider.setRequestingPermission(false);
      return false;
    } catch (e) {
      log('Camera access error details: $e');

      if (_context != null && _context!.mounted) {
        String errorMessage = '${_localizations.camera_access_denied} $e';
        if (e.toString().contains('notReadable')) {
          errorMessage = _localizations.camera_used_by_other;
        }

        ScaffoldMessenger.of(
          _context!,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
      }

      provider.setRequestingPermission(false);
      return false;
    }
  }

  Future<void> _initializeCameraWeb() async {
    if (_context == null) return;
    final context = _context!;
    final provider = Provider.of<UploadStoryProvider>(context, listen: false);
    final cameras = provider.cameras;

    if (cameras != null && cameras.isNotEmpty) {
      final isChromeMobile = _webUtils.isMobileChrome();

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

        // initialize with proper settings
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

        if (context.mounted) {
          provider.setCameraInitialized(true);
          provider.setShowCamera(true);
        }
      } catch (e) {
        log('Camera initialization error: $e');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${_localizations.error_initializing_camera} $e'),
            ),
          );
        }
        cleanup();

        // automatically try fallback on error for mobile Chrome
        if (isChromeMobile && context.mounted) {
          await _webUtils.useFallbackCameraInput(context);
        }
      }
    }
  }

  Future<void> takePictureWeb() async {
    if (_context == null) return;
    final context = _context!;

    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      final XFile picture = await _cameraController!.takePicture();

      final bytes = await picture.readAsBytes();
      final fileSize = bytes.lengthInBytes;

      if (fileSize > 1048576) {
        // File too big
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_localizations.image_too_large)),
          );
        }
      } else {
        if (context.mounted) {
          final provider = Provider.of<UploadStoryProvider>(
            context,
            listen: false,
          );
          provider.setImageFile(picture);
          provider.setShowCamera(false);
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${_localizations.error_taking_picture} $e')),
        );
      }
    }
  }

  Future<void> switchCamera() async {
    if (_context == null) return;
    final context = _context!;
    final provider = Provider.of<UploadStoryProvider>(context, listen: false);
    final cameras = provider.cameras;

    if (cameras == null || cameras.length <= 1 || _cameraController == null) {
      return;
    }

    final currentLensDirection = _cameraController!.description.lensDirection;
    CameraDescription newCamera;

    if (currentLensDirection == CameraLensDirection.back) {
      newCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras[0],
      );
    } else {
      newCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras[0],
      );
    }

    // temporarily set camera as not initialized while switching
    provider.setCameraInitialized(false);

    await _cameraController!.dispose();
    _cameraController = CameraController(newCamera, ResolutionPreset.medium);

    try {
      await _cameraController!.initialize();
      // mark camera as initialized again
      if (context.mounted) {
        provider.setCameraInitialized(true);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_localizations.error_switching_camera} $e'),
          ),
        );
      }
    }
  }

  CameraController? get cameraController => _cameraController;
}
