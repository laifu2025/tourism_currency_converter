import 'package:flutter/material.dart';
import '../../core/services/storage_service.dart';

class SettingsProvider extends ChangeNotifier {
  String? _defaultCurrency;

  String? get defaultCurrency => _defaultCurrency;

  Future<void> loadDefaultCurrency() async {
    _defaultCurrency = await StorageService.getDefaultCurrency();
    notifyListeners();
  }

  Future<void> setDefaultCurrency(String code) async {
    if (_defaultCurrency != code) {
      _defaultCurrency = code;
      await StorageService.saveDefaultCurrency(code);
      notifyListeners();
    }
  }
} 