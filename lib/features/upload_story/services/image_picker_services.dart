import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/utils/constants.dart';
import 'package:storyzz/features/upload_story/presentation/providers/upload_story_provider.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();
  final AppService appService = AppService();
  BuildContext? _context;

  void initialize(BuildContext context) {
    _context = context;
  }

  Future<void> pickImage(ImageSource source) async {
    if (_context == null) return;
    final context = _context!;

    // For web platform and camera source, use custom camera implementation
    if (kIsWeb && source == ImageSource.camera) {
      // This should be handled by the Camera Service
      return;
    }

    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 50,
      );

      if (pickedFile != null) {
        int fileSize = 0;

        if (appService.getKIsWeb()) {
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
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!.image_too_large),
              ),
            );
          }
        } else {
          if (context.mounted) {
            Provider.of<UploadStoryProvider>(
              context,
              listen: false,
            ).setImageFile(pickedFile);
          }
        }
      }
    } catch (e) {
      if (context.mounted) {
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
}
