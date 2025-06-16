import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ExchangeData {
  final Map<String, double> rates;
  final DateTime lastUpdated;
  final bool isOffline;

  ExchangeData({
    required this.rates,
    required this.lastUpdated,
    this.isOffline = false,
  });
}

class ExchangeService {
  static const String _ratesPrefix = 'rates_';
  static const String _timestampPrefix = 'timestamp_';

  static Future<ExchangeData> fetchRates(String base) async {
    final lowerCaseBase = base.toLowerCase();
    try {
      final url = 'https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies/$lowerCaseBase.json';
      final res = await http.get(Uri.parse(url));

      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        final ratesData = Map<String, dynamic>.from(data[lowerCaseBase]);
        final rates = ratesData.map((k, v) => MapEntry(k, (v as num).toDouble()));
        
        final now = DateTime.now();
        await _saveToCache(lowerCaseBase, rates, now);

        return ExchangeData(rates: rates, lastUpdated: now);
      } else {
        return await _loadFromCache(lowerCaseBase, error: 'Server error: ${res.statusCode}');
      }
    } catch (e) {
      return await _loadFromCache(lowerCaseBase, error: 'Network error: ${e.toString()}');
    }
  }

  static Future<void> _saveToCache(String base, Map<String, double> rates, DateTime timestamp) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$_ratesPrefix$base', json.encode(rates));
    await prefs.setString('$_timestampPrefix$base', timestamp.toIso8601String());
  }

  static Future<ExchangeData> _loadFromCache(String base, {required String error}) async {
    final prefs = await SharedPreferences.getInstance();
    final ratesJson = prefs.getString('$_ratesPrefix$base');
    final timestampString = prefs.getString('$_timestampPrefix$base');

    if (ratesJson != null && timestampString != null) {
      final rates = Map<String, double>.from(json.decode(ratesJson));
      final lastUpdated = DateTime.parse(timestampString);
      return ExchangeData(rates: rates, lastUpdated: lastUpdated, isOffline: true);
    } else {
      throw Exception('Failed to fetch rates and no cache available. Error: $error');
    }
  }
} 