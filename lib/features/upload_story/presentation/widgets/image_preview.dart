import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/utils/constants.dart';
import 'package:storyzz/features/upload_story/presentation/providers/upload_story_provider.dart';

/// Widget as image preview to shows selected image
/// whether from camera or gallery
class ImagePreview extends StatelessWidget {
  final XFile? imageFile;
  final VoidCallback onCameraPressed;
  final VoidCallback onGalleryPressed;

  const ImagePreview({
    super.key,
    required this.imageFile,
    required this.onCameraPressed,
    required this.onGalleryPressed,
  });

  Widget _buildImagePlaceholder(BuildContext context) {
    final uploadProvider = Provider.of<UploadStoryProvider>(context);

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
              // camera button
              ElevatedButton.icon(
                onPressed:
                    uploadProvider.isRequestingPermission
                        ? null
                        : onCameraPressed,
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

              // gallery button
              ElevatedButton.icon(
                onPressed: onGalleryPressed,
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

  @override
  Widget build(BuildContext context) {
    final AppService appService = AppService();

    if (imageFile == null) {
      return _buildImagePlaceholder(context);
    }

    return Container(
      constraints: const BoxConstraints(maxHeight: 400),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
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
          appService.getKIsWeb()
              ? Image.network(imageFile!.path)
              : Image.file(File(imageFile!.path)),
    );
  }
}
