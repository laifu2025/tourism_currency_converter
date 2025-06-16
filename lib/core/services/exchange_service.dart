import 'dart:convert';
import 'package:http/http.dart' as http;

class ExchangeService {
  static Future<Map<String, double>> fetchRates(String base) async {
    final url = 'https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies/${base.toLowerCase()}.json';
    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      final rates = Map<String, dynamic>.from(data[base.toLowerCase()]);
      rates.remove('date');
      return rates.map((k, v) => MapEntry(k, (v as num).toDouble()));
    } else {
      throw Exception('Failed to fetch rates');
    }
  }
} 