import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/features/upload_story/presentation/providers/upload_story_provider.dart';
import 'package:storyzz/features/upload_story/services/camera_service.dart';

class CameraViewWeb extends StatelessWidget {
  final CameraService cameraService;

  const CameraViewWeb({super.key, required this.cameraService});

  @override
  Widget build(BuildContext context) {
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
        cameraService.cameraController == null ||
        !cameraService.cameraController!.value.isInitialized) {
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
            child: CameraPreview(cameraService.cameraController!),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                cameraService.cleanup();
              },
            ),
            ElevatedButton(
              onPressed: () => cameraService.takePictureWeb(),
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
              onPressed: () => cameraService.switchCamera(),
            ),
          ],
        ),
      ],
    );
  }
}
