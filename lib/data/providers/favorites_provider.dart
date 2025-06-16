import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesProvider extends ChangeNotifier {
  static const _key = 'starred_currencies';
  Set<String> _favorites = {};

  Set<String> get favorites => _favorites;

  FavoritesProvider() {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    _favorites = prefs.getStringList(_key)?.toSet() ?? {};
    notifyListeners();
  }

  Future<void> toggleFavorite(String code) async {
    final prefs = await SharedPreferences.getInstance();
    if (_favorites.contains(code)) {
      _favorites.remove(code);
    } else {
      _favorites.add(code);
    }
    await prefs.setStringList(_key, _favorites.toList());
    notifyListeners();
  }

  Future<void> setFavorites(Set<String> codes) async {
    final prefs = await SharedPreferences.getInstance();
    _favorites = codes;
    await prefs.setStringList(_key, _favorites.toList());
    notifyListeners();
  }
} 