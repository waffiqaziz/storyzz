import 'dart:io';

import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/provider/auth_provider.dart';
import 'package:storyzz/core/provider/story_provider.dart';
import 'package:storyzz/core/provider/upload_story_provider.dart';
import 'package:storyzz/core/routes/my_route_delegate.dart';

class UploadStoryScreen extends StatefulWidget {
  const UploadStoryScreen({super.key});

  @override
  State<UploadStoryScreen> createState() => _UploadStoryScreenState();
}

class _UploadStoryScreenState extends State<UploadStoryScreen> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
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
                onPressed: () => _pickImage(ImageSource.camera),
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
        title: Text(
          'Upload Story',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          if (imageFile != null)
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
                    _buildImagePreview(imageFile),
                    const SizedBox(height: 16),
                    if (imageFile != null) ...[
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
