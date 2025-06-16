import 'package:flutter/material.dart';

class ButtonVisibilityProvider extends ChangeNotifier {
  bool _isButtonVisible = false;

  bool get isButtonVisible => _isButtonVisible;

  void setButtonVisibility(bool isVisible) {
    if (_isButtonVisible != isVisible) {
      _isButtonVisible = isVisible;
      notifyListeners();
    }
  }
} 