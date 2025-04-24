import 'dart:async';
import 'dart:convert';
import 'dart:developer' show log;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/features/upload_story/presentation/providers/upload_story_provider.dart';
import 'package:universal_html/html.dart' as html;

class WebUtils {
  bool isMobileChrome() {
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

  Future<bool> requestCameraPermissionWeb() async {
    try {
      final isChromeMobile = isMobileChrome();

      // Handling for Chrome on mobile
      final videoConstraints =
          isChromeMobile
              ? {
                'facingMode': {
                  'exact': 'environment', // Force to use back camera
                },
                'width': {'ideal': 720, 'max': 1280},
                'height': {'ideal': 480, 'max': 720},
              }
              : true;

      // Request camera permission with specific constraints
      await html.window.navigator.mediaDevices!.getUserMedia({
        'video': videoConstraints,
        'audio': false,
      });

      return true;
    } catch (e) {
      log('Camera permission request failed: $e');
      return false;
    }
  }

  Future<void> useFallbackCameraInput(BuildContext context) async {
    try {
      // Create file input with camera capture attribute
      final inputElement =
          html.FileUploadInputElement()
            ..accept = 'image/*'
            ..setAttribute('capture', 'environment');

      // Add to DOM temporarily
      html.document.body!.append(inputElement);

      // Trigger click
      inputElement.click();

      // Create a completer to handle async file selection
      final completer = Completer<void>();

      // Listen for changes
      inputElement.onChange.listen((event) async {
        if (inputElement.files!.isNotEmpty) {
          final file = inputElement.files![0];
          final reader = html.FileReader();
          reader.readAsArrayBuffer(file);

          reader.onLoad.listen((event) async {
            final bytes = reader.result as Uint8List;
            if (bytes.lengthInBytes > 1048576) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppLocalizations.of(context)!.image_too_large,
                    ),
                  ),
                );
              }
            } else {
              if (context.mounted) {
                // Create XFile from bytes
                final path = 'data:image/jpeg;base64,${base64Encode(bytes)}';
                final xFile = XFile.fromData(
                  bytes,
                  name: file.name,
                  path: path,
                  mimeType: file.type,
                );
                Provider.of<UploadStoryProvider>(
                  context,
                  listen: false,
                ).setImageFile(xFile);
              }
            }
            completer.complete();
          });
        } else {
          completer.complete(); // Complete even if no file was selected
        }
        // Remove from DOM
        inputElement.remove();
      });

      return completer.future;
    } catch (e) {
      log('Fallback camera error: $e');
      if (context.mounted) {
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
}
