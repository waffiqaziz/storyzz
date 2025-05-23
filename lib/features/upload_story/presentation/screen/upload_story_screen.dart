import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/navigation/app_router.dart';
import 'package:storyzz/core/providers/auth_provider.dart';
import 'package:storyzz/core/providers/story_provider.dart';
import 'package:storyzz/core/utils/constants.dart';
import 'package:storyzz/core/variant/build_configuration.dart';
import 'package:storyzz/features/upload_story/presentation/providers/upload_story_provider.dart';
import 'package:storyzz/features/upload_story/presentation/widgets/camera_web_view.dart';
import 'package:storyzz/features/upload_story/presentation/widgets/image_preview.dart';
import 'package:storyzz/features/upload_story/presentation/widgets/location_map_selector.dart';
import 'package:storyzz/features/upload_story/presentation/widgets/premium_feature_promotion.dart';
import 'package:storyzz/features/upload_story/services/camera_service.dart';
import 'package:storyzz/features/upload_story/services/image_picker_services.dart';

/// A screen that allows users to upload a story with an image, caption, and optional location.
///
/// This screen provides the following features:
/// - Capturing or selecting an image from the gallery (web and mobile support).
/// - Writing a caption for the story.
/// - Selecting a location (only available on web or for premium users).
/// - Uploading the story via [UploadStoryProvider].
///
/// The camera and gallery behavior is abstracted via [CameraService] and [ImagePickerService].
/// Premium gating for location features is handled by [BuildConfig.canAddLocation].
class UploadStoryScreen extends StatefulWidget {
  const UploadStoryScreen({super.key});

  @override
  State<UploadStoryScreen> createState() => _UploadStoryScreenState();
}

class _UploadStoryScreenState extends State<UploadStoryScreen> {
  late final CameraService _cameraService;
  late final ImagePickerService _imagePickerService;
  late UploadStoryProvider _uploadStoryProvider;
  final TextEditingController _captionController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AppService _appService = AppService();

  @override
  void initState() {
    super.initState();
    _cameraService = CameraService();
    _imagePickerService = ImagePickerService();
    _captionController.text = context.read<UploadStoryProvider>().caption;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _uploadStoryProvider = context.read<UploadStoryProvider>();

    // initialize services with context
    _cameraService.initialize(context);
    _imagePickerService.initialize(context);
    if (_uploadStoryProvider.includeLocation) {
      _scrollToLocationSelector();
    }
  }

  @override
  void dispose() {
    // clean up camera to prevent memory leak
    _cameraService.cleanup();
    _captionController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _handleCameraButton() async {
    if (_appService.getKIsWeb()) {
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

    final token = authProvider.user?.token ?? "";
    double? lat;
    double? lon;

    // include location data if user enabled it
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
      _uploadStoryProvider.reset();
      _captionController.clear();

      // navigate to home screen
      context.navigateToHome();

      // refresh to get the latest stories
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
      _uploadStoryProvider.reset(); // reset all parameters
    } else if (_uploadStoryProvider.errorMessage != null) {
      // show snackbar upload failed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_uploadStoryProvider.errorMessage!)),
      );
    }
  }

  void _scrollToLocationSelector() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final uploadProvider = context.watch<UploadStoryProvider>();
    final imageFile = uploadProvider.imageFile;
    final isUploading = uploadProvider.isLoading;
    final showCamera = uploadProvider.showCamera;
    final AppService appService = AppService();

    // get build-time constant for web platform
    final appFlavor = const String.fromEnvironment(
      'APP_FLAVOR',
      defaultValue: 'free',
    );
    final isPaidVersion = appFlavor == 'paid';

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

              // button trigger to upload story
              child: IconButton(
                icon: const Icon(Icons.check),
                onPressed: isUploading ? null : _uploadStory,
              ),
            ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          controller: _scrollController,
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

                    // show caption field and location selector
                    if (imageFile != null && !showCamera) ...[
                      TextField(
                        controller: _captionController,
                        decoration: InputDecoration(
                          hintText:
                              AppLocalizations.of(context)!.write_a_caption,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        maxLines: 3,
                        onChanged: (value) {
                          uploadProvider.setCaption(value);
                        },
                      ),
                      const SizedBox(height: 16),

                      // Location Map Selector, handle based on
                      // build variant for android
                      // and
                      // build-time constants for web platform
                      if (appService.getKIsWeb()) ...[
                        if (isPaidVersion)
                          StatefulBuilder(
                            builder: (
                              BuildContext context,
                              StateSetter setState,
                            ) {
                              return LocationMapSelector();
                            },
                          )
                        else
                          PremiumFeaturePromotion(),
                      ] else if (Theme.of(context).platform ==
                          TargetPlatform.android) ...[
                        if (BuildConfig.canAddLocation) ...[
                          StatefulBuilder(
                            builder: (
                              BuildContext context,
                              StateSetter setState,
                            ) {
                              return LocationMapSelector();
                            },
                          ),
                        ] else ...[
                          PremiumFeaturePromotion(),
                        ],
                      ],
                      const SizedBox(height: 16),

                      // button to reset image
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
