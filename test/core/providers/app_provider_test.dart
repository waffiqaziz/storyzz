import 'package:flutter_test/flutter_test.dart';
import 'package:storyzz/core/data/networking/models/story/list_story.dart';
import 'package:storyzz/core/providers/app_provider.dart';

void main() {
  late AppProvider appProvider;

  setUp(() {
    appProvider = AppProvider();
  });

  group('AppProvider', () {
    test('all initial state should be false and null', () {
      expect(appProvider.isDetailFullScreenMap, false);
      expect(appProvider.isFromDetail, false);
      expect(appProvider.isLanguageDialogOpen, false);
      expect(appProvider.isUpDialogOpen, false);
      expect(appProvider.isUploadFullScreenMap, false);
      expect(appProvider.isLogoutDialogOpen, false);
      expect(appProvider.selectedStory, null);
    });

    test('should handle language dialog operations', () {
      appProvider.openLanguageDialog();
      expect(appProvider.isLanguageDialogOpen, true);

      appProvider.closeLanguageDialog();
      expect(appProvider.isLanguageDialogOpen, false);
    });

    test('should handle upgrade dialog operations', () {
      appProvider.openUpgradeDialog();
      expect(appProvider.isUpDialogOpen, true);

      appProvider.closeUpgradeDialog();
      expect(appProvider.isUpDialogOpen, false);
    });

    test('should handle upload full screen map operations', () {
      appProvider.openUploadMapFullScreen();
      expect(appProvider.isUploadFullScreenMap, true);

      appProvider.closeUploadMapFullScreen();
      expect(appProvider.isUploadFullScreenMap, false);
    });

    test('should handle detail full screen map operations', () {
      appProvider.openDetailMapFullScreen();
      expect(appProvider.isDetailFullScreenMap, true);

      appProvider.closeDetailMapFullScreen();
      expect(appProvider.isDetailFullScreenMap, false);
    });

    test('should handle dialog logout operations', () {
      appProvider.openLogoutDialog();
      expect(appProvider.isLogoutDialogOpen, true);

      appProvider.closeLogoutDialog();
      expect(appProvider.isLogoutDialogOpen, false);
    });

    test('should handle story detail operations', () {
      final mockStory = ListStory(
        id: '1',
        name: 'Test Story',
        description: 'Test Description',
        photoUrl: 'test.jpg',
        createdAt: DateTime.now(),
        lat: 0.0,
        lon: 0.0,
      );

      appProvider.openDetailScreen(mockStory);
      expect(appProvider.selectedStory, mockStory);
      expect(appProvider.isFromDetail, false);

      appProvider.closeDetailScreen();
      expect(appProvider.selectedStory, null);
      expect(appProvider.isFromDetail, true);
    });
  });
}
