import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CurrencyProvider extends ChangeNotifier {
  Map<String, dynamic>? _currencies;
  bool _isLoading = false;
  String? _error;
  String? _selectedCurrencyCode;

  Map<String, dynamic>? get currencies => _currencies;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get selectedCurrencyCode => _selectedCurrencyCode;

  CurrencyProvider() {
    fetchCurrencies();
  }

  Future<void> fetchCurrencies() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final res = await http.get(Uri.parse('https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies.json'));
      if (res.statusCode == 200) {
        _currencies = json.decode(res.body) as Map<String, dynamic>;
      } else {
        _error = '网络错误: 状态码${res.statusCode}';
      }
    } catch (e) {
      _error = '加载失败: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSelectedCurrency(String code) {
    _selectedCurrencyCode = code;
    notifyListeners();
  }
} 