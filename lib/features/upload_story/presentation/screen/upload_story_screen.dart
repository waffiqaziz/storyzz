// file: lib/features/story/presentation/screens/upload_story_screen.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/provider/auth_provider.dart';
import 'package:storyzz/core/provider/story_provider.dart';
import 'package:storyzz/core/provider/upload_story_provider.dart';
import 'package:storyzz/core/routes/my_route_delegate.dart';
import 'package:storyzz/features/upload_story/presentation/widgets/camera_web_view.dart';
import 'package:storyzz/features/upload_story/presentation/widgets/image_preview.dart';
import 'package:storyzz/features/upload_story/presentation/widgets/location_map_selector.dart';
import 'package:storyzz/features/upload_story/services/camera_service.dart';
import 'package:storyzz/features/upload_story/services/image_picker_services.dart';

class UploadStoryScreen extends StatefulWidget {
  const UploadStoryScreen({super.key});

  @override
  State<UploadStoryScreen> createState() => _UploadStoryScreenState();
}

class _UploadStoryScreenState extends State<UploadStoryScreen> {
  late final CameraService _cameraService;
  late final ImagePickerService _imagePickerService;
  late UploadStoryProvider _uploadStoryProvider;

  @override
  void initState() {
    super.initState();
    _cameraService = CameraService();
    _imagePickerService = ImagePickerService();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _uploadStoryProvider = context.read<UploadStoryProvider>();

    // nitialize services with context
    _cameraService.initialize(context);
    _imagePickerService.initialize(context);
  }

  @override
  void dispose() {
    // clean up camera to prevent memory leak
    _cameraService.cleanup();
    super.dispose();
  }

  Future<void> _handleCameraButton() async {
    if (kIsWeb) {
      await _cameraService.handleWebCamera();
    } else {
      await _imagePickerService.pickImage(ImageSource.camera);
    }
  }

  Future<void> _uploadStory() async {
    final authProvider = context.read<AuthProvider>();

    final imageFile = _uploadStoryProvider.imageFile;
    final caption = _uploadStoryProvider.caption;

    if (imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.please_select_image),
        ),
      );
      return;
    }

    // caption must not empty
    if (caption.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.please_write_caption),
        ),
      );
      return;
    }

    authProvider.getUser();
    _uploadStoryProvider.reset();

    final token = authProvider.user?.token ?? "";
    double? lat;
    double? lon;

    // Include location data if user has enabled it
    if (_uploadStoryProvider.includeLocation &&
        _uploadStoryProvider.selectedLocation != null) {
      lat = _uploadStoryProvider.selectedLocation!.latitude;
      lon = _uploadStoryProvider.selectedLocation!.longitude;
    }

    await _uploadStoryProvider.uploadStoryWithFile(
      token: token,
      description: caption,
      imageFile: imageFile,
      lat: lat,
      lon: lon,
    );

    if (!mounted) return;

    if (_uploadStoryProvider.isSuccess) {
      _cameraService.cleanup();

      // navigate to home screen
      context.read<MyRouteDelegate>().navigateToHome();

      await context.read<StoryProvider>().refreshStories(
        user: authProvider.user!,
      );

      // show snackbar upload success
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.story_upload_success),
          ),
        );
      }
      _uploadStoryProvider.reset();
    } else if (_uploadStoryProvider.errorMessage != null) {
      // show snackbar upload failed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_uploadStoryProvider.errorMessage!)),
      );
    }
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
                      CameraViewWeb(cameraService: _cameraService)
                    else
                      ImagePreview(
                        imageFile: imageFile,
                        onCameraPressed: _handleCameraButton,
                        onGalleryPressed:
                            () => _imagePickerService.pickImage(
                              ImageSource.gallery,
                            ),
                      ),
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

                      // Location Map Selector here
                      LocationMapSelector(),
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
