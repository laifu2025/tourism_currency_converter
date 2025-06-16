import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _keyDefaultCurrency = 'default_currency';

  static Future<void> saveDefaultCurrency(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyDefaultCurrency, code);
  }

  static Future<String?> getDefaultCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyDefaultCurrency);
  }
} 