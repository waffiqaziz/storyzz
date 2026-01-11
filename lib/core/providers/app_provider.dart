import 'package:flutter/material.dart';
import 'package:storyzz/core/data/networking/models/story/list_story.dart';

class AppProvider extends ChangeNotifier {
  bool _isLanguageDialogOpen = false;
  bool get isLanguageDialogOpen => _isLanguageDialogOpen;

  bool _isUpDialogOpen = false;
  bool get isUpDialogOpen => _isUpDialogOpen;

  bool _isFromDetail = false;
  bool get isFromDetail => _isFromDetail;

  ListStory? _selectedStory;
  ListStory? get selectedStory => _selectedStory;

  bool _isUploadFullScreenMap = false;
  bool get isUploadFullScreenMap => _isUploadFullScreenMap;

  bool _isDetailFullScreenMap = false;
  bool get isDetailFullScreenMap => _isDetailFullScreenMap;

  bool _isLogoutDialogOpen = false;
  bool get isLogoutDialogOpen => _isLogoutDialogOpen;

  void openLanguageDialog() {
    _isLanguageDialogOpen = true;
    notifyListeners();
  }

  void closeLanguageDialog() {
    _isLanguageDialogOpen = false;
    notifyListeners();
  }

  void openUpgradeDialog() {
    _isUpDialogOpen = true;
    notifyListeners();
  }

  void closeUpgradeDialog() {
    _isUpDialogOpen = false;
    notifyListeners();
  }

  void openUploadMapFullScreen() {
    _isUploadFullScreenMap = true;
    notifyListeners();
  }

  void closeUploadMapFullScreen() {
    _isUploadFullScreenMap = false;
    notifyListeners();
  }

  void openDetailMapFullScreen() {
    _isDetailFullScreenMap = true;
    notifyListeners();
  }

  void closeDetailMapFullScreen() {
    _isDetailFullScreenMap = false;
    notifyListeners();
  }

  void openDetailScreen(ListStory? story) {
    _selectedStory = story;
    _isFromDetail = false;
    notifyListeners();
  }

  void closeDetailScreen() {
    _selectedStory = null;
    _isFromDetail = true;
    notifyListeners();
  }

  void openLogoutDialog() {
    _isLogoutDialogOpen = true;
    notifyListeners();
  }

  void closeLogoutDialog() {
    _isLogoutDialogOpen = false;
    notifyListeners();
  }
}
