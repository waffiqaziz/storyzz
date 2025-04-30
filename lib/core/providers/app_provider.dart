import 'package:flutter/material.dart';
import 'package:storyzz/core/data/networking/responses/list_story.dart';

class AppProvider extends ChangeNotifier {
  bool _isLanguageDialogOpen = false;
  bool get isLanguageDialogOpen => _isLanguageDialogOpen;

  bool _isUpDialogOpen = false;
  bool get isUpDialogOpen => _isUpDialogOpen;

  bool _isFromDetail = false;
  bool get isFromDetail => _isFromDetail;

  ListStory? _selectedStory;
  ListStory? get selectedStory => _selectedStory;

  bool _isRegister = false;
  bool get isRegister => _isRegister;

  bool _isLogin = false;
  bool get isLogin => _isLogin;

  bool _isFullScreenMap = false;
  bool get isFullScreenMap => _isFullScreenMap;

  void openLanguageDialog() {
    _isLanguageDialogOpen = true;
    notifyListeners();
  }

  void closeLanguageDialog() {
    _isLanguageDialogOpen = false;
    notifyListeners();
  }

  void openRegister() {
    _isRegister = true;
    _isLogin = false;
    notifyListeners();
  }

  void openLogin() {
    _isLogin = true;
    _isRegister = false;
    notifyListeners();
  }

  void resetAuthentication() {
    _isRegister = false;
    _isLogin = false;
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

  void openDetail(ListStory? story) {
    _selectedStory = story;
    _isFromDetail = false;
    notifyListeners();
  }

  void closeDetail() {
    _selectedStory = null;
    _isFromDetail = true;
    _isUpDialogOpen = false;
    _isFullScreenMap = false;
    notifyListeners();
  }

  void resetAll() {
    _isLanguageDialogOpen = false;
    _isUpDialogOpen = false;
    _isFullScreenMap = false;
    _isFromDetail = false;
    _selectedStory = null;
    _isFromDetail = false;
    notifyListeners();
  }

  void openFullScreenMap() {
    _isFullScreenMap = true;
    notifyListeners();
  }

  void closeFullScreenMap() {
    _isFullScreenMap = false;
    notifyListeners();
  }
}
